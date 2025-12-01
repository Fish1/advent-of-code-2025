const std = @import("std");

const Direction = enum {
    LEFT,
    RIGHT,
};

const Dial = struct {
    position: i32,

    pub fn rotate(self: *Dial, direction: Direction, amount: i32) void {
        if (direction == .LEFT) {
            self.position = self.position - amount;
        } else if (direction == .RIGHT) {
            self.position = self.position + amount;
        }
        self.position = @mod(self.position, 100);
    }

    pub fn print(self: Dial) void {
        std.debug.print("{d}\n", .{self.position});
    }
};

pub fn doThing() void {
    var dial = Dial{
        .position = 50,
    };
    dial.print();
    dial.rotate(.LEFT, 68);
    dial.print();
    dial.rotate(.LEFT, 30);
    dial.print();
    dial.rotate(.RIGHT, 48);
    dial.print();
}

test "do a test thing" {
    const allocator = std.testing.allocator;
    // try std.fs.cwd().makeDir("testing");
    const file = try std.fs.cwd().openFile("./src/day1/input.txt", .{});
    defer file.close();

    //  var buffer: [4096]u8 = undefined;
    // var reader = std.fs.File.stdin().reader(&buffer);

    const content = try file.readToEndAlloc(allocator, std.math.maxInt(usize));

    std.debug.print("{s}\n", .{content});

    var dial = Dial{
        .position = 50,
    };
    dial.print();
    dial.rotate(.LEFT, 68);
    dial.print();
    dial.rotate(.LEFT, 30);
    dial.print();
    dial.rotate(.RIGHT, 48);
    dial.print();
}
