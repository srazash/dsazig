const std = @import("std");

pub fn LinkedList(comptime T: type) type {
    return struct {
        const Node = struct {
            data: T,
            next: ?*Node,
            prev: ?*Node,

            fn init(allocator: std.mem.Allocator, data: T) !*Node {
                const n = try allocator.create(Node);
                n.data = data;
                n.next = null;
                n.prev = null;
                return n;
            }

            fn deinit(self: *Node, allocator: std.mem.Allocator) void {
                if (self.next) |node| node.deinit(allocator);
                allocator.destroy(self);
            }
        };

        const Self = @This();

        allocator: std.mem.Allocator,
        head: ?*Node,
        tail: ?*Node,
        len: usize,

        pub fn init(allocator: std.mem.Allocator) !Self {
            return .{
                .allocator = allocator,
                .head = null,
                .tail = null,
                .len = 0,
            };
        }

        pub fn deinit(self: *Self) void {
            self.head.?.deinit(self.allocator);
        }

        // stack functions
        pub fn push(self: *Self, data: T) !void {
            const n = try Node.init(self.allocator, data);
            n.data = data;
            self.*.len += 1;
            if (self.head == null) {
                n.next = null;
                n.prev = null;
                self.*.head = n;
                self.*.tail = n;
            } else {
                n.next = null;
                n.prev = self.tail;
                n.prev.?.next = n;
                self.*.tail = n;
            }
        }
    };
}
