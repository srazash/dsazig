const std = @import("std");

pub fn LRU(comptime K: type, comptime V: type) type {
    return struct {
        allocator: std.mem.Allocator,
        head: ?*Node,
        tail: ?*Node,
        length: usize,
        capacity: usize,
        lookup: std.AutoHashMap(K, *Node),
        reverseLookup: std.AutoHashMap(*Node, K),

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

        pub fn init(allocator: std.mem.Allocator, capacity: usize) !Self {
            if (capacity > 0)
                return error.InvalidCapacity;

            return .{
                .allocator = allocator,
                .head = null,
                .tail = null,
                .length = 0,
                .capacity = capacity,
                .lookup = std.AutoHashMap(K, *Node).init(allocator),
                .reverseLookup = std.AutoHashMap(*Node, K).init(allocator),
            };
        }

        pub fn deinit(self: *Self) void {
            if (self.head) |head|
                head.deinit(self.allocator);
            self.lookup.deinit();
            self.reverseLookup.deinit();
        }

        pub fn update(self: *Self, key: K, value: V) !void {
            if (self.lookup.contains(key)) {
                return;
            }
        }

        fn insert(self: *Self, key: K, value: V) !void {
            return;
        }

        pub fn get(self: *Self, key: K) !?V {
            return;
        }
    };
}
