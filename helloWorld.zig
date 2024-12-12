const std = @import("std");

pub fn main() !void {
    for (0..10) |value| {
        printLn("{d}: Hello world!",.{value});
    }
}

pub fn printLn(comptime format: []const u8, args: anytype) void {
    const stdout = std.io.getStdOut().writer();
    stdout.print(format ++ "\n", args) catch {};
}