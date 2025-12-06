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
    _ = input;
    return std.fmt.allocPrint(allocator, "", .{});
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
