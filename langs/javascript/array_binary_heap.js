/*
  array implementation of a binary heap, example usage:

  // can optionally provide a comparison function, a function for a max
  // heap is the default if no comparison function is provided
  var bh = binaryHeap();
  bh.push(5);
  bh.push(34);
  bh.push(16);
  var max = bh.pop(); // 34
  print("number in heap: " + bh.size()) // 2
 */
var binaryHeap = function(comp) {

  // default to max heap if comparator not provided
  comp = comp || function(a, b) {
    return a > b;
  };

  var arr = [];

  var swap = function(a, b) {
    var temp = arr[a];
    arr[a] = arr[b];
    arr[b] = temp;
  };

  var bubbleDown = function(pos) {
    var left = 2 * pos + 1;
    var right = left + 1;
    var largest = pos;
    if (left < arr.length && comp(arr[left], arr[largest])) {
      largest = left;
    }
    if (right < arr.length && comp(arr[right], arr[largest])) {
      largest = right;
    }
    if (largest != pos) {
      swap(largest, pos);
      bubbleDown(largest);
    }
  };

  var bubbleUp = function(pos) {
    if (pos <= 0) {
      return;
    }
    var parent = Math.floor((pos - 1) / 2);
    if (comp(arr[pos], arr[parent])) {
      swap(pos, parent);
      bubbleUp(parent);
    }
  };

  var that = {};

  that.pop = function() {
    if (arr.length === 0) {
      throw new Error("pop() called on emtpy binary heap");
    }
    var value = arr[0];
    var last = arr.length - 1;
    arr[0] = arr[last];
    arr.length = last;
    if (last > 0) {
      bubbleDown(0);
    }
    return value;
  };

  that.push = function(value) {
    arr.push(value);
    bubbleUp(arr.length - 1);
  };

  that.size = function() {
    return arr.length;
  };

  return that;
};
