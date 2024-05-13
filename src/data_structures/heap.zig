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
    };
}
