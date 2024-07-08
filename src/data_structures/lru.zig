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
            if (capacity <= 0)
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
            var node = self.lookup.get(key);
            if (node == null) {
                node = try Node.init(self.allocator, value);

                self.length += 1;
                self.prepend(node.?);
                self.prune();

                try self.lookup.put(key, node.?);
                try self.reverseLookup.put(node.?, key);
            } else {
                self.detach(node.?);
                self.prepend(node.?);
                node.?.value = value;
            }
        }

        pub fn get(self: *Self, key: K) !?V {
            const node = self.lookup.get(key);
            if (node == null)
                return null;

            self.detach(node.?);
            self.prepend(node.?);

            return node.?.value;
        }

        fn detach(self: *Self, node: *Node) void {
            if (node.prev != null)
                node.prev.?.next = node.next;

            if (node.next != null)
                node.next.?.prev = node.prev;

            if (self.head == node)
                self.head = self.head.?.next;

            if (self.tail == node)
                self.tail = self.tail.?.prev;

            node.next = null;
            node.prev = null;
        }

        fn prepend(self: *Self, node: *Node) void {
            if (self.head == null) {
                self.head = node;
                self.tail = node;
                return;
            }

            node.next = self.head.?;
            self.head.?.prev = node;
            self.head = node;
        }

        fn prune(self: *Self) void {
            if (self.length <= self.capacity)
                return;

            const tail = self.tail;
            self.detach(tail.?);
            defer tail.?.deinit(self.allocator);

            const key = self.reverseLookup.get(tail.?);
            _ = self.lookup.remove(key.?);
            _ = self.reverseLookup.remove(tail.?);

            self.length -= 1;
        }
    };
}
