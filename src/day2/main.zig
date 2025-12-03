const std = @import("std");

pub const Mode = enum {
    TWICE,
    MULTIPLE,
};

pub fn total_invalid(input: []const u8, mode: Mode) !usize {
    const allocator = std.heap.page_allocator;

    var total: usize = 0;
    var buffer: [1024]u8 = undefined;
    const file = try std.fs.cwd().openFile(input, .{ .mode = .read_only });
    defer file.close();

    var reader = file.reader(&buffer);

    const data = try reader.interface.allocRemaining(allocator, .unlimited);
    defer allocator.free(data);

    var range_string = std.mem.splitAny(u8, data, ",");
    while (range_string.next()) |value| {
        var start_end = std.mem.splitAny(u8, value, "-");
        const start_string = start_end.next() orelse unreachable;
        const end_string = start_end.next() orelse unreachable;

        const start = try std.fmt.parseInt(usize, start_string, 10);
        const end = try std.fmt.parseInt(usize, end_string, 10);

        for (start..end + 1) |number| {
            switch (mode) {
                .TWICE => {
                    if (number_is_valid_twice(@intCast(number)) == false) {
                        total = total + number;
                    }
                },
                .MULTIPLE => {
                    if (number_is_valid_multiple(@intCast(number)) == false) {
                        total = total + number;
                    }
                },
            }
        }
    }

    return total;
}

fn number_of_digits(input: i64) usize {
    const float_input: f64 = @floatFromInt(input);
    const temp: usize = @intFromFloat(@floor(@log10(float_input)));
    return temp + 1;
}

fn get_sub_number(input: i64, start: usize, amount: usize) i64 {
    const div: i64 = @intCast(std.math.pow(usize, 10, start));
    const top: i64 = @divTrunc(input, div);
    const bot: i64 = std.math.pow(i64, 10, @intCast(amount));
    return @mod(top, bot);
}

fn number_is_valid_twice(input: i64) bool {
    const digits = number_of_digits(input);
    if (@mod(digits, 2) != 0) {
        return true;
    }

    const half: usize = @divExact(digits, 2);

    const top = get_sub_number(input, half, half);
    const bottom = get_sub_number(input, 0, half);

    if (top == bottom) {
        return false;
    }

    return true;
}

fn number_is_valid_multiple(input: i64) bool {
    const digits = number_of_digits(input);
    const max_checks: usize = @divTrunc(digits, 2);

    for (1..max_checks + 1) |index| {
        if (@mod(digits, index) != 0) {
            continue;
        }
        const check = get_sub_number(input, 0, index);

        const max_internal_checks: usize = @divTrunc(digits, index);

        var all_duplicate = true;

        for (1..max_internal_checks) |internal_index| {
            const to_check = get_sub_number(input, internal_index * index, index);

            if (to_check != check) {
                all_duplicate = false;
                break;
            }
        }

        if (all_duplicate == true) {
            return false;
        }
    }

    return true;
}

test "total invalid twice" {
    const result = try total_invalid("./src/day2/test_input.txt", .TWICE);
    try std.testing.expectEqual(1227775554, result);
}

test "total invalid multiple" {
    const result = try total_invalid("./src/day2/test_input.txt", .MULTIPLE);
    try std.testing.expectEqual(4174379265, result);
}

test "number of digits" {
    for (1..10) |x| {
        const t = std.math.pow(usize, 10, x);
        const r = number_of_digits(@intCast(t));
        try std.testing.expectEqual(r, x + 1);
    }
}

test "subnumbers" {
    const x = 12345678;
    var s = get_sub_number(x, 0, 3);
    try std.testing.expectEqual(678, s);
    s = get_sub_number(x, 1, 2);
    try std.testing.expectEqual(67, s);
    s = get_sub_number(x, 2, 2);
    try std.testing.expectEqual(56, s);
}

test "number is invalid" {
    var x: i64 = 12345678;
    var r: bool = number_is_valid_multiple(x);
    x = 111222111222;
    r = number_is_valid_multiple(x);
}
