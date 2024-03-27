const std = @import("std");

const Linked_List = struct {
    allocator: std.mem.Allocator,
    T: type,
    head: ?Node = null,
    len: usize = 0,

    const Node = struct {
        T: type,
        next: ?Node,
    };
};
