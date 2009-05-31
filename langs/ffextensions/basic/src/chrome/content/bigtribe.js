window.addEventListener("load", function() {BigTribe.init();}, false);

var BigTribe = {

  init: function() {
    var appcontent = document.getElementById("appcontent");
    if (appcontent) {
      appcontent.addEventListener("load",
          function(evt) {BigTribe.onPageLoad(evt);}, true);
    }
  },

  map: function() {
    var sel = this.getSelection();
    var query = "";
    if (sel != "") {
      query = "?" + encodeURIComponent(sel);
    }

    content.location.href = "http://www.bigtribe.com/" + query;
  },

  onPageLoad: function(evt) {
    var doc = evt.originalTarget;
    if (doc.nodeName == "#document") {
      if (doc.location.href.search("http://www.bigtribe.com") == 0) {
        alert("welcome home");
      }
    }
  },

  getSelection: function() {
    var focusedWindow = document.commandDispatcher.focusedWindow;
    var winWrapper = new XPCNativeWrapper(focusedWindow, "document",
        "getSelection()");
    return winWrapper.getSelection().toString();
  }

}
