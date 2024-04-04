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

    var my_list = try ds.LinkedList(usize).init(allocator);

    try my_list.push(10);
    try my_list.push(20);
    try my_list.push(30);

    std.debug.print("my_list.len -> {}\n", .{my_list.len});
    std.debug.print("my_list.length() -> {}\n", .{my_list.length()});
    std.debug.print("len matches length? -> {}\n", .{my_list.validateLength()});

    std.debug.print("my_list.head.data -> {}\n", .{my_list.head.?.data});
    std.debug.print("&my_list.head -> {?*}\n", .{my_list.head});

    std.debug.print("my_list.tail.data -> {}\n", .{my_list.tail.?.data});
    std.debug.print("&my_list.tail -> {?*}\n", .{my_list.tail});

    std.debug.print("my_list.head.next.data -> {}\n", .{my_list.head.?.next.?.data});
    std.debug.print("&my_list.head.next -> {?*}\n", .{my_list.head.?.next});

    std.debug.print("&my_list.head.prev -> {?*}\n", .{my_list.head.?.prev});
    std.debug.print("&my_list.tail.next -> {?*}\n", .{my_list.tail.?.next});

    std.debug.print("my_list.at(0) -> {} ({})\n", .{ try my_list.at(0), @TypeOf(try my_list.at(0)) });
    std.debug.print("my_list.at(1) -> {} ({})\n", .{ try my_list.at(1), @TypeOf(try my_list.at(1)) });
    std.debug.print("my_list.at(2) -> {} ({})\n", .{ try my_list.at(2), @TypeOf(try my_list.at(2)) });

    std.debug.print("my_list.addrOf(0) -> {?*}\n", .{try my_list.addrOf(0)});
    std.debug.print("my_list.addrOf(1) -> {?*}\n", .{try my_list.addrOf(1)});
    std.debug.print("my_list.addrOf(2) -> {?*}\n", .{try my_list.addrOf(2)});

    try my_list.delete(1);
    std.debug.print("my_list.at(1) -> {} ({})\n", .{ try my_list.at(1), @TypeOf(try my_list.at(1)) });
    std.debug.print("my_list.addrOf(1) -> {?*}\n", .{try my_list.addrOf(1)});

    std.debug.print("my_list.len -> {}\n", .{my_list.len});
    std.debug.print("my_list.length() -> {}\n", .{my_list.length()});
    std.debug.print("len matches length? -> {}\n", .{my_list.validateLength()});
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
    var my_list = try ds.LinkedList(usize).init(std.testing.allocator);
    defer my_list.deinit();
    try my_list.push(100);
    const result = my_list.head.?.data;
    const expect: usize = 100;
    try testing.expect(result == expect);
}

test "linked list push" {
    var my_list = try ds.LinkedList(usize).init(std.testing.allocator);
    defer my_list.deinit();

    try my_list.push(10); // head
    try my_list.push(20);
    try my_list.push(30); // tail

    // test data exists that has been passed to the list using push()
    const test_head = my_list.head.?.data == 10;
    const test_head_next = my_list.head.?.next.?.data == 20;
    const test_tail = my_list.tail.?.data == 30;

    // test len of the list
    const test_len = my_list.len == 3;

    try testing.expect(test_head and test_head_next and test_tail and test_len);
}

test "linked list at" {
    var my_list = try ds.LinkedList(usize).init(std.testing.allocator);
    defer my_list.deinit();

    try my_list.push(25); // 0
    try my_list.push(50); // 1
    try my_list.push(75); // 2

    const expect: usize = 75;
    const result = try my_list.at(2);

    try testing.expect(result == expect);
}

test "linked list at: empty list" {
    var my_list = try ds.LinkedList(usize).init(std.testing.allocator);
    defer my_list.deinit();

    try testing.expectError(error.EmptyList, my_list.at(0));
}

test "linked list at: out of bounds" {
    var my_list = try ds.LinkedList(usize).init(std.testing.allocator);
    defer my_list.deinit();

    try my_list.push(1); // 0

    try testing.expectError(error.OutOfBounds, my_list.at(1));
}

test "linked list at: len vs length" {
    var my_list = try ds.LinkedList(usize).init(std.testing.allocator);
    defer my_list.deinit();

    try my_list.push(25);
    try my_list.push(50);
    try my_list.push(75);

    const len_result: usize = 3;
    const length_result: usize = 3;
    const vl_result: bool = true;

    try testing.expect(len_result == my_list.len);
    try testing.expect(length_result == my_list.length());
    try testing.expect(vl_result == my_list.validateLength());
}

test "linked list at: addrof" {
    var my_list = try ds.LinkedList(usize).init(std.testing.allocator);
    defer my_list.deinit();

    try my_list.push(1);

    const expect = my_list.head;
    const result = try my_list.addrOf(0);

    try testing.expect(result == expect);
}

test "linked list at: delete" {
    var my_list = try ds.LinkedList(usize).init(std.testing.allocator);
    defer my_list.deinit();

    try my_list.push(5);
    try my_list.push(10);
    try my_list.push(15);
    try my_list.push(20);
    try my_list.push(25);

    try testing.expect(my_list.len == 5);
    try testing.expect(my_list.length() == 5);

    try my_list.delete(0); // delete head

    try testing.expect(my_list.len == 4);
    try testing.expect(my_list.length() == 4);
    try testing.expect(my_list.head == try my_list.addrOf(0));

    try my_list.delete(3); // delete tail

    try testing.expect(my_list.len == 3);
    try testing.expect(my_list.length() == 3);
    try testing.expect(my_list.tail == try my_list.addrOf(2));

    try my_list.delete(0);
    try my_list.delete(0);

    try testing.expect(my_list.len == 1);
    try testing.expect(my_list.length() == 1);
    try testing.expect(my_list.head == try my_list.addrOf(0));
    try testing.expect(my_list.tail == try my_list.addrOf(0));

    try my_list.delete(0);

    try testing.expect(my_list.len == 0);
    try testing.expect(my_list.length() == 0);
    try testing.expect(my_list.head == null);
    try testing.expect(my_list.tail == null);
}

test "linked list at: push and pop" {
    var my_list = try ds.LinkedList(usize).init(std.testing.allocator);
    defer my_list.deinit();

    try my_list.push(1);
    try my_list.push(2);
    try my_list.push(3);

    try testing.expect(my_list.len == 3);
    try testing.expect(my_list.length() == 3);

    var data = try my_list.pop();
    try testing.expect(data == 3);

    data = try my_list.pop();
    try testing.expect(data == 2);

    data = try my_list.pop();
    try testing.expect(data == 1);

    try testing.expect(my_list.len == 0);
    try testing.expect(my_list.length() == 0);
}

test "linked list at: enqueue and dequeue" {
    var my_list = try ds.LinkedList(usize).init(std.testing.allocator);
    defer my_list.deinit();

    try my_list.enqueue(1);
    try my_list.enqueue(2);
    try my_list.enqueue(3);

    try testing.expect(my_list.len == 3);
    try testing.expect(my_list.length() == 3);

    var data = try my_list.dequeue();
    try testing.expect(data == 1);

    data = try my_list.dequeue();
    try testing.expect(data == 2);

    data = try my_list.dequeue();
    try testing.expect(data == 3);

    try testing.expect(my_list.len == 0);
    try testing.expect(my_list.length() == 0);
}

test "linked list at: prepend" {
    var my_list = try ds.LinkedList(usize).init(std.testing.allocator);
    defer my_list.deinit();

    try my_list.push(1);
    try my_list.prepend(100);

    try testing.expect(try my_list.at(0) == 100);
    try testing.expect(try my_list.at(1) == 1);
    try testing.expect(my_list.head == try my_list.addrOf(0));
    try testing.expect(my_list.tail == try my_list.addrOf(1));
}
