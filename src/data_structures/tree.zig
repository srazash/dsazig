const std = @import("std");

pub fn BinaryTree(comptime T: type) type {
    return struct {
        const Node = struct {
            data: T,
            left: ?*Node,
            right: ?*Node,

            fn init(allocator: std.mem.Allocator, data: T) !*Node {
                const n = try allocator.create(Node);
                n.data = data;
                n.left = null;
                n.right = null;
                return n;
            }

            fn deinit(self: *Node, allocator: std.mem.Allocator) void {
                if (self.left) |node| node.deinit(allocator);
                if (self.right) |node| node.deinit(allocator);
                allocator.destroy(self);
            }
        };

        const Self = @This();

        allocator: std.mem.Allocator,
        root: ?*Node,

        pub fn init(allocator: std.mem.Allocator) !Self {
            return .{
                .allocator = allocator,
                .root = null,
            };
        }

        pub fn deinit(self: *Self) void {
            if (self.root != null) self.root.?.deinit(self.allocator);
        }
    };
}
