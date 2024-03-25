const std = @import("std");

pub fn linearSearch(comptime T: type, haystack: T, needle: anytype) bool {
    // linear search is O(N)
    for (haystack) |e| if (e == needle) return true;
    return false;
}

pub fn binarySearch(comptime T: type, haystack: T, needle: anytype, low: usize, high: usize) bool {
    const middle = low + (high - low) / 2;
    const value = haystack[middle];
}
