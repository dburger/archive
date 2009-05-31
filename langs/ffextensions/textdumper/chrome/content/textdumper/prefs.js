function textdumper_Prefs () {
  var prefService = Components.classes["@mozilla.org/preferences-service;1"]
      .getService(Components.interfaces.nsIPrefService).getBranch(
      "extensions.textdumper");
  this.prefService = prefService;

  var setting = "ask";
  if (prefService.prefHasUserValue("setting")) {
    setting = prefService.getCharPref("setting");
  }
  this.setting = setting;

  var folderList = new Array(0);
  for (var i = 0; prefService.prefHasUserValue("folder.list." + i); i++) {
    folderList[i] = prefService.getComplexValue("folder.list." + i,
        Components.interfaces.nsILocalFile);
  }
  this.folderList = folderList;

  var selectedFolderIndex = 0;
  if (prefService.prefHasUserValue("folder.selected.index")) {
    selectedFolderIndex =
        prefService.getIntPref("folder.selected.index");
  }
  this.selectedFolderIndex = selectedFolderIndex;

  var filePrefix = "textdumper";
  if (prefService.prefHasUserValue("file.prefix")) {
    filePrefix = prefService.getCharPref("file.prefix");
  }
  this.filePrefix = filePrefix

  var fileSuffix = ".txt";
  if (prefService.prefHasUserValue("file.suffix")) {
    fileSuffix = prefService.getCharPref("file.suffix");
  }
  this.fileSuffix = fileSuffix;

  var shellCommand = "";
  if (prefService.prefHasUserValue("shell.command")) {
    shellCommand = prefService.getCharPref("shell.command");
  }
  this.shellCommand = shellCommand;

  var writeUrl = false;
  if (prefService.prefHasUserValue("write.url")) {
    writeUrl = prefService.getBoolPref("write.url");
  }
  this.writeUrl = writeUrl

  this.save = function() {
    prefService.setCharPref("setting", this.setting);
    prefService.setCharPref("file.prefix", this.filePrefix);
    prefService.setCharPref("file.suffix", this.fileSuffix);
    prefService.setIntPref("folder.selected.index", this.selectedFolderIndex);
    prefService.setCharPref("shell.command", this.shellCommand);
    prefService.setBoolPref("write.url", this.writeUrl);

    for (var i = 0; i < this.folderList.length ; i++) {
      prefService.setComplexValue("folder.list." + i,
        Components.interfaces.nsILocalFile, this.folderList[i]);
    }
  }

}
