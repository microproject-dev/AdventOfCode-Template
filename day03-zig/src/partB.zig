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

fn findMaxBounded(bank: []const u8, bound: usize) usize {
    var max: u8 = 0;
    var maxi: usize = 0;
    // std.debug.print("{s} 0..{d} {d} {d}\n", .{ bank, bank.len - bound, bank.len, bound });
    for (0..bank.len - bound) |i| {
        if (bank[i] > max) {
            max = bank[i];
            maxi = i;
        }
    }
    return maxi;
}

fn solveDblIter(allocator: std.mem.Allocator, bank: []const u8) !u64 {
    var numsofar = try std.ArrayList(u8).initCapacity(allocator, 12);
    defer numsofar.deinit(allocator);

    var banksl = bank[0..];
    while (numsofar.items.len < 12) {
        const maxi = findMaxBounded(banksl, 12 - numsofar.items.len - 1);
        try numsofar.append(allocator, banksl[maxi]);
        banksl = banksl[maxi + 1 ..];
    }

    return try std.fmt.parseInt(u64, numsofar.items, 10);
}

fn solveBank(allocator: std.mem.Allocator, bank: []const u8) !u64 {
    // var init = try std.ArrayList(u8).initCapacity(allocator, 12);
    const soln = try solveDblIter(allocator, bank);
    // std.debug.print("{d}\n", .{soln});
    return soln;
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

    try std.testing.expectEqualStrings("3121910778619", out);
}
