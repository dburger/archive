// returns true if needed to load, false if already loaded
var require = function(src) {
  var scripts = document.getElementsByTagName("script");
  for (var i = 0, l = scripts.length; i < l; i++) {
    if (scripts[i].src === src) return false;
  }

  var script = document.createElement("script");
  script.setAttribute("src", src);
  var head = document.getElementsByTagName("head")[0];
  head.appendChild(script);
  return true;
}
