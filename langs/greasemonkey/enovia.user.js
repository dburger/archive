// ==UserScript==
// @name          enovia
// @namespace     http://www2.hawaii.edu/~dburger
// @description   help in working with enovia tax lookups
// @include       http://www.mturk.com*
// ==/UserScript==

(

function() {

  var taxUrl = /.*(http.*FT_.*)/

  var enovia = {

    makeLink: function() {
      var overviewTextParas = document.evaluate("//p[@class='overview text']",
          document, null, XPathResult.UNORDERED_NODE_SNAPSHOT_TYPE, null);
      if (overviewTextParas.snapshotLength > 1) {
        // it is the first one
        var overviewPara = overviewTextParas.snapshotItem(1);
        var textContent = overviewPara.textContent;
        if (taxUrl.test(textContent)) {
          var link = textContent.match(taxUrl)[1]
          var newPara = document.createElement('p');
          newPara.innerHTML = "<p><a href='" + link + "'>tax doc</a></p>"
          overviewPara.parentNode.replaceChild(newPara, overviewPara);
        }
      }
    }

  }

  enovia.makeLink();

}

)();
