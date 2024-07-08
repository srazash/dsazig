const std = @import("std");

pub fn LRU(comptime K: type, comptime V: type) type {
    return struct {
        const Self = @This();

        const Node = struct {
            next: ?*Node,
            prev: ?*Node,
            value: V,

            fn init(allocator: std.mem.Allocator, value: V) !*Node {
                const node = try allocator.create(Node);
                node.next = null;
                node.prev = null;
                node.value = value;
                return node;
            }

            fn deinit(self: *Node, allocator: std.mem.Allocator) void {
                if (self.next) |node|
                    node.deinit(allocator);
                allocator.destroy(self);
            }
        };

        allocator: std.mem.Allocator,
        head: ?*Node,
        tail: ?*Node,
        length: usize,
        map: std.AutoHashMap(K, *Node),

        pub fn init(allocator: std.mem.Allocator) !Self {
            return .{
                .allocator = allocator,
                .head = null,
                .tail = null,
                .length = 0,
                .map = std.AutoHashMap(K, *Node).init(allocator),
            };
        }

        pub fn deinit(self: *Self) void {
            if (self.head) |head|
                head.deinit(self.allocator);
            self.map.deinit();
        }

        //pub fn update(self: *Self, key: K, value: V) !void {}

        //pub fn get(self: *Self, key: K) !?V {}
    };
}
