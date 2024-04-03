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
            if (self.head != null) self.head.?.deinit(self.allocator);
        }

        pub fn append(self: *Self, data: T) !void {
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

        pub fn delete(self: *Self, i: usize) !void {
            const ptr = try self.addrOf(i);

            if (ptr == self.head and ptr == self.tail) {
                self.head = null;
                self.tail = null;
            } else if (ptr == self.head) {
                self.head = ptr.?.next;
                ptr.?.next.?.prev = null;
            } else if (ptr == self.tail) {
                self.tail = ptr.?.prev;
                ptr.?.prev.?.next = null;
            } else {
                ptr.?.next.?.prev = ptr.?.prev;
                ptr.?.prev.?.next = ptr.?.next;
            }

            self.len -= 1;
            self.allocator.destroy(ptr.?);
        }

        pub fn at(self: *Self, i: usize) !T {
            if (self.len == 0) return error.EmptyList;
            if (i >= self.len) return error.OutOfBounds;

            var ptr = self.head;
            var index: usize = 0;
            while (index < i) : (index += 1) {
                ptr = ptr.?.next;
            }

            return ptr.?.data;
        }

        pub fn addrOf(self: *Self, i: usize) !?*Node {
            if (self.len == 0) return error.EmptyList;
            if (i >= self.len) return error.OutOfBounds;

            var ptr = self.head;
            var index: usize = 0;
            while (index < i) : (index += 1) {
                ptr = ptr.?.next;
            }

            return ptr.?;
        }

        pub fn length(self: *Self) usize {
            var ptr = self.head;
            var len: usize = 0;
            while (ptr != null) : (len += 1) {
                ptr = ptr.?.next;
            }
            return len;
        }

        pub fn validateLength(self: *Self) bool {
            if (self.len == self.length()) return true;
            return false;
        }

        // stack functions
        pub fn push(self: *Self, data: T) !void {
            try append(self, data);
        }

        // queue functions
        pub fn enqueue(self: *Self, data: T) !void {
            try append(self, data);
        }
    };
}
