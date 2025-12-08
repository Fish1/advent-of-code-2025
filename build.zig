const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const day1 = b.addModule("day1", .{
        .root_source_file = b.path("src/day1/main.zig"),
        .target = target,
    });

    const day2 = b.addModule("day2", .{
        .root_source_file = b.path("src/day2/main.zig"),
        .target = target,
    });

    const day3 = b.addModule("day3", .{
        .root_source_file = b.path("src/day3/main.zig"),
        .target = target,
    });

    const day4 = b.addModule("day4", .{
        .root_source_file = b.path("src/day4/main.zig"),
        .target = target,
    });

    const day5 = b.addModule("day5", .{
        .root_source_file = b.path("src/day5/main.zig"),
        .target = target,
    });

    const exe = b.addExecutable(.{
        .name = "advent_of_code_2025",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "day1", .module = day1 },
                .{ .name = "day2", .module = day2 },
                .{ .name = "day3", .module = day3 },
                .{ .name = "day4", .module = day4 },
                .{ .name = "day5", .module = day5 },
            },
        }),
    });

    b.installArtifact(exe);

    const run_step = b.step("run", "Run the app");

    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const day1_tests = b.addTest(.{
        .root_module = day1,
    });
    const run_day1_tests = b.addRunArtifact(day1_tests);

    const day2_tests = b.addTest(.{
        .root_module = day2,
    });
    const run_day2_tests = b.addRunArtifact(day2_tests);

    const day3_tests = b.addTest(.{
        .root_module = day3,
    });
    const run_day3_tests = b.addRunArtifact(day3_tests);

    const day4_tests = b.addTest(.{
        .root_module = day4,
    });
    const run_day4_tests = b.addRunArtifact(day4_tests);

    const day5_tests = b.addTest(.{
        .root_module = day5,
    });
    const run_day5_tests = b.addRunArtifact(day5_tests);

    const exe_tests = b.addTest(.{
        .root_module = exe.root_module,
    });
    const run_exe_tests = b.addRunArtifact(exe_tests);

    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_day1_tests.step);
    test_step.dependOn(&run_day2_tests.step);
    test_step.dependOn(&run_day3_tests.step);
    test_step.dependOn(&run_day4_tests.step);
    test_step.dependOn(&run_day5_tests.step);
    test_step.dependOn(&run_exe_tests.step);
}
