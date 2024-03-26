const std = @import("std");

pub fn linearSearch(comptime T: type, haystack: T, needle: anytype) bool {
    // linear search is O(N)
    for (haystack) |e| if (e == needle) return true;
    return false;
}

pub fn binarySearch(comptime T: type, haystack: T, needle: anytype) bool {
    var low: usize = 0;
    var high: usize = haystack.len;

    while (low < high) {
        const middle = low + (high - low) / 2;
        const value = haystack[middle];

        if (value == needle) {
            return true;
        } else if (value > needle) {
            high = middle;
        } else {
            low = middle + 1;
        }
    }

    return false;
}
