const std = @import("std");
const day1 = @import("day1");

pub fn main() !void {
    const answer_day1_part1 = day1.find_password(50, "./src/day1/input.txt");
    std.debug.print("day1 part1: {any}\n", .{answer_day1_part1});

    const answer_day1_part2 = day1.find_password_434C49434B(50, "./src/day1/input.txt");
    std.debug.print("day1 part2: {any}\n", .{answer_day1_part2});
}
