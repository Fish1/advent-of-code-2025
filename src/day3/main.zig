const std = @import("std");

pub fn total_jolts(input: []const u8, batteries: usize) !usize {
    var buffer: [1024]u8 = undefined;
    const file = try std.fs.cwd().openFile(input, .{ .mode = .read_only });
    defer file.close();

    var reader = file.reader(&buffer);

    var total: usize = 0;

    while (true) {
        const line = reader.interface.takeDelimiterInclusive('\n') catch |err| {
            switch (err) {
                error.EndOfStream, error.ReadFailed => break,
                else => return err,
            }
        };

        if (line.len < batteries + 1) {
            continue;
        }

        var jolts: usize = 0;
        var start_index: usize = 0;

        for (0..batteries) |index| {
            const diff = batteries - index - 1;
            const largest_index = largest_index_not_last(line, start_index, line.len - diff - 1);
            const largest_value = line[largest_index] - 48;
            jolts = jolts + (largest_value * std.math.pow(usize, 10, diff));
            start_index = largest_index + 1;
        }

        total = total + jolts;
    }

    return total;
}

fn largest_index_not_last(number: []const u8, start: usize, end: usize) usize {
    var largest_index: usize = start;
    var largest_value = number[start];
    for (start..end) |i| {
        const n = number[i];
        if (n > largest_value) {
            largest_index = i;
            largest_value = n;
        }
    }
    return largest_index;
}

test "test two batteries" {
    const total = try total_jolts("./src/day3/test_input.txt", 2);
    try std.testing.expectEqual(357, total);
}

test "test twelve batteries" {
    const total = try total_jolts("./src/day3/test_input.txt", 12);
    try std.testing.expectEqual(3121910778619, total);
}

