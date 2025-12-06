//! By convention, root.zig is the root source file when making a library.
const std = @import("std");

pub const Range = struct {
    start: u64,
    end: u64,

    fn init(start: []const u8, end: []const u8) !Range {
        return Range{
            .start = try std.fmt.parseInt(u64, start[0..], 10),
            .end = try std.fmt.parseInt(u64, end[0..], 10),
        };
    }
};

pub fn findNumLen(num: u64) u64 {
    // floor(log10(num)) + 1
    if (num == 0) {
        return 1;
    }
    return @intFromFloat(@floor(std.math.log(f64, 10, @floatFromInt(num)) + 1));
}

pub fn parseInput(allocator: std.mem.Allocator, input: []const u8) !std.array_list.Aligned(Range, null) {
    var output = try std.ArrayList(Range).initCapacity(allocator, 10);
    errdefer output.deinit(allocator);

    var it = std.mem.splitScalar(u8, input, ',');
    while (it.next()) |t| {
        var rit = std.mem.splitScalar(u8, t, '-');
        const start = rit.next().?;
        const end = rit.next().?;
        // std.debug.print("{s} - {s}\n", .{ start, end });
        try output.append(allocator, try Range.init(start, end));
    }

    return output;
}
