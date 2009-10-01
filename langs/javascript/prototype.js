/* prototype custom events example */
var someNode = $("foo");
someNode.fire("widget:frobbed", memo);
el.observe("widget:frobbed", function(evt) { });
// bubbles too, so
$(document).observe("widget:frobbed", function(evt) { .... }
