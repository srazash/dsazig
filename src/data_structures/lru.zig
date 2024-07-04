const std = @import("std");

pub fn LRU(comptime K: type, comptime V: type) type {
    return struct {
        const Self = @This();

        const Node = struct {
            prev: ?*Node,
            next: ?*Node,
            value: V,

            fn init() !void {}

            fn deinit() !void {}
        };

        allocator: std.mem.Allocator,
        head: ?*Node,
        tail: ?*Node,
        length: usize,
        capcity: usize,

        pub fn init() !void {}

        pub fn deinit() !void {}

        pub fn update(self: *Self, key: K, value: V) !void {}

        pub fn get(self: *Self, key: K) !?V {}
    };
}
