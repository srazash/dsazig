const std = @import("std");

pub fn linearSearch(haystack: []isize, needle: isize) bool {
    // linear search is O(N)
    for (haystack) |e| if (e == needle) return true;
    return false;
}
