const std = @import("std");

const RotateDirection = enum {
    LEFT,
    RIGHT,
};

fn rotate(current: i32, direction: RotateDirection, amount: i32) struct { passes: u32, value: i32 } {
    const new_value = switch (direction) {
        .LEFT => current - amount,
        .RIGHT => current + amount,
    };

    var passes = @abs(@divFloor(new_value, 100));

    if (direction == .LEFT) {
        if (current == 0 and passes > 0) {
            passes = passes - 1;
        }

        if (@mod(new_value, 100) == 0) {
            passes = passes + 1;
        }
    }

    return .{
        .passes = passes,
        .value = @mod(new_value, 100),
    };
}

pub fn find_password(dial_position_start: i32, directions: []const u8) !i32 {
    var dial_position = dial_position_start;
    var password: i32 = 0;
    var buffer: [128]u8 = undefined;

    const file = try std.fs.cwd().openFile(directions, .{});
    defer file.close();

    var reader = file.reader(&buffer);

    while (true) {
        const line = reader.interface.takeDelimiterInclusive('\n') catch |err| {
            switch (err) {
                error.EndOfStream, error.ReadFailed => break,
                else => return err,
            }
        };

        if (line[0] == '\n') {
            break;
        }

        const direction_string = line[0];
        const direction = switch (direction_string) {
            'L' => RotateDirection.LEFT,
            'R' => RotateDirection.RIGHT,
            else => unreachable,
        };
        var line_reader = std.Io.Reader{ .vtable = undefined, .buffer = line[1..], .seek = 0, .end = line.len - 1 };
        const amount_string = try line_reader.takeDelimiterExclusive('\n');
        const amount = try std.fmt.parseInt(i32, amount_string, 10);

        dial_position = rotate(dial_position, direction, amount).value;

        if (dial_position == 0) {
            password = password + 1;
        }
    }

    return password;
}

pub fn find_password_434C49434B(dial_position_start: i32, directions: []const u8) !u32 {
    var dial_position = dial_position_start;
    var password: u32 = 0;
    var buffer: [128]u8 = undefined;

    const file = try std.fs.cwd().openFile(directions, .{});
    defer file.close();

    var reader = file.reader(&buffer);

    while (true) {
        const line = reader.interface.takeDelimiterInclusive('\n') catch |err| {
            switch (err) {
                error.EndOfStream, error.ReadFailed => break,
                else => return err,
            }
        };

        if (line[0] == '\n') {
            break;
        }

        const direction_string = line[0];
        const direction = switch (direction_string) {
            'L' => RotateDirection.LEFT,
            'R' => RotateDirection.RIGHT,
            else => unreachable,
        };
        var line_reader = std.Io.Reader{ .vtable = undefined, .buffer = line[1..], .seek = 0, .end = line.len - 1 };
        const amount_string = try line_reader.takeDelimiterExclusive('\n');
        const amount = try std.fmt.parseInt(i32, amount_string, 10);

        const rotate_result = rotate(dial_position, direction, amount);
        dial_position = rotate_result.value;
        password = password + rotate_result.passes;
    }

    return password;
}

test "find password on test input" {
    const password = try find_password(50, "./src/day1/test_input.txt");
    try std.testing.expectEqual(3, password);
}

test "find password 434C49434B on test input" {
    const password = try find_password_434C49434B(50, "./src/day1/test_input.txt");
    try std.testing.expectEqual(6, password);
}
