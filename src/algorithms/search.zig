const std = @import("std");

pub fn linearSearch(haystack: []isize, needle: isize) bool {
    // linear search is O(N)
    for (haystack) |e| if (e == needle) return true;
    return false;
}

pub fn binarySearch(haystack: []isize, needle: isize) bool {
    var low: usize = 1;
    var high: usize = haystack.len;
    var middle: usize = 0;
    var current: isize = 0;

    while (low < high) {
        middle = (low + (high - low)) / 2;
        current = haystack[middle];
        std.debug.print("m:{} c:{}\n", .{ middle, current });
        if (current == needle) {
            return true;
        } else if (current > haystack[middle]) {
            low = middle + 1;
        } else {
            high = middle;
        }
    }

    return false;
}
