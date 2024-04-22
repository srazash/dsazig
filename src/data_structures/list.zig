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

        // basic list functions (CRUD)
        pub fn append(self: *Self, data: T) !void {
            const n = try Node.init(self.allocator, data);
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

        pub fn prepend(self: *Self, data: T) !void {
            const n = try Node.init(self.allocator, data);
            self.*.len += 1;
            if (self.head == null) {
                n.next = null;
                n.prev = null;
                self.*.head = n;
                self.*.tail = n;
            } else {
                n.next = self.head;
                n.prev = null;
                n.next.?.prev = n;
                self.*.head = n;
            }
        }

        pub fn insert(self: *Self, i: usize, data: T) !void {
            if (self.len == 0) return error.EmptyList;
            if (i >= self.len) return error.OutOfBounds;

            const n = try Node.init(self.allocator, data);
            self.*.len += 1;
            const ptr = try self.addrOf(i);

            if (i == self.length() - 1) {
                n.prev = ptr;
                n.next = null;
                ptr.?.next = n;
                self.tail = n;
            } else {
                n.prev = ptr;
                n.next = ptr.?.next;
                n.prev.?.next = n;
                n.next.?.prev = n;
            }
        }

        pub fn update(self: *Self, i: usize, data: T) !void {
            if (self.len == 0) return error.EmptyList;
            if (i >= self.len) return error.OutOfBounds;

            var ptr = self.head;
            var index: usize = 0;
            while (index < i) : (index += 1) {
                ptr = ptr.?.next;
            }

            ptr.?.data = data;
        }

        pub fn delete(self: *Self, i: usize) !void {
            if (self.head == null and self.tail == null) return error.EmptyList;

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

        // utility functions
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

        pub fn printList(self: *Self) !void {
            const stdout = std.io.getStdOut().writer();

            if (self.head == null) return error.EmptyList;

            var ptr = self.head;
            var len: usize = 0;
            try stdout.print("HEAD->", .{});
            while (ptr != null) : (len += 1) {
                try stdout.print("[{}]{any}->", .{ len, ptr.?.data });
                ptr = ptr.?.next;
            }
            try stdout.print("TAIL\n", .{});
        }

        pub fn printDetail(self: *Self) !void {
            const stdout = std.io.getStdOut().writer();

            if (self.head == null) return error.EmptyList;

            var ptr = self.head;
            var len: usize = 0;
            try stdout.print("START OF LIST...\n", .{});
            while (ptr != null) : (len += 1) {
                try stdout.print("[{}] ({x:<8}) ->\tdata: {any}\tprev: {x:<8}\tnext: {x:<8}\n", .{ len, @intFromPtr(ptr), ptr.?.data, @intFromPtr(ptr.?.prev), @intFromPtr(ptr.?.next) });
                ptr = ptr.?.next;
            }
            try stdout.print("...END OF LIST\n", .{});
        }

        // stack functions
        pub fn push(self: *Self, data: T) !void {
            try append(self, data);
        }

        pub fn pop(self: *Self) !T {
            const i = self.len - 1;
            const data = self.at(i);
            try delete(self, i);
            return data;
        }

        pub fn stackPeek(self: *Self) ?T {
            return self.*.tail.?.data;
        }

        // queue functions
        pub fn enqueue(self: *Self, data: T) !void {
            try append(self, data);
        }

        pub fn dequeue(self: *Self) !T {
            const i = 0;
            const data = self.at(i);
            try delete(self, i);
            return data;
        }

        pub fn queuePeek(self: *Self) ?T {
            return self.*.head.?.data;
        }
    };
}
