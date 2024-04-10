const std = @import("std");

pub fn simpleRecursion(n: usize) usize {
    // base case
    if (n == 1) {
        //std.debug.print("base case! {}\n", .{n});
        return n;
    }

    // recurse case
    // pre
    //std.debug.print("pre: recurse case! {}\n", .{n});
    // recurse
    const rec = simpleRecursion(n - 1);
    // post
    //std.debug.print("post: recurse case! {}\n", .{n});
    return rec;
}

pub const Point = struct {
    x: isize,
    y: isize,
};

const dir: [4]Point = .{
    .{ .x = -1, .y = 0 },
    .{ .x = 0, .y = 1 },
    .{ .x = 1, .y = 0 },
    .{ .x = 0, .y = -1 },
};

pub fn mazeSolver(allocator: std.mem.Allocator, maze: *[5][5]u8, start: Point, end: Point, path: *std.ArrayList(Point)) !void {
    var seen = try allocator.create([5][5]bool);
    defer allocator.destroy(seen);

    for (seen, 0..) |_, x| {
        for (seen[x], 0..) |_, y| {
            seen[x][y] = false;
        }
    }

    _ = try mazeWalker(maze, start, end, seen, path);
}

fn mazeWalker(maze: *[5][5]u8, current: Point, end: Point, seen: *[5][5]bool, path: *std.ArrayList(Point)) !bool {
    const x: usize = @intCast(current.x);
    const y: usize = @intCast(current.y);

    // BASE CASE
    // outside the bounds of the array
    if (current.x < 0 or current.x >= maze.len or current.y < 0 or current.y >= maze[0].len) return false;
    // on a wall
    if (maze[x][y] == '#') return false;
    // reached the end
    if (current.x == end.x and current.y == end.y) {
        try path.append(end);
        return true;
    }
    // have we seen this point
    if (seen[x][y]) return false;

    // RECURSE CASE
    // pre
    seen[x][y] = true;
    try path.append(.{ .x = current.x, .y = current.y });
    // recurse
    for (dir, 0..) |d, i| {
        switch (i) {
            0 => std.debug.print("UP\n", .{}),
            1 => std.debug.print("RIGHT\n", .{}),
            2 => std.debug.print("DOWN\n", .{}),
            3 => std.debug.print("LEFT\n", .{}),
            else => unreachable,
        }

        if (try mazeWalker(maze, .{ .x = current.x + d.x, .y = current.y + d.y }, end, seen, path)) return true;
    }
    // post
    _ = path.pop();
    return false;
}
