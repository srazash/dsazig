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

pub fn performQuickSort(comptime T: type, array: T) void {
    quickSort(T, array, 0, array.len - 1);
}

fn quickSort(comptime T: type, array: T, low: usize, high: usize) void {
    if (low >= high) return;

    var pivotIdx: isize = @intCast(quickSortPartition(T, array, low, high));
    pivotIdx -= 1;
    quickSort(T, array, low, @intCast(pivotIdx));
    quickSort(T, array, @intCast(pivotIdx), high);
}

fn quickSortPartition(comptime T: type, array: T, low: usize, high: usize) usize {
    const pivot: usize = array[high];

    var idx: isize = @intCast(low);
    idx -= 1;

    var i: usize = low;
    while (i < high) : (i += 1) {
        if (array[i] <= pivot) {
            idx += 1;
            const tmp = array[i];
            array[i] = array[@intCast(idx)];
            array[@intCast(idx)] = tmp;
        }
    }

    idx += 1;
    array[high] = array[@intCast(idx)];
    array[@intCast(idx)] = @intCast(pivot);

    return @intCast(idx);
}
