const std = @import("std");
const day1 = @import("day1");
const day2 = @import("day2");
const day3 = @import("day3");
const day4 = @import("day4");
const day5 = @import("day5");

pub fn main() !void {
    const answer_day1_part1 = try day1.find_password(50, "./src/day1/input.txt");
    std.debug.print("day1 part1: {d}\n", .{answer_day1_part1});

    const answer_day1_part2 = try day1.find_password_434C49434B(50, "./src/day1/input.txt");
    std.debug.print("day1 part2: {d}\n", .{answer_day1_part2});

    const answer_day2_part1 = try day2.total_invalid("./src/day2/input.txt", .TWICE);
    std.debug.print("day2 part1: {d}\n", .{answer_day2_part1});

    const answer_day2_part2 = try day2.total_invalid("./src/day2/input.txt", .MULTIPLE);
    std.debug.print("day2 part2: {d}\n", .{answer_day2_part2});

    const answer_day3_part1 = try day3.total_jolts("./src/day3/input.txt", 2);
    std.debug.print("day3 part1: {d}\n", .{answer_day3_part1});

    const answer_day3_part2 = try day3.total_jolts("./src/day3/input.txt", 12);
    std.debug.print("day3 part2: {d}\n", .{answer_day3_part2});

    const answer_day4_part1 = try day4.accessible_rolls("./src/day4/input.txt", .SINGLE_PASS);
    std.debug.print("day4 part1: {d}\n", .{answer_day4_part1});

    const answer_day4_part2 = try day4.accessible_rolls("./src/day4/input.txt", .MULTIPLE_PASS);
    std.debug.print("day4 part2: {d}\n", .{answer_day4_part2});

    const answer_day5_part1 = try day5.fresh_ingredients("./src/day5/input.txt");
    std.debug.print("day5 part1: {d}\n", .{answer_day5_part1});
}
