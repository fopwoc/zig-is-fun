const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    print("Hello world!!!\n", .{});

    var a: bool = true;
    print("val is {}\n", .{a});
    a = false;
    print("val is {}\n", .{a});

    var d: [3]i32 = undefined;
    d[0] = 10;
    d[1] = 11;
    d[2] = 12;
    std.debug.print("array is {any}\n", .{d});

    var v = false;
    const ptr: *bool = &v;
    print("pointer: {}\n", .{ptr});
    ptr.* = true;
    print("value: {}\n", .{ptr.*});

    var array = [5]i32{ 1, 2, 3, 4, 5 };
    const end: usize = 4;
    const slice = array[1..end];
    print("len: {}\n", .{slice.len});
    print("first: {}\n", .{slice[0]});
    for (slice) |elem| {
        print("elem: {}\n", .{elem});
    }

    var c: usize = 0;
    while (true) : (c += 1) {
        if (c < 2) {
            print("d: {}\n", .{c});
            continue;
        }
        break;
    }

    var array2 = [_]u32{ 1, 2, 3 };
    std.debug.print("array2 is {any}\n", .{array2});
    for (&array2) |*elem| {
        elem.* += 100;
        print("by ref: {}\n", .{elem.*});
    }
    std.debug.print("array2 modified {any}\n", .{array2});

    var x: i8 = 10;
    switch (x) {
        -1...1 => {
            x = -x;
        },
        10, 100 => print("x: {d}\n", .{x}),
        else => {},
    }

    var arena = std.heap.ArenaAllocator.init(std.heap.c_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const pointer = try allocator.create(i32);
    std.debug.print("ptr={*}\n", .{pointer});
}
