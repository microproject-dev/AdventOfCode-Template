//! By convention, root.zig is the root source file when making a library.
const std = @import("std");

pub fn parseInput(allocator: std.mem.Allocator, input: []const u8) !std.array_list.Aligned(i32, null) {
    var output = try std.ArrayList(i32).initCapacity(allocator, input.len);
    errdefer output.deinit(allocator);

    var it = std.mem.splitScalar(u8, input, '\n');
    while (it.next()) |t| {
        if (t.len == 0) {
            continue;
        }
        switch (t[0]) {
            'L' => {
                // std.debug.print("L: {s}\n", .{t[1..]});
                try output.append(allocator, -1 * try std.fmt.parseInt(i32, t[1..], 10));
            },
            'R' => {
                // std.debug.print("R: {s}\n", .{t[1..]});
                try output.append(allocator, try std.fmt.parseInt(i32, t[1..], 10));
            },
            else => {
                std.debug.panic("Help", .{});
            },
        }
    }

    return output;
}
