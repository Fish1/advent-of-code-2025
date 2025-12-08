const std = @import("std");

const Range = struct {
    start: usize,
    end: usize,
};

pub fn fresh_ingredients(input: []const u8) !struct { fresh: usize, total_possible: usize } {
    var ranges = try std.ArrayList(Range).initCapacity(std.heap.page_allocator, 10);

    const file = try std.fs.cwd().openFile(input, .{ .mode = .read_only });
    defer file.close();

    var buffer: [1024]u8 = undefined;
    var reader = file.reader(&buffer);

    var total: usize = 0;
    while (true) {
        const line = reader.interface.takeDelimiter('\n') catch {
            break;
        } orelse break;

        if (line.len == 0) {
            var to_delete_index = try std.ArrayList(usize).initCapacity(std.heap.page_allocator, 10);
            // std.debug.print("ranges = {any}\n", .{ranges});
            for (ranges.items) |*r1| {
                var still_working = true;
                while (still_working) {
                    still_working = false;
                    for (0.., ranges.items) |i, r2| {
                        if (r2.start >= r1.start and r2.start <= r1.end and r2.end > r1.end) {
                            r1.end = r2.end;
                            still_working = true;
                            to_delete_index.append(std.heap.page_allocator, i);
                        }

                        if (r2.end >= r1.start and r2.end <= r1.end and r2.start < r1.start) {
                            r1.start = r2.start;
                            still_working = true;
                            to_delete_index.append(std.heap.page_allocator, i);
                        }

                        if (r2.start < r1.start and r2.end > r1.end) {
                            r1.start = r2.start;
                            r1.end = r2.end;
                            still_working = true;
                            to_delete_index.append(std.heap.page_allocator, i);
                        }
                    }
                }
            }
            // std.debug.print("ranges = {any}\n", .{ranges});
            continue;
        }

        var x = std.mem.splitAny(u8, line, "-");

        const a = x.next();
        const b = x.next();

        if (a != null and b == null) {
            const id = try std.fmt.parseInt(usize, a.?, 10);
            for (ranges.items) |r| {
                if (id >= r.start and id <= r.end) {
                    total = total + 1;
                    break;
                }
            }
        }

        if (a != null and b != null) {
            const start = try std.fmt.parseInt(usize, a.?, 10);
            const end = try std.fmt.parseInt(usize, b.?, 10);
            try ranges.append(std.heap.page_allocator, .{
                .start = start,
                .end = end,
            });
        }
    }

    return .{
        .fresh = total,
        .total_possible = 0,
    };
}

test "test input" {
    const r = fresh_ingredients("./src/day5/test_input.txt");
    try std.testing.expectEqual(3, r);
}
