const std = @import("std");

pub fn GraphAL(comptime T: type) type {
    return struct {
        const Edge = struct {
            to: usize,
            weight: ?usize,
        };

        const Self = @This();

        const GraphList = std.ArrayList(std.ArrayList(Edge));

        allocator: std.mem.Allocator,
        size: usize,
        data: std.ArrayList(T),
        list: std.ArrayList(std.ArrayList(Edge)),

        pub fn init(allocator: std.mem.Allocator, size: usize) !Self {
            var data = try std.ArrayList(T).initCapacity(allocator, size);

            for (0..size) |_|
                try data.append(0);

            var list = try GraphList.initCapacity(allocator, size);

            for (0..size) |_| {
                const item = std.ArrayList(Edge).init(allocator);
                try list.append(item);
            }

            return .{
                .allocator = allocator,
                .size = size,
                .data = data,
                .list = list,
            };
        }

        pub fn deinit(self: *Self) void {
            for (self.list.items) |i| {
                i.deinit();
            }
            self.list.deinit();
            self.data.deinit();
        }

        pub fn setData(self: *Self, vertex: usize, data: T) !void {
            self.data.items[vertex] = data;
        }

        pub fn defineEdge(self: *Self, from: usize, to: usize, weight: ?usize) !void {
            try self.list.items[from].append(.{ .to = to, .weight = weight });
        }
    };
}

pub fn GraphAM(comptime T: type) type {
    return struct {
        const Self = @This();

        allocator: std.mem.Allocator,
        size: usize,
        data: std.ArrayList(T),
        matrix: std.ArrayList(std.ArrayList(usize)),

        pub fn init(allocator: std.mem.Allocator, size: usize) !void {
            var matrix = try std.ArrayList(std.ArrayList(usize)).initCapacity(allocator, size);

            for (0..size) |_| {
                matrix.append(try std.ArrayList(usize).initCapacity(allocator, size));
            }

            return .{
                .allocator = allocator,
                .size = size,
                .data = std.ArrayList(T).initCapacity(allocator, size),
                .matrix = matrix,
            };
        }

        pub fn deinit(self: *Self) void {
            for (self.matrix.items) |item| {
                item.deinit();
            }
            self.matrix.deinit();
            self.data.deinit();
        }
    };
}
