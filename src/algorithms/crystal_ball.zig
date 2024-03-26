const std = @import("std");

pub fn twoCrystalBalls(comptime T: type, breaks: T) ?usize {
    const jump: usize = std.math.sqrt(breaks.len);

    var i: usize = jump;

    while (i < breaks.len) : (i += jump) {
        if (breaks[i]) break;
    }

    i -= jump;

    while (i < breaks.len) : (i += 1) {
        if (breaks[i]) return i;
    }

    return null;
}
