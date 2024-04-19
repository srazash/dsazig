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

        pub fn insert(self: *Self, data: T) !void {
            if (self.root == null) {
                self.root = try Node.init(self.allocator, data);
                return;
            }

            try self.insertOnNode(self.root, data);
        }

        fn insertOnNode(self: *Self, current: ?*Node, data: T) !void {
            if (current.?.left == null) {
                current.?.left = try Node.init(self.allocator, data);
                return;
            } else if (current.?.right == null) {
                current.?.right = try Node.init(self.allocator, data);
                return;
            }

            if (data < current.?.data) {
                try self.insertOnNode(current.?.left, data);
            } else {
                try self.insertOnNode(current.?.right, data);
            }
        }

        pub fn new(self: *Self, data: T) !?*Node {
            return try Node.init(self.allocator, data);
        }
    };
}
