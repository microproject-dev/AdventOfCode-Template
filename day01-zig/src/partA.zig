const std = @import("std");
const common = @import("common");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const file = try std.fs.cwd().openFile("input/input.txt", .{});
    defer file.close();
    const input = try file.readToEndAlloc(allocator, std.math.maxInt(usize));

    const out = try solve(allocator, input);
    defer allocator.free(out);
    std.debug.print("PartA: {s}\n", .{out});
}

pub fn solve(allocator: std.mem.Allocator, input: []const u8) ![]const u8 {
    // std.debug.print("Input: {s}", .{input});
    var parsed = try common.parseInput(allocator, input);
    defer parsed.deinit(allocator);
    // std.debug.print("{any}", .{parsed});

    var wheel: i32 = 50;
    var zeros: u32 = 0;
    // std.debug.print("{d}\n", .{wheel});
    for (parsed.items) |a| {
        wheel += a;
        if (wheel > 99) {
            wheel = @mod(wheel, 100);
        }
        while (wheel < 0) {
            wheel += 100;
        }
        if (wheel == 0) {
            zeros += 1;
        }
        // std.debug.print("{d} -> {d}\n", .{ a, wheel });
    }
    return std.fmt.allocPrint(allocator, "{d}", .{zeros});
}

test "simple test" {
    const allocator = std.testing.allocator;
    const input =
        \\L68
        \\L30
        \\R48
        \\L5
        \\R60
        \\L55
        \\L1
        \\L99
        \\R14
        \\L82
    ;

    const out = try solve(allocator, input);
    defer allocator.free(out);

    try std.testing.expectEqualStrings("3", out);
}
