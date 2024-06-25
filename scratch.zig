const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const arr = try arrTest(allocator, 10);
    defer allocator.free(arr);

    try stdout.print("arr len -> {}, arr ptr -> {*}\n", .{ arr.len, arr.ptr });
    try stdout.print("arr -> {any}\n", .{arr});
}

fn arrTest(allocator: std.mem.Allocator, count: usize) ![]usize {
    if (count == 0)
        return error.InvalidCount;

    var arr = std.ArrayList(usize).init(allocator);
    defer arr.deinit();
    for (0..count) |i|
        try arr.append(i + 1);

    return arr.toOwnedSlice();
}
