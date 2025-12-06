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

fn solveBank(allocator: std.mem.Allocator, bank: []const u8) !u8 {
    var max: u8 = 0;
    var maxi: usize = 0;
    for (0..bank.len - 1) |i| {
        if (bank[i] > max) {
            max = bank[i];
            maxi = i;
        }
    }

    var second: u8 = 0;
    for (maxi + 1..bank.len) |i| {
        if (bank[i] > second) {
            second = bank[i];
        }
    }

    // std.debug.print("\t{c}{c}\n", .{ max, second });
    const maxstr = try std.fmt.allocPrint(allocator, "{c}{c}", .{ max, second });
    defer allocator.free(maxstr);
    return try std.fmt.parseInt(u8, maxstr, 10);
}

pub fn solve(allocator: std.mem.Allocator, input: []const u8) ![]const u8 {
    var parsed = try common.parseInput(allocator, input);
    defer parsed.deinit(allocator);

    // std.debug.print("{any}\n", .{parsed.items});

    var sum: u64 = 0;
    for (parsed.items) |bank| {
        // std.debug.print("{s}\n", .{bank});
        const banknum = try solveBank(allocator, bank);
        sum += banknum;
    }
    return std.fmt.allocPrint(allocator, "{d}", .{sum});
}

test "test1" {
    const allocator = std.testing.allocator;
    const input =
        \\987654321111111
        \\811111111111119
        \\234234234234278
        \\818181911112111
        \\
    ;

    const out = try solve(allocator, input);
    defer allocator.free(out);

    try std.testing.expectEqualStrings("357", out);
}
