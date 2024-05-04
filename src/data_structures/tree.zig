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

        pub fn insert(self: *Self, value: T) !void {
            if (self.root == null) {
                self.root = try Node.init(self.allocator, value);
                return;
            }

            try self.insertNode(self.root, value);
        }

        fn insertNode(self: *Self, node: ?*Node, value: T) !void {
            if (node.?.data < value) {
                if (node.?.right == null) {
                    node.?.right = try Node.init(self.allocator, value);
                    return;
                }
                try self.insertNode(node.?.right, value);
            }
            if (node.?.data >= value) {
                if (node.?.left == null) {
                    node.?.left = try Node.init(self.allocator, value);
                    return;
                }
                try self.insertNode(node.?.left, value);
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

        pub fn breadthFirstSearch(self: *Self, needle: T) !bool {
            if (self.root == null) return error.EmptyTree;

            var queue = std.ArrayList(?*Node).init(self.allocator);
            defer queue.deinit();

            try queue.append(self.root);

            while (queue.items.len > 0) {
                const current = queue.orderedRemove(0);

                if (current.?.data == needle) return true;

                if (current.?.left != null) try queue.append(current.?.left);
                if (current.?.right != null) try queue.append(current.?.right);
            }

            return false;
        }

        pub fn compare(self: *Self, tree: BinaryTree(T)) !bool {
            if (@TypeOf(self.root.?.data) != @TypeOf(tree.root.?.data)) return error.TypeMismatch;
            return depthFirstCompare(self.root, tree.root);
        }

        fn depthFirstCompare(a: ?*Node, b: ?*Node) bool {
            // shape check
            if (a == null and b == null) return true;
            if (a == null or b == null) return false;

            // value check
            if (a.?.data != b.?.data) return false;

            return depthFirstCompare(a.?.left, b.?.left) and depthFirstCompare(a.?.right, b.?.right);
        }

        pub fn find(self: *Self, value: T) bool {
            return depthFirstFind(self.root, value);
        }

        fn depthFirstFind(node: ?*Node, value: T) bool {
            if (node == null) return false;
            if (node.?.data == value) return true;
            if (node.?.data < value) return depthFirstFind(node.?.right, value);
            return depthFirstFind(node.?.left, value);
        }

        pub fn search(self: *Self, needle: T) bool {
            return binarySearch(self.root, needle);
        }

        fn binarySearch(current: ?*Node, needle: T) bool {
            if (current == null) return false;
            if (current.?.data == needle) return true;
            if (current.?.data < needle) return binarySearch(current.?.right, needle);
            return binarySearch(current.?.left, needle);
        }
    };
}
