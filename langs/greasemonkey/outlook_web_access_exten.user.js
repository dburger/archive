// ==UserScript==
// @name          Outlook Web Access Extensions
// @namespace     http://www2.hawaii.edu/~dburger
// @description   Extensions to using the bastard child Outlook Web Access
// ==/UserScript==

(
function() {
    var UNREAD_IMG = '/exchweb/img/icon-msg-unread.gif';
    var READ_IMG = '/exchweb/img/icon-msg-read.gif';

    function walkTheDom(node, func) {
        func(node);
        node = node.firstChild;
        while(node) {
          walkTheDom(node, func);
          node = node.nextSibling;
        }
    }

    function getToolbarTable() {
        var tables = document.getElementsByTagName('table');
        for (var i = 0; i < tables.length; i++) {
            var table = tables[i];
            if (table.className === 'trToolbar') return table;
        }
        return null;
    }

    function getFindNamesForm() {
        var forms = document.getElementsByTagName('form');
        return (forms.length == 1 && forms[0].name == 'galfind') ? forms[0] : null;
    }

    function getBaseHref() {
        var bases = document.getElementsByTagName('base');
        return (bases) ? bases[0].href : null;
    }

    function addToolbarButton(toolbarTable, text, func) {
        var row = toolbarTable.tBodies[0].rows[0];
        var newCell = row.insertCell(row.cells.length - 1);
        newCell.setAttribute('valign', 'middle');
        newCell.setAttribute('nowrap', 'nowrap');
        var font = document.createElement('font');
        font.setAttribute('size', '2');
        font.appendChild(document.createTextNode(text));
        var nobr = document.createElement('nobr');
        nobr.appendChild(font);
        var a = document.createElement('a');
        a.href = 'javascript:void(0);';
        a.addEventListener('click', func, true);
        a.appendChild(nobr);
        newCell.appendChild(a);
    }

    function changeSelectState(state) {
        var inputs = document.getElementsByTagName('input');
        for (var i = 0; i < inputs.length; i++) {
            var input = inputs[i];
            var evt = document.createEvent('MouseEvents');
            if (input.type == 'checkbox' && input.checked != state) {
                // this won't fire the events to color the row
                // input.checked = true;
                // so dispatch as an event instead
                evt.initEvent('click', true, false);
                input.dispatchEvent(evt);
            }
        }
    }

    function addSelectAll(toolbarTable) {
        addToolbarButton(toolbarTable, 'Select All', function() {
            changeSelectState(true);
        });
    }

    function addSelectNone(toolbarTable) {
        addToolbarButton(toolbarTable, 'Select None', function () {
            changeSelectState(false);
        });
    }

    function setProps(sXml, loadFunc, errorFunc) {
      GM_xmlhttpRequest({
          method: 'BPROPPATCH',
          url: getBaseHref(),
          headers: {
              'Accept-Language': 'en-us',
              'Content-Type': 'text/xml'
          },
          data: sXml,
          onload: loadFunc,
          onerror: errorFunc
      });
    }

    function changeReadStatus(status) {
        var selInputs = [];
        var inputs = document.getElementsByTagName('input');
        for (var i = 0; i < inputs.length; i++) {
            var input = inputs[i];
            if (input.type == 'checkbox' && input.checked) selInputs.push(input);
        }
        if (selInputs.length > 0) {
            var sFlags = 'd:flags="1"'; // suppress receipt
            var sXml = '<?xml version="1.0"?\><a:propertyupdate xmlns:a="DAV:"><a:set><a:prop><d:read xmlns:d="urn:schemas:httpmail:" ' + sFlags + '>';
            sXml += (status) ? '1':'0';
            sXml += '</d:read></a:prop></a:set><a:target>';
            for (var i = 0; i < selInputs.length; i++) {
                var input = selInputs[i];
                sXml += '<a:href>' + getBaseHref() + input.value + '</a:href>';
            }
            sXml += '</a:target></a:propertyupdate>';
            var loadFunc = function(res) {
                var parser = new DOMParser();
                var doc = parser.parseFromString(res.responseText, 'text/xml');
                var responses = doc.getElementsByTagNameNS('DAV:', 'response');
                var baseHrefLength = getBaseHref().length;
                for (var i = 0; i < responses.length; i++) {
                    var response = responses[i];
                    var href = response.getElementsByTagNameNS('DAV:', 'href')[0];
                    var id = href.firstChild.nodeValue.substring(baseHrefLength - 1);
                    for (var j = 0; j < selInputs.length; j++) {
                        var input = selInputs[j];
                        if (input.type == 'checkbox' && input.value == id) {
                            var tr = input.parentNode.parentNode;
                            walkTheDom(tr, function(node) {
                                if (node.nodeType == 3) {
                                    var text = node.nodeValue;
                                    var parent = node.parentNode;
                                    var grandParent = parent.parentNode;
                                    if (status && parent.tagName == 'B') {
                                        grandParent.removeChild(parent);
                                        var font = document.createElement('font');
                                        font.size = 2;
                                        font.color = 'black';
                                        font.appendChild(document.createTextNode(text));
                                        grandParent.appendChild(font);
                                    } else if (!status && parent.tagName == 'FONT') {
                                        grandParent.removeChild(parent);
                                        var b = document.createElement('b');
                                        b.appendChild(document.createTextNode(text));
                                        grandParent.appendChild(b);
                                    }
                                } else if (node.nodeType == 1 && node.tagName == 'IMG') {
                                    if (status && node.src.match(UNREAD_IMG + '$')) {
                                        node.src = READ_IMG;
                                    } else if (!status && node.src.match(READ_IMG + '$')) {
                                        node.src = UNREAD_IMG;
                                    }
                                }
                            });
                        }
                    }
                }
            };
            var errorFunc = function(res) {
                alert('Change of read status failed, code: ' + res.status);
            };
            setProps(sXml, loadFunc, errorFunc);
        }
    }

    function addMarkRead(row) {
        addToolbarButton(toolbarTable, 'R', function() {
            changeReadStatus(true);
        });
    }

    function addMarkUnread(row) {
        addToolbarButton(toolbarTable, 'U', function() {
            changeReadStatus(false);
        });
    }

    var toolbarTable = getToolbarTable();
    if (toolbarTable) {
        addSelectAll(toolbarTable);
        addSelectNone(toolbarTable);
        addMarkRead(toolbarTable);
        addMarkUnread(toolbarTable);
    }

    // if this is the find names popup form let <enter> work as submit
    var findNamesForm = getFindNamesForm();
    if (findNamesForm) {
        var inputs = document.getElementsByTagName('input');
        for (var i = 0; i < inputs.length; i++) {
            var input = inputs[i];
            if (input.type == 'text') {
                input.addEventListener('keypress', function(evt) {
                    if (evt.keyCode == 13) findNamesForm.submit();
                }, true);
            }
        }
    }
}

)();
