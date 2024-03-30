const std = @import("std");

pub fn LinkedList(comptime T: type) type {
    return struct {
        const Node = struct {
            allocator: std.mem.Allocator,
            data: T,
            next: ?*Node,
            prev: ?*Node,

            fn init(allocator: std.mem.Allocator, data: T) !*Node {
                const new_node = try allocator.create(Node);
                new_node.allocator = allocator;
                new_node.data = data;
                new_node.next = null;
                new_node.prev = null;
                return new_node;
            }

            fn deinit(self: *Node) void {
                if (self.next) |node| node.deinit();
                self.allocator.destroy(self);
            }
        };

        const Self = @This();

        allocator: std.mem.Allocator,
        head: ?*Node,
        tail: ?*Node,
        len: usize,

        pub fn init(allocator: std.mem.Allocator, data: T) !Self {
            const new_node = try Node.init(allocator, data);
            return .{
                .allocator = allocator,
                .head = new_node,
                .tail = new_node,
                .len = 1,
            };
        }

        pub fn deinit(self: *Self) void {
            self.head.?.deinit();
        }
    };
}
