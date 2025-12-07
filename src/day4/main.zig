const std = @import("std");

pub const Mode = enum {
    SINGLE_PASS,
    MULTIPLE_PASS,
};

pub fn accessible_rolls(input: []const u8, mode: Mode) !usize {
    var buffer: [1024]u8 = undefined;
    var prev_buffer: [1024]u8 = undefined;

    const file = try std.fs.cwd().openFile(input, .{ .mode = .read_only });
    defer file.close();

    var reader = file.reader(&buffer);

    var counts = std.AutoHashMap(usize, usize).init(std.heap.page_allocator);
    defer counts.deinit();

    var y: usize = 0;

    var prev_line: ?[]u8 = null;

    var total: usize = 0;

    var curr_width: usize = 0;

    while (true) {
        const line = reader.interface.takeDelimiterInclusive('\n') catch {
            break;
        };

        curr_width = line.len - 1;

        for (0..curr_width) |x| {
            if (line[x] != '@') {
                continue;
            }

            total = total + 1;

            const map_index = (curr_width * y) + x;
            const left = x > 0 and line[x - 1] == '@';
            const right = x < curr_width - 1 and line[x + 1] == '@';
            var next_to: usize = @as(usize, 0) + @intFromBool(left) + @intFromBool(right);

            if (prev_line) |pl| {
                const up_left = x > 0 and pl[x - 1] == '@';
                const up = pl[x] == '@';
                const up_right = x < curr_width - 1 and pl[x + 1] == '@';
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
            const prev_width = pl.len - 1;
            for (0..prev_width) |px| {
                const prev_map_index = (prev_width * (y - 1)) + px;
                if (pl[px] != '@') {
                    continue;
                }
                const down_left = px > 0 and line[px - 1] == '@';
                const down = line[px] == '@';
                const down_right = px < prev_width - 1 and line[px + 1] == '@';

                const current = counts.get(prev_map_index) orelse unreachable;
                const new = current + @intFromBool(down_left) + @intFromBool(down) + @intFromBool(down_right);
                try counts.put(prev_map_index, new);
                if (current < 4 and new >= 4) {
                    total = total - 1;
                }
            }
        }

        @memcpy(prev_buffer[0..line.len], line);
        prev_line = prev_buffer[0..line.len];

        y = y + 1;
    }

    if (mode == .SINGLE_PASS) {
        return total;
    }

    var done: bool = false;
    while (done == false) {
        done = true;

        var ci = counts.iterator();
        while (ci.next()) |e| {
            if (e.value_ptr.* < 4) {
                continue;
            }

            const xx = e.key_ptr.* % curr_width;
            const yy = e.key_ptr.* / curr_width;

            var tt: usize = 0;
            if (yy > 0 and xx > 0) {
                const up_left = counts.get((curr_width * (yy - 1)) + (xx - 1)) orelse 0;
                tt = tt + @intFromBool(up_left >= 4);
            }

            if (yy > 0) {
                const up = counts.get((curr_width * (yy - 1)) + xx) orelse 0;
                tt = tt + @intFromBool(up >= 4);
            }

            if (yy > 0 and xx < curr_width) {
                const up_right = counts.get((curr_width * (yy - 1)) + (xx + 1)) orelse 0;
                tt = tt + @intFromBool(up_right >= 4);
            }

            if (xx > 0) {
                const left = counts.get((curr_width * yy) + (xx - 1)) orelse 0;
                tt = tt + @intFromBool(left >= 4);
            }

            if (xx < curr_width) {
                const right = counts.get((curr_width * yy) + (xx + 1)) orelse 0;
                tt = tt + @intFromBool(right >= 4);
            }

            if (yy < y and xx > 0) {
                const down_left = counts.get((curr_width * (yy + 1)) + (xx - 1)) orelse 0;
                tt = tt + @intFromBool(down_left >= 4);
            }

            if (yy < y) {
                const down = counts.get((curr_width * (yy + 1)) + xx) orelse 0;
                tt = tt + @intFromBool(down >= 4);
            }

            if (yy < y and xx < curr_width) {
                const down_right = counts.get((curr_width * (yy + 1)) + (xx + 1)) orelse 0;
                tt = tt + @intFromBool(down_right >= 4);
            }

            if (tt < 4) {
                total = total + 1;
                done = false;
                _ = counts.remove((curr_width * yy) + xx);
            }
        }
    }

    return total;
}

test "test single pass" {
    const result = try accessible_rolls("./src/day4/test_input.txt", .SINGLE_PASS);
    try std.testing.expectEqual(13, result);
}

test "test multi pass" {
    const result = try accessible_rolls("./src/day4/test_input.txt", .MULTIPLE_PASS);
    try std.testing.expectEqual(43, result);
}

test "real single pass" {
    const result = try accessible_rolls("./src/day4/input.txt", .SINGLE_PASS);
    try std.testing.expectEqual(1445, result);
}
