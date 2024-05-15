const std = @import("std");

pub fn Heap(comptime T: type) type {
    return struct {
        const Self = @This();

        allocator: std.mem.Allocator,
        length: usize,
        data: std.ArrayList(T),

        pub fn init(allocator: std.mem.Allocator) Self {
            return .{
                .allocator = allocator,
                .length = 0,
                .data = std.ArrayList(T).init(allocator),
            };
        }

        pub fn deinit(self: *Self) void {
            self.data.deinit();
        }

        pub fn add(self: *Self, data: T) !void {
            try self.data.append(data);
            try heapifyUp(self, self.length);
            self.length += 1;
        }

        pub fn delete(self: *Self) !T {
            if (self.length == 0) return error.NothingToDelete;

            const v = self.data.items[0];

            if (self.length == 1) {
                self.length -= 1;
                _ = self.data.pop();
                return v;
            }

            self.length -= 1;
            _ = self.data.swapRemove(0);
            heapifyDown(self, 0);
            return v;
        }

        fn heapifyUp(self: *Self, index: usize) !void {
            if (index == 0) return;

            const p = try getParent(index);
            const pv = self.data.items[p];
            const v = self.data.items[index];

            if (pv > v) {
                self.data.items[index] = pv;
                self.data.items[p] = v;
                try heapifyUp(self, p);
            }

            return;
        }

        fn heapifyDown(self: *Self, index: usize) void {
            if (index >= self.length) return;

            const l = getLeftChild(index);
            const r = getRightChild(index);

            if (l >= self.length or r >= self.length) return;

            const v = self.data.items[index];
            const lv = self.data.items[l];
            const rv = self.data.items[r];

            if (lv > rv and v > rv) {
                self.data.items[index] = rv;
                self.data.items[r] = v;
                heapifyDown(self, r);
            } else if (rv > lv and v > lv) {
                self.data.items[index] = lv;
                self.data.items[l] = v;
                heapifyDown(self, l);
            }
        }

        fn getParent(index: usize) !usize {
            if (try std.math.mod(usize, index, 2) == 0)
                return (index - 2) / 2;

            return (index - 1) / 2;
        }

        fn getLeftChild(index: usize) usize {
            return (2 * index) + 1;
        }

        fn getRightChild(index: usize) usize {
            return (2 * index) + 2;
        }
    };
}
