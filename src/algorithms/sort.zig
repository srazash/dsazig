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

pub fn quickSort(comptime T: type, array: T, low: usize, high: usize) void {
    if (low < high) {
        const pivot_idx = quickSortPartition(T, array, low, high);
        if (pivot_idx > 0) quickSort(T, array, low, pivot_idx - 1);
        quickSort(T, array, pivot_idx + 1, high);
    }
}

fn quickSortPartition(comptime T: type, array: T, low: usize, high: usize) usize {
    const pivot = array[low];
    var i: usize = low + 1;
    var j: usize = high;

    while (i <= j) {
        if (array[i] < pivot) {
            i += 1;
        } else {
            std.mem.swap(@TypeOf(array[0]), &array[i], &array[j]);
            j -= 1;
        }
    }

    std.mem.swap(@TypeOf(array[0]), &array[low], &array[j]);
    return j;
}
