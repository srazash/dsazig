const std = @import("std");

pub fn GraphAL(vertex: usize) type {
    return struct {
        const Edge = struct {
            to: usize,
            weight: ?usize,
        };

        const Self = @This();
    };
}

pub fn GraphAM(vertex: usize) type {
    return struct {
        const Self = @This();
    };
}
