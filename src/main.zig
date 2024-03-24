const std = @import("std");
const testing = std.testing;

const algo = @import("algorithms/algorithms.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var my_array = try allocator.alloc(isize, 1024); // create a 1kb array of isize
    defer allocator.free(my_array);

    var counter: u16 = 0;

    for (my_array, 0..) |_, i| {
        counter += 1;
        my_array[i] = counter;
    }

    std.debug.print("my_array data type -> {}\n", .{@TypeOf(my_array)});
    std.debug.print("my_array[0] data type -> {}\n", .{@TypeOf(my_array[0])});
    std.debug.print("my_array -> {any}\n", .{my_array});

    std.debug.print("{}\n", .{sumCharCodes("Ryan")});

    std.debug.print("linearSearch: 492 in my_array? -> {}\n", .{algo.linearSearch(my_array[0..], 492)});

    std.debug.print("binarySearch: 492 in my_array? -> {}\n", .{algo.binarySearch(my_array[0..], 492)});
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

test "test linear search" {
    var my_array = [_]isize{ 1, 2, 3, 4, 5 };
    const result = algo.linearSearch(&my_array, 3);
    try testing.expect(result == true);
}
