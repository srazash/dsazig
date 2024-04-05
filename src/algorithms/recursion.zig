const std = @import("std");

pub fn simpleRecursion(n: usize) usize {
    // base case
    if (n == 1) {
        std.debug.print("base case! {}\n", .{n});
        return n;
    }

    // recurse case
    std.debug.print("recurse case! {}\n", .{n});
    return simpleRecursion(n - 1);
}
