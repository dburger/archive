function textdumper_doOk() {
  try {
    textdumper_savePreferences();
  } catch (e) {
    alert("A problem occurred while saving your options:\n" + e);
  }
  return true;
}

function textdumper_doCancel() {
  return true;
}

function textdumper_loadPreferences() {
  var prefs = new textdumper_Prefs();

  textdumper_disableSave(prefs.setting);

  document.getElementById("shell-command").value = prefs.shellCommand;
  document.getElementById("write-url").checked = prefs.writeUrl;
  document.getElementById("file-prefix").value = prefs.filePrefix;
  document.getElementById("file-suffix").value = prefs.fileSuffix;

  var folderPopup = document.getElementById("folder-popup");
  var menuItem = document.createElement("menuitem");

  // add Desktop folder option
  menuItem.setAttribute("label", "Desktop");
  var desktopFolder = textdumper_getSpecialFolder("Desktop");
  menuItem.setAttribute("value", desktopFolder.path);
  menuItem.nsILocalFile = desktopFolder;
  folderPopup.appendChild(menuItem);

  // add My Documents folder option
  // not yet

  // add custom folder options
  for (var i = 0; i < prefs.folderList.length; i++) {
    menuItem = document.createElement("menuitem");
    menuItem.setAttribute("label", prefs.folderList[i].path);
    menuItem.setAttribute("value", prefs.folderList[i].path);
    menuItem.nsILocalFile = prefs.folderList[i];
    folderPopup.appendChild(menuItem);
  }

  // add Other... folder option
  menuItem = document.createElement("menuitem");
  menuItem.setAttribute("label", "Other...");
  menuItem.setAttribute("value", "Other...");
  folderPopup.appendChild(menuItem);

  document.getElementById("folder-list").selectedIndex =
      prefs.selectedFolderIndex;
}

function textdumper_savePreferences() {
  var prefs = new textdumper_Prefs();

  prefs.setting = "command";
  if (document.getElementById("save").selected) {
    prefs.setting = "save";
  } else if (document.getElementById("ask").selected) {
    prefs.setting = "ask";
  }

  prefs.filePrefix = document.getElementById("file-prefix").value;
  prefs.fileSuffix = document.getElementById("file-suffix").value;
  prefs.selectedFolderIndex =
      document.getElementById("folder-list").selectedIndex;
  prefs.shellCommand = document.getElementById("shell-command").value;
  prefs.writeUrl = document.getElementById("write-url").checked;

  // TODO, should limit the number of custom folders
  var menuItems = document.getElementById("folder-popup").childNodes;
  // skipping Desktop and Other...
  var folderList = new Array(menuItems.length - 2);

  // seems like a bug here...if the menupopup has never been opened some of the
  // calls to menuItems.item(i).value will return "undefined" so don't set
  // prefs.folderList if this happens...if never opened, don't need to change
  var foundUndefined = false;
  for (var i = 1; i < menuItems.length - 1; i++) {
    if (typeof(menuItems.item(i).value) == "undefined") {
      foundUndefined = true;
      break;
    }
    folderList[i - 1] = menuItems.item(i).nsILocalFile;
  }

  if (!foundUndefined) prefs.folderList = folderList;

  prefs.save();
}

function textdumper_disableSave(setting) {
  if (setting == "ask") {
    document.getElementById("action").selectedIndex = 0;
    document.getElementById("folder-list").disabled = true;
    document.getElementById("file-prefix").disabled = true;
    document.getElementById("file-suffix").disabled = true;
    document.getElementById("shell-command").disabled = true;
  } else if (setting == "save") {
    document.getElementById("action").selectedIndex = 1;
    document.getElementById("folder-list").disabled = false;
    document.getElementById("file-prefix").disabled = false;
    document.getElementById("file-suffix").disabled = false;
    document.getElementById("shell-command").disabled = true;
  } else { // setting == "command"
    document.getElementById("action").selectedIndex = 2;
    document.getElementById("folder-list").disabled = true;
    document.getElementById("file-prefix").disabled = true;
    document.getElementById("file-suffix").disabled = true;
    document.getElementById("shell-command").disabled = false;
  }
}

var textdumper_oldSelection;

function textdumper_folderChange() {
  var folderList = document.getElementById("folder-list");
  var folderPopup = document.getElementById("folder-popup");

  if (folderList.selectedIndex == folderPopup.childNodes.length - 1) {
    var nsIFilePicker = Components.interfaces.nsIFilePicker;
    var fp = Components.classes["@mozilla.org/filepicker;1"]
      .createInstance(nsIFilePicker);
    fp.init(window, "Save Selected Text", nsIFilePicker.modeGetFolder);

    var res = fp.show();
    if (res == nsIFilePicker.returnOK) {
      // make sure we don't add a duplicate
      for (var i = 0; i < folderPopup.childNodes.length - 1; i++) {
        if (folderPopup.childNodes.item(i).value == fp.file.path) {
          folderList.selectedIndex = i;
          return;
        }
      }

      var menuItem = document.createElement("menuitem");
      menuItem.setAttribute("label", fp.file.path);
      menuItem.setAttribute("value", fp.file.path);
      menuItem.nsILocalFile = fp.file;
      folderPopup.insertBefore(menuItem, folderPopup.lastChild);
      folderList.selectedIndex = folderPopup.childNodes.length - 2;
    } else if (res == nsIFilePicker.returnCancel) {
      folderList.selectedIndex = textdumper_oldSelection;
    }
  }
}
