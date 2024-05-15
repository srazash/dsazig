const std = @import("std");

const algo = @import("algorithms/algorithms.zig");
const ds = @import("data_structures/data_structures.zig");

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

    // DEPTH-FIRST FIND
    var my_ordered_tree = try ds.BinaryTree(u8).init(allocator);

    my_ordered_tree.root = try my_ordered_tree.new(10);
    my_ordered_tree.root.?.left = try my_ordered_tree.new(7);
    my_ordered_tree.root.?.right = try my_ordered_tree.new(13);
    my_ordered_tree.root.?.left.?.left = try my_ordered_tree.new(3);
    my_ordered_tree.root.?.left.?.right = try my_ordered_tree.new(9);
    my_ordered_tree.root.?.right.?.left = try my_ordered_tree.new(11);
    my_ordered_tree.root.?.right.?.right = try my_ordered_tree.new(15);

    try stdout.print("my_ordered_tree contains 11? -> {}\n", .{my_ordered_tree.find(11)});
    try stdout.print("my_ordered_tree contains 20? -> {}\n", .{my_ordered_tree.find(20)});

    // DEPTH-FIRST INSERT
    var my_insert_tree = try ds.BinaryTree(u8).init(allocator);

    try my_insert_tree.insert(50);
    try my_insert_tree.insert(25);
    try my_insert_tree.insert(75);
    try my_insert_tree.insert(99);

    try stdout.print("my_insert_tree root.right.right -> {}\n", .{my_insert_tree.root.?.right.?.right.?.data});

    var my_ttree = try ds.BinaryTree(u8).init(allocator);
    const my_nnums: [7]u8 = .{ 10, 7, 13, 3, 9, 11, 15 };
    for (my_nnums) |n| try my_ttree.insert(n);

    var my_ppath = std.ArrayList(u8).init(allocator);
    try my_ttree.preOrderSearch(&my_ppath);
    try stdout.print("preo -> {any}\n", .{my_ppath.items});

    my_ppath.clearRetainingCapacity();
    try my_ttree.inOrderSearch(&my_ppath);
    try stdout.print("ino -> {any}\n", .{my_ppath.items});

    my_ppath.clearRetainingCapacity();
    try my_ttree.postOrderSearch(&my_ppath);
    try stdout.print("posto -> {any}\n", .{my_ppath.items});

    // DEPTH-FIRST SEARCH
    try stdout.print("my_ttree contain 100 -> {}\n", .{my_ttree.search(100)});
    try stdout.print("my_ttree contain 11 -> {}\n", .{my_ttree.search(11)});

    // HEAP / PRIORITY QUEUE
    var my_heap = ds.Heap(u8).init(allocator);
    for (my_nnums) |n| try my_heap.add(n);

    try stdout.print("my_heap length -> {}\n", .{my_heap.length});
    try stdout.print("my_heap -> {any}\n", .{my_heap.data.items});

    for (0..7) |_| {
        _ = try my_heap.delete();
    }

    for (my_nnums) |n| try my_heap.add(n);

    try stdout.print("my_heap length -> {}\n", .{my_heap.length});
    try stdout.print("my_heap -> {any}\n", .{my_heap.data.items});
}
