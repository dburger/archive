// ==UserScript==
// @name          Hawaii State Public Library System LibraryLookup
// @namespace     http://david-burger.blogspot.com/2009/02/greasemonkey-hawaii-state-library.html
// @description   Check availability in Hawaii State Libraries
// @include       http://*.amazon.*
// ==/UserScript==

(function() {
    var libraryUrl = "http://ipac.librarieshawaii.org/ipac20/ipac.jsp?aspect=advanced";
    var idTypes = {
        "ISBN-10:": /^ISBN-10: (.{10})$/,
        "ASIN:": /^ASIN: (.{10})$/
    };
    var trim = function(str) {
        return str.replace(/^\s*|\s*$/g, "");
    }

    var splitTrim = function(str, sep) {
        var parts = str.split(sep);
        for (var i = 0, l = parts.length; i < l; ++i) {
            parts[i] = trim(parts[i]);
        }
        return parts;
    }

    var getMeta = function(name) {
        var metas = document.getElementsByTagName("meta");
        for (var i = 0, l = metas.length; i < l; ++i) {
            var meta = metas[i];
            if (meta.getAttribute("name") === name) return meta;
        }
        return null;
    }

    var getBookInfo = function() {
        var meta = getMeta("description");
        if (meta) {
            var content = meta.getAttribute("content");
            var parts = splitTrim(content, ":");
            var type = parts.slice(-1)[0];
            if (type === "Books") {
                var title = parts[1].replace(/^([\w ]*?) *[^\w ].*$/, "$1");
                var authors = splitTrim(parts.slice(-2, -1)[0], ",");
                var bs = document.getElementsByTagName("b");
                for (var i = 0, l = bs.length; i < l; ++i) {
                    var b = bs[i];
                    for (var k in idTypes) {
                        if (b.innerHTML === k) {
                            var id = b.parentNode.textContent.replace(idTypes[k], "$1");
                            break;
                        }
                    }
                }
                return {title: title, author: authors[0], id: id};
            }
        }
        return null;
    }

    var insertLink = function(url, label) {
        var span = document.createElement("span");
        var text = document.createTextNode(" ");
        span.appendChild(text);
        var a = document.createElement("a");
        a.setAttribute("href", url);
        text = document.createTextNode(label);
        a.appendChild(text);
        span.appendChild(a);
        var titleNode = document.getElementById("btAsinTitle");
        titleNode.parentNode.appendChild(span);
    }

    var doLookup = function(bookInfo) {
        var url = libraryUrl
            + "&term=" + encodeURIComponent(bookInfo.author) + "&index=.AW"
            + "&term=" + encodeURIComponent(bookInfo.title) + "&index=.TW";
        GM_xmlhttpRequest({
            method: "GET",
            url: url,
            onload: function(results) {
                var page = results.responseText;
                var regex = new RegExp(bookInfo.id);
                if (regex.test(page)) {
                    insertLink(url, "HSPLS(Yes)");
                } else {
                    // DOMParser can't parse text/html or might use it here
                    var regex = new RegExp("value=\"Request Item \"", "g");
                    var md = page.match(regex);
                    insertLink(url, "HSPLS(No:" + md.length + ")");
                }
            }
        });
    }

    var bookInfo = getBookInfo();
    if (bookInfo) doLookup(bookInfo);
})();
