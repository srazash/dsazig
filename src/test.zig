const std = @import("std");
const testing = std.testing;

const algo = @import("algorithms/algorithms.zig");
const ds = @import("data_structures/data_structures.zig");

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
    const my_nums: [7]u8 = .{ 10, 7, 13, 3, 9, 11, 15 };
    for (my_nums) |n| try my_tree.insert(n);

    var my_path = std.ArrayList(u8).init(std.testing.allocator);
    defer my_path.deinit();

    try my_tree.preOrderSearch(&my_path);

    try std.testing.expect(my_path.items[0] == 10);
    try std.testing.expect(my_path.items[3] == 9);
    try std.testing.expect(my_path.items[6] == 15);
}

test "in order transversal" {
    var my_tree = try ds.BinaryTree(u8).init(std.testing.allocator);
    defer my_tree.deinit();
    const my_nums: [7]u8 = .{ 10, 7, 13, 3, 9, 11, 15 };
    for (my_nums) |n| try my_tree.insert(n);

    var my_path = std.ArrayList(u8).init(std.testing.allocator);
    defer my_path.deinit();

    try my_tree.inOrderSearch(&my_path);

    try std.testing.expect(my_path.items[0] == 3);
    try std.testing.expect(my_path.items[3] == 10);
    try std.testing.expect(my_path.items[6] == 15);
}

test "post order transversal" {
    var my_tree = try ds.BinaryTree(u8).init(std.testing.allocator);
    defer my_tree.deinit();
    const my_nums: [7]u8 = .{ 10, 7, 13, 3, 9, 11, 15 };
    for (my_nums) |n| try my_tree.insert(n);

    var my_path = std.ArrayList(u8).init(std.testing.allocator);
    defer my_path.deinit();

    try my_tree.postOrderSearch(&my_path);

    try std.testing.expect(my_path.items[0] == 3);
    try std.testing.expect(my_path.items[3] == 11);
    try std.testing.expect(my_path.items[6] == 10);
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

test "depth-first compare" {
    var my_tree_a = try ds.BinaryTree(u8).init(std.testing.allocator);
    defer my_tree_a.deinit();

    var my_tree_b = try ds.BinaryTree(u8).init(std.testing.allocator);
    defer my_tree_b.deinit();

    const my_nums: [7]u8 = .{ 1, 2, 3, 4, 5, 6, 7 };
    for (my_nums) |n| try my_tree_a.insert(n);
    for (my_nums) |n| try my_tree_b.insert(n);

    try std.testing.expect(try my_tree_a.compare(my_tree_b));

    my_tree_b.root.?.data = 99;
    try std.testing.expect(try my_tree_a.compare(my_tree_b) == false);
}

test "depth-first find" {
    var my_tree = try ds.BinaryTree(u8).init(std.testing.allocator);
    defer my_tree.deinit();

    my_tree.root = try my_tree.new(10);
    my_tree.root.?.left = try my_tree.new(7);
    my_tree.root.?.right = try my_tree.new(13);
    my_tree.root.?.left.?.left = try my_tree.new(3);
    my_tree.root.?.left.?.right = try my_tree.new(9);
    my_tree.root.?.right.?.left = try my_tree.new(11);
    my_tree.root.?.right.?.right = try my_tree.new(15);

    try std.testing.expect(my_tree.find(11));
    try std.testing.expect(my_tree.find(20) == false);
}

test "depth-first insert" {
    var my_tree = try ds.BinaryTree(u8).init(std.testing.allocator);
    defer my_tree.deinit();

    try my_tree.insert(50);
    try my_tree.insert(25);
    try my_tree.insert(75);
    try my_tree.insert(0);
    try my_tree.insert(100);

    try std.testing.expect(my_tree.root.?.left.?.left.?.data == 0);
    try std.testing.expect(my_tree.root.?.right.?.right.?.data == 100);
}

test "depth-first search" {
    var my_tree = try ds.BinaryTree(u8).init(std.testing.allocator);
    defer my_tree.deinit();

    try my_tree.insert(50);
    try my_tree.insert(25);
    try my_tree.insert(75);
    try my_tree.insert(0);
    try my_tree.insert(100);

    try std.testing.expect(my_tree.search(100));
    try std.testing.expect(my_tree.search(101) == false);
}

test "heap" {
    var my_heap = ds.Heap(u8).init(std.testing.allocator);
    defer my_heap.deinit();

    const my_nums: [7]u8 = .{ 10, 7, 13, 3, 9, 11, 15 };
    for (my_nums) |n| try my_heap.add(n);

    try std.testing.expect(my_heap.length == 7);

    _ = try my_heap.delete();
    _ = try my_heap.delete();

    try std.testing.expect(my_heap.length == 5);
    try std.testing.expect(my_heap.data.items[4] > my_heap.data.items[0]);
}
