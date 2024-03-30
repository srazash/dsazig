const std = @import("std");
const testing = std.testing;

const algo = @import("algorithms/algorithms.zig");
const ds = @import("data_structures/data_structures.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    var arena = std.heap.ArenaAllocator.init(gpa.allocator());
    defer arena.deinit();
    const allocator = arena.allocator();

    var my_array = try allocator.alloc(isize, 1024); // create a 1kb array of isize

    var counter: u16 = 0;

    for (my_array, 0..) |_, i| {
        counter += 1;
        my_array[i] = counter;
    }

    std.debug.print("my_array data type -> {}\n", .{@TypeOf(my_array)});
    std.debug.print("my_array[0] data type -> {}\n", .{@TypeOf(my_array[0])});
    std.debug.print("my_array -> {any}\n", .{my_array});

    std.debug.print("{}\n", .{sumCharCodes("Ryan")});

    std.debug.print("linearSearch: 492 in my_array? -> {}\n", .{algo.linearSearch(@TypeOf(my_array), my_array, 492)});

    std.debug.print("binarySearch: 492 in my_array? -> {}\n", .{algo.binarySearch(@TypeOf(my_array), my_array, 492)});

    var mut_array = [_]u8{ 1, 2, 3, 4, 5 };
    const imu_array = [_]u8{ 1, 2, 3, 4, 5 };

    std.debug.print("linearSearch: 3 in mut_array? -> {}\n", .{algo.linearSearch(@TypeOf(&mut_array), &mut_array, 3)});

    std.debug.print("linearSearch: 3 in imu_array? -> {}\n", .{algo.linearSearch(@TypeOf(&imu_array), &imu_array, 3)});

    std.debug.print("type info? -> {}\n", .{@typeInfo(@TypeOf(mut_array))});

    std.debug.print("type info? -> {}\n", .{@typeInfo(@TypeOf(mut_array)).Array.child});

    var my_breaks = try allocator.alloc(bool, 100);

    const breakpoint = 57;
    for (my_breaks, 0..) |_, i| {
        if (i < breakpoint) {
            my_breaks[i] = false;
        } else {
            my_breaks[i] = true;
        }
    }

    std.debug.print("breakpoint set to {} -> {any}\n", .{ breakpoint, my_breaks });
    std.debug.print("breakpoint? -> {?}\n", .{algo.twoCrystalBalls(@TypeOf(my_breaks), my_breaks)});

    var unsorted_array = try allocator.alloc(u8, 10);
    unsorted_array[0] = 10;
    unsorted_array[1] = 3;
    unsorted_array[2] = 5;
    unsorted_array[3] = 6;
    unsorted_array[4] = 2;
    unsorted_array[5] = 4;
    unsorted_array[6] = 9;
    unsorted_array[7] = 7;
    unsorted_array[8] = 1;
    unsorted_array[9] = 8;

    std.debug.print("unsorted_array before bubble sort -> {any}\n", .{unsorted_array});
    algo.bubbleSort(@TypeOf(unsorted_array), unsorted_array);
    std.debug.print("unsorted_array after bubble sort -> {any}\n", .{unsorted_array});

    const my_list = try ds.LinkedList(usize).init(allocator, 10);
    std.debug.print("my_list.len -> {}\n", .{my_list.len});
    std.debug.print("my_list.head.data -> {}\n", .{my_list.head.?.data});
    std.debug.print("my_list.head.addr -> {}\n", .{&my_list.head.?.data});
    std.debug.print("my_list.tail.data -> {}\n", .{my_list.tail.?.data});
    std.debug.print("my_list.tail.addr -> {}\n", .{&my_list.tail.?.data});
}

fn sumCharCodes(n: []const u8) usize {
    // example of a O(N) or linear operation
    var sum: usize = 0;
    for (n) |char| sum += char;
    return sum;
}

fn sumCharCodesE(n: []const u8) usize {
    // another example of a O(N) or linear operation
    var sum: usize = 0;
    for (n) |char| {
        if (char == 69) return sum; // return if char is 'E'
        sum += char;
    }
    return sum;
}

// TESTS

test "test linear search" {
    const my_array = [_]isize{ 1, 2, 3, 4, 5 };
    const result = algo.linearSearch(@TypeOf(&my_array), &my_array, 3);
    try testing.expect(result == true);
}

test "test binary search" {
    const my_array = [_]isize{ 2, 4, 6, 8, 10 };
    const result = algo.binarySearch(@TypeOf(&my_array), &my_array, 8);
    try testing.expect(result == true);
}

test "test two crystal balls" {
    var my_array: [100]bool = undefined;
    const breakpoint = 69;

    for (my_array, 0..) |_, i| {
        if (i < breakpoint) {
            my_array[i] = false;
        } else {
            my_array[i] = true;
        }
    }

    const result = algo.twoCrystalBalls(@TypeOf(&my_array), &my_array);
    try testing.expect(result == breakpoint);
}

test "test bubble sort" {
    const expect = [_]usize{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
    var result = [_]usize{ 10, 3, 5, 6, 2, 4, 9, 7, 1, 8 };
    algo.bubbleSort(@TypeOf(&result), &result);
    try testing.expect(std.mem.eql(usize, &result, &expect));
}

test "basic linked list" {
    var my_list = try ds.LinkedList(usize).init(std.testing.allocator, 100);
    defer my_list.deinit();
    const result = my_list.head.?.data;
    const expect: usize = 100;
    try testing.expect(result == expect);
}
