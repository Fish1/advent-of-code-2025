const std = @import("std");

pub fn accessible_rolls(input: []const u8) !usize {
    var buffer: [1024]u8 = undefined;

    const file = try std.fs.cwd().openFile(input, .{ .mode = .read_only });
    defer file.close();

    var reader = file.reader(&buffer);

    var counts = std.AutoHashMap(usize, usize).init(std.heap.page_allocator);
    defer counts.deinit();

    var width: usize = 0;
    var y: usize = 0;

    var prev_line: ?[]u8 = null;

    var total: usize = 0;

    while (true) {
        const line = reader.interface.takeDelimiterInclusive('\n') catch {
            break;
        };

        width = line.len - 1;

        for (0..width) |x| {
            if (line[x] != '@') {
                continue;
            }

            total = total + 1;

            const map_index = (width * y) + x;

            const left = x > 0 and line[x - 1] == '@';
            const right = x < width - 1 and line[x + 1] == '@';
            var next_to: usize = @as(usize, 0) + @intFromBool(left) + @intFromBool(right);

            if (prev_line) |pl| {
                const up_left = x > 0 and pl[x - 1] == '@';
                const up = pl[x] == '@';
                const up_right = x < width - 1 and pl[x + 1] == '@';
                next_to = next_to + @intFromBool(up_left) + @intFromBool(up) + @intFromBool(up_right);
            }

            const current = counts.get(map_index) orelse 0;
            const new = current + next_to;
            try counts.put(map_index, new);
            if (current < 4 and new >= 4) {
                total = total - 1;
            }
        }

        if (prev_line) |pl| {
            for (0..pl.len - 1) |px| {
                if (pl[px] != '@') {
                    continue;
                }
                const prev_map_index = (width * (y - 1)) + px;
                const down_left = px > 0 and line[px - 1] == '@';
                const down = line[px] == '@';
                const down_right = px < width - 1 and line[px + 1] == '@';

                const current = counts.get(prev_map_index) orelse 0;
                const new = current + @intFromBool(down_left) + @intFromBool(down) + @intFromBool(down_right);
                try counts.put(prev_map_index, new);
                if (current < 4 and new >= 4) {
                    total = total - 1;
                }
            }
        }

        prev_line = line;
        y = y + 1;
    }

    return total;
}

test "example" {
    const result = try accessible_rolls("./src/day4/test_input.txt");
    try std.testing.expectEqual(13, result);
}
