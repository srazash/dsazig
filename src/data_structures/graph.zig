const std = @import("std");

pub fn GraphAL(comptime T: type) type {
    return struct {
        const Edge = struct {
            to: usize,
            weight: ?usize,
        };

        const Self = @This();

        allocator: std.mem.Allocator,
        size: usize,
        data: std.ArrayList(T),
        list: std.ArrayList(std.ArrayList(Edge)),

        pub fn init() void {}

        pub fn deinit() void {}
    };
}

pub fn GraphAM(comptime T: type) type {
    return struct {
        const Self = @This();
    };
}
