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

const PatternGen = struct {
    start: u64,
    cur: u64,
    len: u64,

    fn init(start: u64, len: u64) PatternGen {
        return PatternGen{
            .start = start,
            .cur = 0,
            .len = len,
        };
    }

    fn genNumber(self: PatternGen) u64 {
        return self.cur * std.math.pow(u64, 10, (self.len / 2)) + self.cur;
    }

    fn next(self: *PatternGen) ?u64 {
        if (self.cur == 0) {
            var gen = (self.len / 2) - 1;
            self.cur = 1;
            while (gen > 0) {
                self.cur *= 10;
                gen -= 1;
            }
            // std.debug.print("\t\tInitial pattern {d}\n", .{self.cur});
            while (self.genNumber() < self.start) {
                self.cur += 1;
            }
            // std.debug.print("\t\tInranged pattern {d}\n", .{self.cur});
        } else {
            self.cur += 1;
            // std.debug.print("\t\tPattern {d}\n", .{self.cur});
        }
        // if (@mod(self.genNumber(), 10) == 0) {
        //     std.debug.print("\t\tPattern {d}\n", self.cur);
        //     self.cur += 1;
        // }
        // std.debug.print("\t\t{d} {d} {d}\n", .{ self.cur, self.len, std.math.pow(u64, 10, self.len / 2) });
        return self.genNumber();
    }
};

fn solveRange(allocator: std.mem.Allocator, range: common.Range) u64 {
    _ = allocator;

    const numlenS = common.findNumLen(range.start);
    const numlenE = common.findNumLen(range.end);
    var genStartLen: u64 = 0;
    var genStart: u64 = 0;
    var genEndLen: u64 = 0;
    var genEnd: u64 = 0;
    var sum: u64 = 0;

    // std.debug.print("Solving {d} - {d}\n", .{ range.start, range.end });

    if (@mod(numlenS, 2) == 1 and @mod(numlenE, 2) == 1) {
        // std.debug.print("\tRange is all odd\n", .{});
        return 0;
    } else if (@mod(numlenS, 2) == 1) {
        genStart = std.math.pow(u64, 10, numlenS);
        genEnd = range.end;
    } else if (@mod(numlenE, 2) == 1) {
        genStart = range.start;
        genEnd = std.math.pow(u64, 10, numlenE - 1) - 1;
    } else {
        genStart = range.start;
        genEnd = range.end;
    }

    // std.debug.print("\tStarting: {d}\n", .{genStart});

    genStartLen = common.findNumLen(genStart);
    genEndLen = common.findNumLen(genEnd);
    if (genStartLen > genEndLen) {
        // std.debug.print("\tNo range left after endpoints corrected", .{});
        return 0;
    }

    // std.debug.print("\t{d}({d}) - {d}({d})\n", .{ genStart, genStartLen, genEnd, genEndLen });

    while (genStartLen <= genEndLen) {
        var ptngen = PatternGen.init(genStart, genStartLen);
        while (ptngen.next()) |p| {
            // std.debug.print("\tF: {d}\n", .{p});
            if (p > genEnd) {
                break;
            }
            // std.debug.print("\t\tG: {d}\n", .{p});
            sum += p;
        }
        genStartLen += 1;
    }
    return sum;
}

pub fn solve(allocator: std.mem.Allocator, input: []const u8) ![]const u8 {
    var parsed = try common.parseInput(allocator, input);
    defer parsed.deinit(allocator);
    // std.debug.print("{any}\n", .{parsed});

    var sum: u64 = 0;

    for (parsed.items) |r| {
        sum += solveRange(allocator, r);
    }
    return std.fmt.allocPrint(allocator, "{d}", .{sum});
}

test "simple test" {
    const allocator = std.testing.allocator;
    const input = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124";

    const out = try solve(allocator, input);
    defer allocator.free(out);

    try std.testing.expectEqualStrings("1227775554", out);
}
