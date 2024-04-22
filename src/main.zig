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

    const stdout = std.io.getStdOut().writer();

    var my_array = try allocator.alloc(isize, 1024); // create a 1kb array of isize

    var counter: u16 = 0;

    for (my_array, 0..) |_, i| {
        counter += 1;
        my_array[i] = counter;
    }

    try stdout.print("my_array data type -> {}\n", .{@TypeOf(my_array)});
    try stdout.print("my_array[0] data type -> {}\n", .{@TypeOf(my_array[0])});
    try stdout.print("my_array -> {any}\n", .{my_array});

    try stdout.print("{}\n", .{sumCharCodes("Ryan")});

    try stdout.print("linearSearch: 492 in my_array? -> {}\n", .{algo.linearSearch(@TypeOf(my_array), my_array, 492)});

    try stdout.print("binarySearch: 492 in my_array? -> {}\n", .{algo.binarySearch(@TypeOf(my_array), my_array, 492)});

    var mut_array = [_]u8{ 1, 2, 3, 4, 5 };
    const imu_array = [_]u8{ 1, 2, 3, 4, 5 };

    try stdout.print("linearSearch: 3 in mut_array? -> {}\n", .{algo.linearSearch(@TypeOf(&mut_array), &mut_array, 3)});

    try stdout.print("linearSearch: 3 in imu_array? -> {}\n", .{algo.linearSearch(@TypeOf(&imu_array), &imu_array, 3)});

    try stdout.print("type info? -> {}\n", .{@typeInfo(@TypeOf(mut_array))});

    try stdout.print("type info? -> {}\n", .{@typeInfo(@TypeOf(mut_array)).Array.child});

    var my_breaks = try allocator.alloc(bool, 100);

    const breakpoint = 57;
    for (my_breaks, 0..) |_, i| {
        if (i < breakpoint) {
            my_breaks[i] = false;
        } else {
            my_breaks[i] = true;
        }
    }

    try stdout.print("breakpoint set to {} -> {any}\n", .{ breakpoint, my_breaks });
    try stdout.print("breakpoint? -> {?}\n", .{algo.twoCrystalBalls(@TypeOf(my_breaks), my_breaks)});

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

    try stdout.print("unsorted_array before bubble sort -> {any}\n", .{unsorted_array});
    algo.bubbleSort(@TypeOf(unsorted_array), unsorted_array);
    try stdout.print("unsorted_array after bubble sort -> {any}\n", .{unsorted_array});

    var my_list = try ds.LinkedList(usize).init(allocator);

    try my_list.push(10);
    try my_list.push(20);
    try my_list.push(30);

    try stdout.print("my_list.len -> {}\n", .{my_list.len});
    try stdout.print("my_list.length() -> {}\n", .{my_list.length()});
    try stdout.print("len matches length? -> {}\n", .{my_list.validateLength()});

    try stdout.print("my_list.head.data -> {}\n", .{my_list.head.?.data});
    try stdout.print("&my_list.head -> {?*}\n", .{my_list.head});

    try stdout.print("my_list.tail.data -> {}\n", .{my_list.tail.?.data});
    try stdout.print("&my_list.tail -> {?*}\n", .{my_list.tail});

    try stdout.print("my_list.head.next.data -> {}\n", .{my_list.head.?.next.?.data});
    try stdout.print("&my_list.head.next -> {?*}\n", .{my_list.head.?.next});

    try stdout.print("&my_list.head.prev -> {?*}\n", .{my_list.head.?.prev});
    try stdout.print("&my_list.tail.next -> {?*}\n", .{my_list.tail.?.next});

    try stdout.print("my_list.at(0) -> {} ({})\n", .{ try my_list.at(0), @TypeOf(try my_list.at(0)) });
    try stdout.print("my_list.at(1) -> {} ({})\n", .{ try my_list.at(1), @TypeOf(try my_list.at(1)) });
    try stdout.print("my_list.at(2) -> {} ({})\n", .{ try my_list.at(2), @TypeOf(try my_list.at(2)) });

    try stdout.print("my_list.addrOf(0) -> {?*}\n", .{try my_list.addrOf(0)});
    try stdout.print("my_list.addrOf(1) -> {?*}\n", .{try my_list.addrOf(1)});
    try stdout.print("my_list.addrOf(2) -> {?*}\n", .{try my_list.addrOf(2)});

    try my_list.delete(1);
    try stdout.print("my_list.at(1) -> {} ({})\n", .{ try my_list.at(1), @TypeOf(try my_list.at(1)) });
    try stdout.print("my_list.addrOf(1) -> {?*}\n", .{try my_list.addrOf(1)});

    try stdout.print("my_list.len -> {}\n", .{my_list.len});
    try stdout.print("my_list.length() -> {}\n", .{my_list.length()});
    try stdout.print("len matches length? -> {}\n", .{my_list.validateLength()});

    try my_list.insert(0, 15);
    try my_list.insert(2, 35);
    try my_list.printList();
    try my_list.printDetail();

    try stdout.print("queue peek() -> {?}\n", .{my_list.queuePeek()});
    try stdout.print("stack peek() -> {?}\n", .{my_list.stackPeek()});

    try stdout.print("\n", .{});

    _ = algo.simpleRecursion(10);

    var maze = try allocator.create([5][5]u8);

    // create a maze to solve:
    // # # # # #
    // #   #   E
    // #   #   #
    // #       #
    // # S # # #

    maze[0][0] = '#';
    maze[0][1] = '#';
    maze[0][2] = '#';
    maze[0][3] = '#';
    maze[0][4] = '#';

    maze[1][0] = '#';
    maze[1][1] = ' ';
    maze[1][2] = '#';
    maze[1][3] = ' ';
    maze[1][4] = 'E';

    maze[2][0] = '#';
    maze[2][1] = ' ';
    maze[2][2] = '#';
    maze[2][3] = ' ';
    maze[2][4] = '#';

    maze[3][0] = '#';
    maze[3][1] = ' ';
    maze[3][2] = ' ';
    maze[3][3] = ' ';
    maze[3][4] = '#';

    maze[4][0] = '#';
    maze[4][1] = 'S';
    maze[4][2] = '#';
    maze[4][3] = '#';
    maze[4][4] = '#';

    for (maze, 0..) |_, x| {
        for (maze, 0..) |_, y| {
            try stdout.print("{u} ", .{maze[x][y]});
        }
        try stdout.print("\n", .{});
    }

    var path = std.ArrayList(algo.Point).init(allocator);
    try algo.mazeSolver(allocator, maze, .{ .x = 4, .y = 1 }, .{ .x = 1, .y = 4 }, &path);
    for (path.items) |item| try stdout.print("{any}\n", .{item});

    // QUICK SORT
    var my_unsorted_array = try allocator.alloc(u8, 512);

    const rand = std.crypto.random;
    for (my_unsorted_array, 0..) |_, i| my_unsorted_array[i] = rand.intRangeAtMost(u8, 0, 255);

    try stdout.print("UNSORTED:\n{any}\n", .{my_unsorted_array});

    algo.quickSort(@TypeOf(my_unsorted_array), my_unsorted_array, 0, my_unsorted_array.len - 1);

    try stdout.print("SORTED?:\n{any}\n", .{my_unsorted_array});

    // TREES
    var my_tree = try ds.BinaryTree(u8).init(allocator);

    my_tree.root = try my_tree.new(7);
    my_tree.root.?.left = try my_tree.new(23);
    my_tree.root.?.right = try my_tree.new(3);
    my_tree.root.?.left.?.left = try my_tree.new(5);
    my_tree.root.?.left.?.right = try my_tree.new(4);
    my_tree.root.?.right.?.left = try my_tree.new(18);
    my_tree.root.?.right.?.right = try my_tree.new(21);

    try stdout.print("new root -> {?}\n", .{my_tree.root.?.data});
    try stdout.print("new root.left -> {?}\n", .{my_tree.root.?.left.?.data});
    try stdout.print("new root.right -> {?}\n", .{my_tree.root.?.right.?.data});
    try stdout.print("new root.left.left -> {?}\n", .{my_tree.root.?.left.?.left.?.data});
    try stdout.print("new root.left.right -> {?}\n", .{my_tree.root.?.left.?.right.?.data});
    try stdout.print("new root.right.left -> {?}\n", .{my_tree.root.?.right.?.left.?.data});
    try stdout.print("new root.right.right -> {?}\n", .{my_tree.root.?.right.?.right.?.data});

    var my_new_tree = try ds.BinaryTree(u8).init(allocator);
    const my_new_nums: [7]u8 = .{ 7, 23, 3, 5, 4, 18, 21 };
    for (my_new_nums) |n| try my_new_tree.insert(n);
    var my_pre_path = std.ArrayList(u8).init(allocator);
    try my_new_tree.preOrderSearch(&my_pre_path);
    try stdout.print("my_pre_path -> {any}\n", .{my_pre_path.items});

    var my_inorder_path = std.ArrayList(u8).init(allocator);
    try my_new_tree.inOrderSearch(&my_inorder_path);
    try stdout.print("my_in_order_path -> {any}\n", .{my_inorder_path.items});

    var my_post_path = std.ArrayList(u8).init(allocator);
    try my_new_tree.postOrderSearch(&my_post_path);
    try stdout.print("my_post_path -> {any}\n", .{my_post_path.items});

    // BREADTH-FIRST SEARCH
    try stdout.print("my_tree contains 99? -> {}\n", .{try my_tree.breadthFirstSearch(99)});
    try stdout.print("my_tree contains 5? -> {}\n", .{try my_tree.breadthFirstSearch(5)});
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

test "linked list: push" {
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

test "linked list: at" {
    var my_list = try ds.LinkedList(usize).init(std.testing.allocator);
    defer my_list.deinit();

    try my_list.push(25); // 0
    try my_list.push(50); // 1
    try my_list.push(75); // 2

    const expect: usize = 75;
    const result = try my_list.at(2);

    try testing.expect(result == expect);
}

test "linked list: empty list error" {
    var my_list = try ds.LinkedList(usize).init(std.testing.allocator);
    defer my_list.deinit();

    try testing.expectError(error.EmptyList, my_list.at(0));
}

test "linked list: out of bounds error" {
    var my_list = try ds.LinkedList(usize).init(std.testing.allocator);
    defer my_list.deinit();

    try my_list.push(1); // 0

    try testing.expectError(error.OutOfBounds, my_list.at(1));
}

test "linked list: len vs length" {
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

test "linked list: addrof" {
    var my_list = try ds.LinkedList(usize).init(std.testing.allocator);
    defer my_list.deinit();

    try my_list.push(1);

    const expect = my_list.head;
    const result = try my_list.addrOf(0);

    try testing.expect(result == expect);
}

test "linked list: delete" {
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

test "linked list: push and pop" {
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

test "linked list: enqueue and dequeue" {
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

test "linked list: prepend" {
    var my_list = try ds.LinkedList(usize).init(std.testing.allocator);
    defer my_list.deinit();

    try my_list.append(1);
    try my_list.prepend(100);

    try testing.expect(try my_list.at(0) == 100);
    try testing.expect(try my_list.at(1) == 1);
    try testing.expect(my_list.head == try my_list.addrOf(0));
    try testing.expect(my_list.tail == try my_list.addrOf(1));
}

test "linked list: update" {
    var my_list = try ds.LinkedList(usize).init(std.testing.allocator);
    defer my_list.deinit();

    try my_list.append(99);
    try testing.expect(try my_list.at(0) == 99);

    try my_list.update(0, 100);
    try testing.expect(try my_list.at(0) == 100);
}

test "linked list: insert" {
    var my_list = try ds.LinkedList(usize).init(std.testing.allocator);
    defer my_list.deinit();

    try my_list.append(10); // 0
    try my_list.append(20); // 1
    try my_list.append(30); // 2
    try testing.expect(my_list.len == my_list.length());
    try testing.expect(try my_list.at(1) == 20);

    try my_list.insert(0, 15); // insert mid-list
    try testing.expect(my_list.len == my_list.length());
    try testing.expect(try my_list.at(1) == 15);

    try my_list.insert(3, 35); // insert at end of list
    try testing.expect(my_list.len == my_list.length());
    try testing.expect(try my_list.at(4) == 35);
}

test "simple recursion" {
    const expect: usize = 1;

    var result = algo.simpleRecursion(10);
    try testing.expect(result == expect);

    result = algo.simpleRecursion(100);
    try testing.expect(result == expect);

    result = algo.simpleRecursion(1000);
    try testing.expect(result == expect);
}

test "recursive maze solver" {
    const allocator = std.testing.allocator;
    var maze = try allocator.create([5][5]u8);
    defer allocator.destroy(maze);

    maze[0][0] = '#';
    maze[0][1] = '#';
    maze[0][2] = '#';
    maze[0][3] = '#';
    maze[0][4] = '#';

    maze[1][0] = '#';
    maze[1][1] = ' ';
    maze[1][2] = ' ';
    maze[1][3] = ' ';
    maze[1][4] = 'E';

    maze[2][0] = '#';
    maze[2][1] = '#';
    maze[2][2] = ' ';
    maze[2][3] = '#';
    maze[2][4] = '#';

    maze[3][0] = '#';
    maze[3][1] = ' ';
    maze[3][2] = ' ';
    maze[3][3] = ' ';
    maze[3][4] = '#';

    maze[4][0] = '#';
    maze[4][1] = 'S';
    maze[4][2] = '#';
    maze[4][3] = '#';
    maze[4][4] = '#';

    var path = std.ArrayList(algo.Point).init(allocator);
    defer path.deinit();

    const start: algo.Point = .{ .x = 4, .y = 1 };
    const end: algo.Point = .{ .x = 1, .y = 4 };

    try algo.mazeSolver(std.testing.allocator, maze, start, end, &path);

    try testing.expect(std.meta.eql(path.items[0], start));
    try testing.expect(std.meta.eql(path.items[6], end));
}

test "quick sort" {
    var my_array = try std.testing.allocator.alloc(u8, 5);
    defer std.testing.allocator.free(my_array);

    const rand = std.crypto.random;
    for (my_array, 0..) |_, i| my_array[i] = rand.intRangeAtMost(u8, 0, 255);

    algo.quickSort(@TypeOf(my_array), my_array, 0, my_array.len - 1);

    try testing.expect(my_array[0] <= my_array[1]);
    try testing.expect(my_array[1] <= my_array[2]);
    try testing.expect(my_array[2] <= my_array[3]);
    try testing.expect(my_array[3] <= my_array[4]);
}

test "basic tree test" {
    var my_tree = try ds.BinaryTree(usize).init(std.testing.allocator);
    defer my_tree.deinit();

    my_tree.root = try my_tree.new(1);
    my_tree.root.?.left = try my_tree.new(2);
    my_tree.root.?.right = try my_tree.new(3);

    try std.testing.expect(my_tree.root.?.data == 1);
    try std.testing.expect(my_tree.root.?.left.?.data == 2);
    try std.testing.expect(my_tree.root.?.right.?.data == 3);
}

test "pre order transversal" {
    var my_tree = try ds.BinaryTree(u8).init(std.testing.allocator);
    defer my_tree.deinit();
    const my_nums: [7]u8 = .{ 1, 2, 3, 4, 5, 6, 7 };
    for (my_nums) |n| try my_tree.insert(n);

    var my_path = std.ArrayList(u8).init(std.testing.allocator);
    defer my_path.deinit();

    try my_tree.preOrderSearch(&my_path);

    try std.testing.expect(my_path.items[0] == 1);
    try std.testing.expect(my_path.items[6] == 7);
}

test "in order transversal" {
    var my_tree = try ds.BinaryTree(u8).init(std.testing.allocator);
    defer my_tree.deinit();
    const my_nums: [7]u8 = .{ 1, 2, 3, 4, 5, 6, 7 };
    for (my_nums) |n| try my_tree.insert(n);

    var my_path = std.ArrayList(u8).init(std.testing.allocator);
    defer my_path.deinit();

    try my_tree.inOrderSearch(&my_path);

    try std.testing.expect(my_path.items[0] == 2);
    try std.testing.expect(my_path.items[1] == 1);
    try std.testing.expect(my_path.items[6] == 7);
}

test "post order transversal" {
    var my_tree = try ds.BinaryTree(u8).init(std.testing.allocator);
    defer my_tree.deinit();
    const my_nums: [7]u8 = .{ 1, 2, 3, 4, 5, 6, 7 };
    for (my_nums) |n| try my_tree.insert(n);

    var my_path = std.ArrayList(u8).init(std.testing.allocator);
    defer my_path.deinit();

    try my_tree.postOrderSearch(&my_path);

    try std.testing.expect(my_path.items[0] == 2);
    try std.testing.expect(my_path.items[5] == 3);
    try std.testing.expect(my_path.items[6] == 1);
}

test "breadth-first search" {
    var my_tree = try ds.BinaryTree(u8).init(std.testing.allocator);
    defer my_tree.deinit();

    const my_nums: [7]u8 = .{ 1, 2, 3, 4, 5, 6, 7 };
    for (my_nums) |n| try my_tree.insert(n);

    try std.testing.expect(try my_tree.breadthFirstSearch(7));
    try std.testing.expect(try my_tree.breadthFirstSearch(1));
    try std.testing.expect(try my_tree.breadthFirstSearch(99) == false);
}
