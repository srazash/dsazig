const std = @import("std");

pub fn LinkedList(comptime T: type) type {
    return struct {
        const Self = @This();

        allocator: std.mem.Allocator,
        head: ?*Node,
        tail: ?*Node,
        len: usize = 0,

        const Node = struct {
            allocator: std.mem.Allocator,
            data: T,
            next: ?*Node,
            prev: ?*Node,

            fn init(allocator: std.mem.Allocator, data: T) !*Node {
                const new_node = try allocator.create(Node);
                new_node.data = data;
                return &new_node;
            }

            fn deinit(self: *Node) void {
                self.next.prev = &prev;
                self.prev.next = &next;
                allocator.destroy(self);
            }
        };

        pub fn init(allocator: std.mem.Allocator, data: T) !Self {
            const new_list = allocator.create(LinkedList);
            new_list.allocator = allocator;
            new_list.type = T;
            const new_node = Node.init(data);
            new_list.head = &new_node;
            new_list.tail = &new_node;
            new_list.len += 1;
            return new_list;
        }
    };
}
