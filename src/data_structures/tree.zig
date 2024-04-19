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

        pub fn preOrderSearch(self: *Self, path: *std.ArrayList(T)) !void {
            try preSearch(self.root, path);
        }

        fn preSearch(current: ?*Node, path: *std.ArrayList(T)) !void {
            if (current == null) return;

            try path.append(current.?.data);
            try preSearch(current.?.left, path);
            try preSearch(current.?.right, path);
        }

        pub fn inOrderSearch(self: *Self, path: *std.ArrayList(T)) !void {
            try inSearch(self.root, path);
        }

        fn inSearch(current: ?*Node, path: *std.ArrayList(T)) !void {
            if (current == null) return;

            try inSearch(current.?.left, path);
            try path.append(current.?.data); // in order
            try inSearch(current.?.right, path);
        }

        pub fn postOrderSearch(self: *Self, path: *std.ArrayList(T)) !void {
            try postSearch(self.root, path);
        }

        fn postSearch(current: ?*Node, path: *std.ArrayList(T)) !void {
            if (current == null) return;

            try postSearch(current.?.left, path);
            try postSearch(current.?.right, path);
            try path.append(current.?.data); // post
        }
    };
}
