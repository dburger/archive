// DOM walking method
function walkTheDom(node, func) {
  func(node);
  node = node.firstChild;
  while (node) {
    walkTheDom(node, func);
    node = node.nextSibling;
  }
}

// this first example would be better done by iterating over
// elem.getElementsByTagName("*")
function getElementsByClassName(parent, className) {
  var results = [];
  walkTheDom(parent, function(node) {
    var classNames = (node.className + "").split(" ");
    for (var i = 0; i < classNames.length; i++) {
      if (classNames[i] == className) {
        results.push(node);
        break;
      }
    }
  });
  return results;
}

// this example gets text nodes so elem.getElementsByTagName("*")
// won't pick them up
function getTextNodes(parent) {
  var results = [];
  walkTheDom(parent, function(node) {
    if (node.nodeType === 3) results.push(node);
  });
  return results;
}
