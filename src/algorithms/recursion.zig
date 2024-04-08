const std = @import("std");

pub fn simpleRecursion(n: usize) usize {
    // base case
    if (n == 1) {
        std.debug.print("base case! {}\n", .{n});
        return n;
    }

    // recurse case
    // pre
    std.debug.print("pre: recurse case! {}\n", .{n});
    // recurse
    const rec = simpleRecursion(n - 1);
    // post
    std.debug.print("post: recurse case! {}\n", .{n});
    return rec;
}

const Point = struct {
    x: usize,
    y: usize,
};

pub fn mazeSolver(maze: [][]u8, wall: []const u8, start: Point, end: Point) []Point {}

fn mazeWalker(maze: [][]u8, wall: []const u8, current: Point, end: Point, seen: [][]bool, path: []Point) bool {
    // BASE CASE
    // outside the bounds of the array
    if (current.x < 0 or current.x >= maze[0].len or current.y < 0 or current.y >= maze.len) return false;
    // on a wall
    if (maze[current.y][current.x] == wall) return false;
    // reached the end
    if (current.x == end.x and current.y == end.y) return true;
    // have we seen this point
    if (seen[current.x][current.y]) return false;

    // RECURSE CASE
    // pre
    // add current to []path - ArrayList? needs to push/pop
    // recurse
    // loop over directions (up, right, down, left)
    // recurse over the directions
    // post
    // remove current from []path
}
