const std = @import("std");

pub fn bubbleSort(comptime T: type, array: T) void {
    for (array, 0..) |_, i| {
        var j: usize = 0;
        while (j < array.len - (i + 1)) : (j += 1) {
            if (array[j] > array[j + 1]) {
                const tmp = array[j];
                array[j] = array[j + 1];
                array[j + 1] = tmp;
            }
        }
    }
}
