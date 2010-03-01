// collection of javascript algorithms...mainly mini fun code kata

// function to reverse linked list, given we have node objects with next field
// and we have a reference to the head node
function reverse(node, last) {
  // say last node should have next === null, not undefined
  last = last || null;
  var next = node.next;
  node.next = last;
  return (next) ? reverse(next, node) : node;
}

// in place randomization of an array
function shuffle(array) {
  for (var i = array.length - 1; i > 0; i--) {
    var j = Math.floor(Math.random() * (i + 1));
    var t = array[j];
    array[j] = array[i];
    array[i] = t;
  }
}
