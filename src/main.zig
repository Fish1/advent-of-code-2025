const std = @import("std");
const day1 = @import("day1");
const day2 = @import("day2");

pub fn main() !void {
    const answer_day1_part1 = try day1.find_password(50, "./src/day1/input.txt");
    std.debug.print("day1 part1: {d}\n", .{answer_day1_part1});

    const answer_day1_part2 = try day1.find_password_434C49434B(50, "./src/day1/input.txt");
    std.debug.print("day1 part2: {d}\n", .{answer_day1_part2});

    const answer_day2_part1 = try day2.total_invalid("./src/day2/input.txt", .TWICE);
    std.debug.print("day2 part1: {d}\n", .{answer_day2_part1});

    const answer_day2_part2 = try day2.total_invalid("./src/day2/input.txt", .MULTIPLE);
    std.debug.print("day2 part2: {d}\n", .{answer_day2_part2});
}
