//! By convention, root.zig is the root source file when making a library.
const std = @import("std");

pub fn parseInput(allocator: std.mem.Allocator, input: []const u8) !std.array_list.Aligned([]const u8, null) {
    var output = try std.ArrayList([]const u8).initCapacity(allocator, 10);
    errdefer output.deinit(allocator);

    var it = std.mem.splitScalar(u8, input, '\n');
    while (it.next()) |t| {
        if (t.len == 0) {
            break;
        }
        try output.append(allocator, t);
    }

    return output;
}
