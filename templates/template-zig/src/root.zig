//! By convention, root.zig is the root source file when making a library.
const std = @import("std");

pub fn parseInput(allocator: std.mem.Allocator, input: []const u8) !std.array_list.Aligned(i32, null) {
    var output = try std.ArrayList(i32).initCapacity(allocator, input.len);
    errdefer output.deinit(allocator);

    var it = std.mem.splitScalar(u8, input, '\n');
    while (it.next()) |t| {
        _ = t;
    }

    return output;
}
