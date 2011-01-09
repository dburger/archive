var StringBuffer = function(value) {
  this.parts = (value) ? [value.toString()] : [];
};

StringBuffer.prototype.append = function(value) {
  if (value) this.parts.push(value.toString());
};

StringBuffer.prototype.toString = function() {
  return this.parts.join("");
};
