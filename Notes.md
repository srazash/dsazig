# Data Structures & Algorithms in Zig

## Basics

### Big-O Time Complexity

Big-O time complexity is a generalised way of assessing how an algorithm functions in terms of time and memory required and catagorising it based on this.

```zig
fn sumCharCodes(n: []const u8) usize {
    var sum: usize = 0;
    for (n) |char| sum += char;
    return sum;
}
```

Here we have a simple function that takes in a string (`[]const u8` in Zig) called `n`, we loop over and sum the Unicode values of each character, and return the sum of the character codes.

The easiest way to assess what the Big-O complexity is, is to look for loops.

Here we have a single loop which goes through each character of the input string, so our Big-O complexity is entirely dependant on the length of the input string. The longer the string the more loops have to run to complete the task.

Meaning this function is **O(N), or linear** - the longer the string the longer the time and greater the memory needed to loop over it.

So here we can generally say that a string of 100 characters would take about 10x the time and memory of a string of 10 characters, because the complexity scales in a linear fashion.

It is worth noting that the steps of initialising `var sum` and returning with `return sum` are disregarded as these are **constants**, they never change and always occur no matter the size of the input.

```zig
fn sumCharCodesE(n: []const u8) usize {
    var sum: usize = 0;
    for (n) |char| {
        if (char == 69) return sum; // return if 'E' is encountered
        sum += char;
    }
    return sum;
}
```

In the above code example we return early if the current character is 'E'. Despit this the function still conforms to O(N) time complexity. This is because when we're assessing the Big-O time complexity we conform to the **worst case scenario**, here the worst case scenario is that we never encounter 'E'.

This gives us three basic rules to follow when calculating Big-O time complexity:

1. Growth is with respect to our input.
2. Constants are disregarded.
3. We alway measure based on the worst case scenario.

Some common Big-O complexity:

- O(1) execution time is always the same, no matter the size of the input.
- O(logN) execution time is increase donly marginally by the input.
- O(N) execution time grows linearly with the input.
- O(NlogN) execution time begins to grow exponentially.
- O(N^2) execution time grows rapidly in an exponential manner.
- O(2^N) grows so quickly it is typically not possible to run on traditional hardware.
- O(N!) grows so quickly it is typically not possible to run on traditional hardware.

```zig
fn sumCharCodesS(n: []const u8) usize {
    var sum: usize = 0;
    for (n) |_| {
        for (n) |char| {
            sum += char;
        }
    }
    return sum;
}
```

He we have an example of O(N^2), here we see that we have a for loop within a for loop. So for every individual loop of the outer loop, the inner loop must run until it is complete.

We could think of this like drawing a square, drawing out all the columns of an individual row before starting to draw the next row.

Each row confirms to O(N) but as with have draw every column within that row we square our time complexity, and therefore it is O(N^2).

Likewise, if we were to introduce a third dimention and work with a matrix our complexity would be O(N^3).

Quicksort conforms to O(NlogN).

Binary tree search conforms to O(logN).

Constant Time Operations:

When working with an array, accessing (reading/writing/deleting) any given element is an O(1) constant time operation because the length of the array is known and cannot change, so accessing any element will take the same amount of time, if we needed to iterate through every element that would be an O(N) where N is affected by the length of an array, but the increase in time would grow linearly.

## Search

### Linear Search

A simple linear search will check all the elements of an array and return true if it matches an input to search for, if it cannot find a match based on the input we return false, in the following example our array is the `haystack` and the input we are searching for is the `needle`:

```zig
pub fn linearSearch(haystack: []isize, needle: isize) bool {
    for (haystack) |e| if (e == needle) return true;
    return false;
}
```

This example is O(N) complexity, as the complexity increases with the size of the input. A larger array to search through would linearly increase the time and memory complexity of the search.

### Binary Search

Binary search needs the input to be ordered before searching begins. This is because, unlike a linear search, we do not check every element of the input, but rather we disregard half of the input based whether the value we're searching for is less than or greater than the value at the middle of the input each time it is halved.

This means our complexity is O(logN), comparing this to O(N) of a linear search, if we had 4096 values, a binary search would complete in a maximum of 12 loops, a linear search would complete in a maximum of 4096 loops.

NOTE: If our input is halved at every loop we're likely dealing with O(logN) or O(NlogN)!

Here is the pseudocode for a recursive version of the binary search:

```pseudocode
binarySearch(haystack, needle)
  low = 0
  high = haystack.length

  while (low < high)
    middle = low + (high - low) / 2
    value = haystack[middle]

    if value == needle
      return true
    else if value > needle
      high = middle
    else
      low = middle + 1

  return false
```

### The Two Crystal Ball Problem

## Sort

## Arrays

## Recursion

## Quick Sort

## Doubly Linked List

## Trees

## Tree Search

## Heap

## Graphs

## Maps & LRU
