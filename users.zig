const std = @import("std");

const User = struct {
    name: []const u8,
    age: u32,
};

pub fn printLn(comptime format: []const u8, args: anytype) void {
    const stdout = std.io.getStdOut().writer();
    stdout.print(format ++ "\n", args) catch {};
}

pub fn main() !void {
    printLn("Zig list of users!!\n", .{});

    const allocator = std.heap.page_allocator;
    var users = std.ArrayList(User).init(allocator);

    while (true) {
        printLn("Print name of user:", .{});
        const name = try getName(&allocator);

        printLn("Print age of user:", .{});
        const age = try getAge(&allocator);

        const user = User{ .name = name, .age = age };

        try users.append(user);

        printLn("New User! Name - {s}, age - {d}", .{ user.name, user.age });

        const users_items = users.items;

        if (users_items.len <= 1) {
            continue;
        }

        printLn("All old users:", .{});
        var index: usize = 1;
        for (users_items[0 .. users_items.len - 1]) |value| {
            printLn("User {d}: Name - {s}, age - {d}", .{ index, value.name, value.age });
            index += 1;
        }

        printLn("", .{});
    }
}

pub fn getAge(allocator: *const std.mem.Allocator) !u32 {
    const line = try readLine(allocator);

    if (line.len == 0) {
        std.c.exit(1);
    }

    const age = try std.fmt.parseInt(u32, line, 0);

    if (age < 0) {
        std.c.exit(1);
    }

    return age;
}

pub fn getName(allocator: *const std.mem.Allocator) ![]u8 {
    const line = try readLine(allocator);

    if (line.len == 0) {
        std.c.exit(1);
    }

    return line;
}

pub fn readLine(allocator: *const std.mem.Allocator) ![]u8 {
    const stdin = std.io.getStdIn().reader();
    const buffer = stdin.readUntilDelimiterAlloc(allocator.*, '\n', 1024);
    return buffer;
}
