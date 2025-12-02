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
    std.debug.print("PartB: {s}\n", .{out});
}

pub fn solve(allocator: std.mem.Allocator, input: []const u8) ![]const u8 {
    // std.debug.print("Input: {s}", .{input});
    var parsed = try common.parseInput(allocator, input);
    defer parsed.deinit(allocator);
    // std.debug.print("{any}", .{parsed});

    var wheel: i32 = 50;
    var clicks: u32 = 0;
    // std.debug.print("{d}\n", .{wheel});
    for (parsed.items) |a| {
        const zeroStart = wheel == 0;
        wheel += a;
        if (wheel < 0 or wheel > 99) {
            if (wheel < 0) {
                clicks += (@abs(wheel) / 100) + 1;
                if (zeroStart) {
                    clicks -= 1;
                }
            } else if (wheel > 99) {
                clicks += @abs(wheel) / 100;
            }
            wheel = @mod(wheel, 100);
        } else {
            if (wheel == 0) {
                clicks += 1;
            }
        }
        // std.debug.print("{d} -> {d} {d}\n", .{ a, wheel, clicks });
    }
    return std.fmt.allocPrint(allocator, "{d}", .{clicks});
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

    try std.testing.expectEqualStrings("6", out);
}

test "tims test" {
    const allocator = std.testing.allocator;
    const input =
        \\L51
        \\R1
    ;

    const out = try solve(allocator, input);
    defer allocator.free(out);

    try std.testing.expectEqualStrings("2", out);
}

test "tims2 test" {
    const allocator = std.testing.allocator;
    const input =
        \\L51
        \\R2
    ;

    const out = try solve(allocator, input);
    defer allocator.free(out);

    try std.testing.expectEqualStrings("2", out);
}

test "tims3 test" {
    const allocator = std.testing.allocator;
    const input =
        \\R51
        \\L1
    ;

    const out = try solve(allocator, input);
    defer allocator.free(out);

    try std.testing.expectEqualStrings("2", out);
}

test "tims4 test" {
    const allocator = std.testing.allocator;
    const input =
        \\R51
        \\L2
    ;

    const out = try solve(allocator, input);
    defer allocator.free(out);

    try std.testing.expectEqualStrings("2", out);
}

test "tims5 test" {
    const allocator = std.testing.allocator;
    const input =
        \\R50
        \\L1
    ;

    const out = try solve(allocator, input);
    defer allocator.free(out);

    try std.testing.expectEqualStrings("1", out);
}

test "tims6 test" {
    const allocator = std.testing.allocator;
    const input =
        \\L50
        \\R1
    ;

    const out = try solve(allocator, input);
    defer allocator.free(out);

    try std.testing.expectEqualStrings("1", out);
}

test "tims7 test" {
    const allocator = std.testing.allocator;
    const input =
        \\L50
        \\L1
    ;

    const out = try solve(allocator, input);
    defer allocator.free(out);

    try std.testing.expectEqualStrings("1", out);
}

test "tims8 test" {
    const allocator = std.testing.allocator;
    const input =
        \\L50
        \\L538
    ;

    const out = try solve(allocator, input);
    defer allocator.free(out);

    try std.testing.expectEqualStrings("6", out);
}

test "tims9 test" {
    const allocator = std.testing.allocator;
    const input =
        \\R50
        \\R538
    ;

    const out = try solve(allocator, input);
    defer allocator.free(out);

    try std.testing.expectEqualStrings("6", out);
}

test "tims10 test" {
    const allocator = std.testing.allocator;
    const input =
        \\R50
        \\R100
    ;

    const out = try solve(allocator, input);
    defer allocator.free(out);

    try std.testing.expectEqualStrings("2", out);
}

test "tims11 test" {
    const allocator = std.testing.allocator;
    const input =
        \\R50
        \\L100
    ;

    const out = try solve(allocator, input);
    defer allocator.free(out);

    try std.testing.expectEqualStrings("2", out);
}
