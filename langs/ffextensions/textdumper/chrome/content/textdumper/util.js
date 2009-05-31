function textdumper_writeAll(text, outputStream) {
  var length = text.length;
  var written = 0;
  while (written < length) {
    var cnt = outputStream.write(text.substring(written), length - written);
    if (cnt == -1) return written;
    written += cnt;
  }
}

// derived from getDownloadsFolder in pref-downloads.js...wasn't sure if safe
// to import and use directly
function textdumper_getSpecialFolder(name) {

  var fileLocator = Components.classes["@mozilla.org/file/directory_service;1"]
      .getService(Components.interfaces.nsIProperties);

  var dir = fileLocator.get("Home", Components.interfaces.nsILocalFile);
  dir.append(name);

  return dir;
}
