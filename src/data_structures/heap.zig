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
            self.length += 1;
        }

        fn getParent(current: usize) !usize {
            if (current == 0) return 0;

            if (try std.math.mod(usize, current, 2) == 0)
                return (current - 2) / 2;

            return (current - 1) / 2;
        }

        fn getLeftChild(self: *Self, current: usize) !usize {
            if (self.length < 2) return 0;

            const index = (2 * current) + 1;

            if (index < self.length) return index;
            return error.OutOfBounds;
        }

        fn getRightChild(self: *Self, current: usize) !usize {
            if (self.length < 2) return 0;

            const index = (2 * current) + 2;

            if (index < self.length) return index;
            return error.OutOfBounds;
        }
    };
}
