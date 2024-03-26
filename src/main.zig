const std = @import("std");
const testing = std.testing;

const algo = @import("algorithms/algorithms.zig");

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
    const my_array = [_]isize{ 1, 2, 3, 4, 5 };
    const result = algo.linearSearch(@TypeOf(&my_array), &my_array, 3);
    try testing.expect(result == true);
}
