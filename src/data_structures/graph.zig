const std = @import("std");

pub fn GraphAL(comptime T: type) type {
    return struct {
        const Edge = struct {
            to: usize,
            weight: usize,
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

        pub fn defineEdge(self: *Self, from: usize, to: usize, weight: usize) !void {
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

        pub fn dfs(self: *Self, source: usize, target: usize) !?[]usize {
            var seen = try std.ArrayList(bool).initCapacity(self.allocator, self.size);
            defer seen.deinit();
            for (0..self.size) |_|
                try seen.append(false);

            var path = std.ArrayList(usize).init(self.allocator);
            defer path.deinit();

            _ = try dfsWalker(self, source, target, &seen, &path);

            if (path.items.len == 0)
                return null;

            return try path.toOwnedSlice();
        }

        fn dfsWalker(self: *Self, current: usize, target: usize, seen: *std.ArrayList(bool), path: *std.ArrayList(usize)) !bool {
            if (seen.items[current])
                return false;
            seen.items[current] = true;

            try path.append(current);

            if (current == target)
                return true;

            for (self.list.items[current].items) |edge| {
                if (try dfsWalker(self, edge.to, target, seen, path))
                    return true;
            }
            _ = path.pop();

            return false;
        }

        pub fn dijkstra(self: *Self, source: usize, target: usize) !?[]usize {
            var seen = try std.ArrayList(bool).initCapacity(self.allocator, self.size);
            defer seen.deinit();
            for (0..self.size) |_|
                seen.appendAssumeCapacity(false);

            var dists = try std.ArrayList(usize).initCapacity(self.allocator, self.size);
            defer dists.deinit();
            for (0..self.size) |_|
                dists.appendAssumeCapacity(std.math.maxInt(usize));

            var prev = try std.ArrayList(isize).initCapacity(self.allocator, self.size);
            defer prev.deinit();
            for (0..self.size) |_|
                prev.appendAssumeCapacity(-1);

            dists.items[source] = 0;

            while (hasUnvisited(&seen, &dists)) {
                const current = getLowestUnvisited(&seen, &dists);

                seen.items[current] = true;

                for (self.list.items[current].items) |edge| {
                    if (seen.items[edge.to])
                        continue;

                    const dist = dists.items[current] + edge.weight;
                    if (dist < dists.items[edge.to]) {
                        dists.items[edge.to] = dist;
                        prev.items[edge.to] = @intCast(current);
                    }
                }
            }

            var dsp = std.ArrayList(usize).init(self.allocator);
            defer dsp.deinit();

            var out = std.ArrayList(usize).init(self.allocator);
            defer out.deinit();

            var current = target;

            while (prev.items[current] != -1) {
                try dsp.append(current);
                current = @intCast(prev.items[current]);
            }

            if (dsp.items.len == 0)
                return null;

            try out.append(source);
            for (dsp.items) |_|
                try out.append(dsp.pop());

            return try out.toOwnedSlice();
        }

        fn hasUnvisited(seen: *std.ArrayList(bool), dists: *std.ArrayList(usize)) bool {
            for (seen.items, 0..) |s, i|
                if (s == false and dists.items[i] < std.math.maxInt(usize))
                    return true;
            return false;
        }

        fn getLowestUnvisited(seen: *std.ArrayList(bool), dists: *std.ArrayList(usize)) usize {
            var idx: usize = 0;
            var lowestDist: usize = std.math.maxInt(usize);

            for (seen.items, 0..) |s, i| {
                if (s)
                    continue;

                if (lowestDist > dists.items[i]) {
                    lowestDist = dists.items[i];
                    idx = i;
                }
            }

            return idx;
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

        pub fn bfs(self: *Self, source: usize, target: usize) !?[]usize {
            if (source >= self.size or target >= self.size)
                return error.InvalidSourceOrTarget;

            if (source == target)
                return error.SourceIsTarget;

            var seen = try std.ArrayList(bool).initCapacity(self.allocator, self.size);
            defer seen.deinit();
            for (0..self.size) |_|
                try seen.append(false);

            var prev = try std.ArrayList(isize).initCapacity(self.allocator, self.size);
            defer prev.deinit();
            for (0..self.size) |_|
                try prev.append(-1);

            var queue = std.ArrayList(usize).init(self.allocator);
            defer queue.deinit();

            try queue.append(source);
            seen.items[source] = true;

            var current: usize = 0;

            while (queue.items.len > 0) {
                current = queue.orderedRemove(0);

                if (current == target)
                    break;

                for (self.matrix.items[current].items, 0..) |item, i| {
                    if (item == 0 or seen.items[i])
                        continue;

                    seen.items[i] = true;
                    prev.items[i] = @intCast(current);
                    try queue.append(i);
                }
            }

            queue.clearRetainingCapacity();

            current = target;

            while (prev.items[current] != -1) {
                try queue.append(current);
                current = @intCast(prev.items[current]);
            }
            if (queue.items.len == 0)
                return null;
            try queue.append(source);

            var out = std.ArrayList(usize).init(self.allocator);
            defer out.deinit();

            while (queue.items.len > 0)
                try out.append(queue.pop());

            return try out.toOwnedSlice();
        }
    };
}
