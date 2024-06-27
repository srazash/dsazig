const std = @import("std");

pub fn GraphAL(comptime T: type) type {
    return struct {
        const Edge = struct {
            to: usize,
            weight: ?usize,
        };

        const Self = @This();

        allocator: std.mem.Allocator,
        size: usize,
        data: std.ArrayList(T),
        list: std.ArrayList(std.ArrayList(Edge)),

        pub fn init(allocator: std.mem.Allocator, size: usize) !Self {
            var data = try std.ArrayList(T).initCapacity(allocator, size);

            for (0..size) |_|
                try data.append(0);

            var list = try std.ArrayList(std.ArrayList(Edge)).initCapacity(allocator, size);

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
            if (vertex >= self.size)
                return error.InvalidVertex;

            self.data.items[vertex] = data;
        }

        pub fn defineEdge(self: *Self, from: usize, to: usize, weight: ?usize) !void {
            if (from >= self.size or to >= self.size or from == to)
                return error.InvalidFromOrTo;

            try self.list.items[from].append(.{ .to = to, .weight = weight });
        }

        pub fn printAdjacencyList(self: *Self) !void {
            const stdout = std.io.getStdOut().writer();

            try stdout.print("adjacency list:\n", .{});

            for (self.list.items, 0..) |from, i|
                for (from.items) |to|
                    try stdout.print("{} -> {}, weight:{?}\n", .{ i, to.to, to.weight });
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

        pub fn init(allocator: std.mem.Allocator, size: usize) !Self {
            var data = try std.ArrayList(T).initCapacity(allocator, size);

            for (0..size) |_|
                try data.append(0);

            var matrix = try std.ArrayList(std.ArrayList(usize)).initCapacity(allocator, size);

            for (0..size) |_| {
                var row = try std.ArrayList(usize).initCapacity(allocator, size);

                for (0..size) |_|
                    try row.append(0);

                try matrix.append(row);
            }

            return .{
                .allocator = allocator,
                .size = size,
                .data = data,
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

        pub fn setData(self: *Self, vertex: usize, data: T) !void {
            if (vertex >= self.size)
                return error.InvalidVertex;

            self.data.items[vertex] = data;
        }

        pub fn defineEdge(self: *Self, from: usize, to: usize, weight: usize) !void {
            if (from >= self.size or to >= self.size or from == to)
                return error.InvalidFromOrTo;

            self.matrix.items[from].items[to] = weight;
        }

        pub fn printAdjacencyMatrix(self: *Self) !void {
            const stdout = std.io.getStdOut().writer();

            try stdout.print("adjacency matrix:\n", .{});

            for (self.matrix.items, 0..) |row, i|
                try stdout.print("{:2} {any}\n", .{ i, row.items });
        }

        pub fn bfs(self: *Self, source: usize, target: usize) ![]usize {
            if (source >= self.size or target >= self.size)
                return error.InvalidSourceOrTarget;

            if (source == target)
                return error.SourceIsTarget;

            var visited = try std.ArrayList(bool).initCapacity(self.allocator, self.size);
            defer visited.deinit();
            for (0..self.size) |_|
                try visited.append(false);

            var path = std.ArrayList(usize).init(self.allocator);
            defer path.deinit();

            var queue = std.ArrayList(usize).init(self.allocator);
            defer queue.deinit();

            try queue.append(source);
            visited.items[source] = true;

            var current: usize = 0;

            while (queue.items.len > 0) {
                current = queue.orderedRemove(0);

                if (current == target)
                    break;

                for (self.matrix.items[current].items, 0..) |_, i| {
                    if (i == current)
                        continue;
                    if (!visited.items[i]) {
                        visited.items[i] = true;
                        current = i;
                        try queue.append(i);
                    }
                }
            }

            while (queue.items.len > 0) {
                try path.append(queue.pop());
            }

            return path.toOwnedSlice();
        }
    };
}
