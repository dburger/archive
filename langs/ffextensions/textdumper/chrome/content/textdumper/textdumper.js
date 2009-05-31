function textdumper_dumpText() {
  try {
    var prefs = new textdumper_Prefs();

    if (prefs.setting == "save") {
      textdumper_saveFolder(prefs);
    } else if (prefs.setting == "ask") {
      textdumper_saveDialog(prefs);
    } else { // prefs.setting == "command"
      textdumper_shellCommand(prefs);
    }
  } catch (e) {
    alert("An error occurred while saving the selection:\n" + e);
  }
}

function textdumper_saveDialog(prefs) {
  var nsIFilePicker = Components.interfaces.nsIFilePicker;
  var fp = Components.classes["@mozilla.org/filepicker;1"]
    .createInstance(nsIFilePicker);
  fp.init(window, "Save Selected Text", nsIFilePicker.modeSave);

  fp.appendFilters(nsIFilePicker.filterText | nsIFilePicker.filterAll);

  var res = fp.show();

  if (res == nsIFilePicker.returnCancel) return;

  var file = fp.file;

  if (res == nsIFilePicker.returnReplace) {
    file.remove(false);
    // the file picker takes care of whether or not the file is writable, so
    // this test is probably unecessary
    if (file.exists()) {
      alert("Unable to replace:\n" + file.path);
      return;
    }
  }

  textdumper_saveSelection(file, prefs);
}

function textdumper_saveFolder(prefs) {
  var folder = textdumper_getSpecialFolder("Desktop");
  if (prefs.selectedFolderIndex > 0) {
    folder = prefs.folderList[prefs.selectedFolderIndex - 1];
  }
  var filePrefix = prefs.filePrefix;
  var i = 0;
  var fileSuffix = prefs.fileSuffix;

  var tmpFile = folder.clone();
  tmpFile.append(filePrefix + i + fileSuffix);
  while (tmpFile.exists()) {
    tmpFile = folder.clone();
    tmpFile.append(filePrefix + ++i + fileSuffix);
  }

  textdumper_saveSelection(tmpFile, prefs);
}

function textdumper_shellCommand(prefs) {
  var file = Components.classes[
      "@mozilla.org/file/local;1"]
      .createInstance(Components.interfaces.nsILocalFile);
  var process = Components.classes[
      "@mozilla.org/process/util;1"]
      .createInstance(Components.interfaces.nsIProcess);

  file.initWithPath(prefs.shellCommand);
  process.init(file);

  var argv = [ textdumper_getSelection() ];
  var result = {};
  process.run(false, argv, argv.length, result);
}

function textdumper_saveSelection(file, prefs) {
  file.create(Components.interfaces.nsIFile.NORMAL_FILE_TYPE, 0600);

  var outputStream = Components.classes[
      "@mozilla.org/network/file-output-stream;1"]
      .createInstance(Components.interfaces.nsIFileOutputStream);

  // 0x04 = PR_RDWR (read/write)
  // 0x08 = PR_CREATE_FILE
  outputStream.init(file, 0x04 | 0x08, 0600, 0);

  if (prefs.writeUrl) {
    var url = getBrowser().selectedBrowser.currentURI.spec + "\n";
    if (textdumper_writeAll(url, outputStream) < url.length) {
      alert("A problem occurred while saving the file:\n" + file.path);
      outputStream.close();
      return;
    }
  }

  var text = textdumper_getSelection();

  if (textdumper_writeAll(text, outputStream) < text.length) {
    alert("A problem occurred saving the file:\n" + file.path);
  }

  outputStream.close();
}

// stolen from another extension but I can't remember which right now
function textdumper_getSelection() {
  var selectionText = "";
  var trywindow = false;

  var focusedElement = document.commandDispatcher.focusedElement;
  if (focusedElement && null != focusedElement) {
    try {
      selectionText = focusedElement.value.substring(
          focusedElement.selectionStart, focusedElement.selectionEnd);
    } catch (exc) {
      trywindow = true;
    }
  } else {
    trywindow = true;
  }

  if (trywindow) {
    var focusedWindow = document.commandDispatcher.focusedWindow;
    try {
      var winWrapper = new XPCNativeWrapper(focusedWindow, 'document',
        'getSelection()');
      var selection = winWrapper.getSelection();
    } catch (exc) {
      var selection = focusedWindow.getSelection();
    }

    selectionText = selection.toString();
  }

  return selectionText;
}

function textdumper_menuInit() {
  var element = document.getElementById("contentAreaContextMenu");
  if (element) {
    element.setAttribute("onpopupshowing",
        "textdumper_syncCollapseTextDumperMenu('context-dumptext');"
        + element.getAttribute("onpopupshowing"));
  }

  element = document.getElementById("menu_FilePopup");
  if (element) {
    element.setAttribute("onpopupshowing",
        "textdumper_syncEnableTextDumperMenu('file-dumptext');"
        + element.getAttribute("onpopupshowing"));
  }
}

// file menu_FilePopup
function textdumper_syncEnableTextDumperMenu(menuId) {
  var disable = textdumper_getSelection().length == 0;
  document.getElementById(menuId).setAttribute("disabled", disable);
}

// context menu
function textdumper_syncCollapseTextDumperMenu(menuId) {
  var collapse = textdumper_getSelection().length == 0;
  document.getElementById(menuId).collapsed = collapse;
}
