var node = function(left, right, val) {
  return {left: left, right: right, val: val};
};

var min = function(a, b) {
  return (a == null && b == null) ? null
      : (a == null) ? b
      : (b == null) ? a
      : Math.min(a, b);
};

var max = function(a, b) {
  return (a == null && b == null) ? null
      : (a == null) ? b
      : (b == null) ? a
      : Math.max(a, b);
};

// returns whether or not a bst is rooted at root
var bst = function(root) {
  var result = mm(root);
  return result.bst;
};

// for a node returns
// {bst: whether or not bst at that node,
//  min: minimum value found in tree,
//  max: maximum value found in tree}
var mm = function(root) {
  if (!root) return {bst: true};
  var mml = mm(root.left);
  var mmr = mm(root.right);
  if (!mml.bst || !mmr.bst) return {bst: false};
  var bst = (mml.max == null && mmr.min == null)
      || (mml.max == null && root.val < mmr.min)
      || (mml.max < root.val && mmr.min == null)
      || (mml.max < root.val && root.val < mmr.min);
  return {bst: bst, min: min(root.val, mml.min),
        max: max(root.val, mmr.max)};
};

/*
       n9
      /
     n8
     /  \
    n1   n16
*/
var n1 = node(null, null, 1);
var n16 = node(null, null, 16);
var n8 = node(n1, n16, 8);
var n9 = node(n8, null, 9);
alert("first is bst, should be false: " + bst(n9));

/*
  n9
    \
     \
     n22
     /
    /
  n7
*/
var n7 = node(null, null, 7);
var n22 = node(n7, null, 22);
var n9 = node(null, n22, 9);
alert("second is bst, should be false: " + bst(n9));

/*
   n1
  /  \
 n0  n2
*/
var n0 = node(null, null, 0);
var n2 = node(null, null, 2);
var n1 = node(n0, n2, 1);
alert("third is bst, should be true: " + bst(n1));
