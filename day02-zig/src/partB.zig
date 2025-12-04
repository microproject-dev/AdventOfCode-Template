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

const PatternGen = struct {
    start: u64,
    cur: u64,
    len: u64,
    knownPatterns: std.AutoHashMap(u64, bool),

    fn init(allocator: std.mem.Allocator, start: u64, len: u64) PatternGen {
        return PatternGen{
            .start = start,
            .cur = 0,
            .len = len,
            .knownPatterns = std.AutoHashMap(u64, bool).init(allocator),
        };
    }

    fn deinit(self: *PatternGen) void {
        self.knownPatterns.deinit();
    }

    fn genNumber(self: PatternGen) u64 {
        const patlen = common.findNumLen(self.cur);
        var numpats = self.len / patlen;
        var out = self.cur;
        // std.debug.print("\t\t\t{d} {d}({d}) {d}\n", .{ patlen, numpats, self.len, out });
        while (numpats > 1) {
            out *= std.math.pow(u64, 10, (patlen));
            out += self.cur;
            numpats -= 1;
            // std.debug.print("\t\t\t\t{d} {d} {d}\n", .{ patlen, numpats, out });
        }
        return out;
    }

    fn next(self: *PatternGen) ?u64 {
        self.cur += 1;
        var patlen = common.findNumLen(self.cur);
        const numpats = self.len / patlen;
        // std.debug.print("\t\t{d} {d}({d})\n", .{ patlen, numpats, self.len });
        if (numpats <= 1) {
            return null;
        }
        while (@mod(self.len, patlen) == 1) {
            self.cur += 1;
            patlen = common.findNumLen(self.cur);
        }
        if (self.knownPatterns.contains(self.genNumber())) {
            return 0;
        }
        self.knownPatterns.put(self.genNumber(), true) catch |err| {
            std.debug.panic("help! {any}", .{err});
        };
        return self.genNumber();
    }
};

fn solveRange(allocator: std.mem.Allocator, range: common.Range) u64 {
    var genStartLen: u64 = 0;
    var genStart: u64 = 0;
    var genEndLen: u64 = 0;
    var genEnd: u64 = 0;
    var sum: u64 = 0;

    // std.debug.print("Solving {d} - {d}\n", .{ range.start, range.end });

    genStart = range.start;
    genEnd = range.end;

    // std.debug.print("\tStarting: {d}\n", .{genStart});

    genStartLen = common.findNumLen(genStart);
    genEndLen = common.findNumLen(genEnd);
    if (genStartLen > genEndLen) {
        // std.debug.print("\tNo range left after endpoints corrected", .{});
        return 0;
    }

    // std.debug.print("\t{d}({d}) - {d}({d})\n", .{ genStart, genStartLen, genEnd, genEndLen });

    while (genStartLen <= genEndLen) {
        var ptngen = PatternGen.init(allocator, genStart, genStartLen);
        defer ptngen.deinit();

        while (ptngen.next()) |p| {
            // std.debug.print("\tF: {d}\n", .{p});
            if (p == 0) {
                continue;
            }
            if (p >= genStart and p <= genEnd) {
                // std.debug.print("\t\tG: {d}\n", .{p});
                sum += p;
            }
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

    try std.testing.expectEqualStrings("4174379265", out);
}

// test "simplier test" {
//     const allocator = std.testing.allocator;
//     const input = "11-22,95-115,998-1012";

//     const out = try solve(allocator, input);
//     defer allocator.free(out);

//     try std.testing.expectEqualStrings("4174379265", out);
// }
