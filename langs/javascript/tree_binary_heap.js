/*
  tree implementation of a binary heap, example usage:

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

  var node = function(value, parent, left, right) {
    var that = {};
    that.value = value;
    that.parent = parent;
    that.left = left;
    that.right = right;
    return that;
  };

  var that = {};
  var root = null;
  var last = null;
  var size = 0;

  var full = function() {
    var log = Math.log(size) / Math.log(2);
    return log === Math.floor(log);
  };

  var bubbleUp = function(node) {
    if (node === root) {
      return;
    }
    if (comp(node.value, node.parent.value)) {
      var temp = node.parent.value;
      node.parent.value = node.value;
      node.value = temp;
      node = node.parent;
      bubbleUp(node);
    }
  };

  var bubbleDown = function(node) {
    if (!node) {
      return;
    }
    var largest = node;
    if (node.left && comp(node.left.value, largest.value)) {
      largest = node.left;
    }
    if (node.right && comp(node.right.value, largest.value)) {
      largest = node.right;
    }
    if (largest !== node) {
      var temp = node.value;
      node.value = largest.value;
      largest.value = temp;
      bubbleDown(largest);
    }
  };

  that.push = function(value) {
    if (!root) {
      root = last = node(value, null, null, null);
    } else if (root === last) {
      root.left = node(value, root, null, null);
      last = root.left;
    } else if (last.parent.left === last) {
        last.parent.right = node(value, last.parent, null, null);
        last = last.parent.right;
    } else {
      var hops = 0;
      var temp = last;
      while (temp.parent && temp.parent.right === temp) {
        temp = temp.parent;
        hops++;
      }
      if (temp !== root) {
        temp = temp.parent.right;
        hops--;
      }
      while (hops > 0) {
        temp = temp.left;
        hops--;
      }
      temp.left = node(value, temp, null, null);
      last = temp.left;
    }
    size++;
    bubbleUp(last);
  };

  that.pop = function() {
    if (size === 0) {
      throw new Error("binary heap empty");
    }
    var value = root.value;
    root.value = last.value;
    if (root === last) {
      root = last = null;
      size--;
    } else if (last.parent.right === last) {
      last.parent.right = null;
      last = last.parent.left;
    } else {
      var hops = 0;
      var temp = last;
      while (temp.parent && temp.parent.left === temp) {
        temp = temp.parent;
        hops++;
      }
      if (temp !== root) {
        temp = temp.parent.left;
      } else {
        hops--;
      }
      while (hops > 0) {
        temp = temp.right;
        hops--;
      }
      last.parent.left = null;
      last = temp;
    }
    size--;
    bubbleDown(root);
    return value;
  };

  that.t = function(node) {
    if (node == null) {
      return;
    }
    this.t(node.left);
    this.t(node.right);
  }

  that.tree = function() {
    print("xxx");
    this.t(root);
    print("yyy");
  }

  that.size = function() {
    return size;
  };

  return that;
};
