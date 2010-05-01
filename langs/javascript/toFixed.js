/*
  This is a failed attempt to implement a version of toFixed that will work
  properly fixing deficiencies in some implementations.  This doesn't work
  because to toString below will as the comment indicates.
 */
Number.prototype.toFixed = function(fractionDigits) {
  var f = fractionDigits || 0;
  f = parseInt(f);
  if (f < 0 || f > 20) throw new RangeError("RangeError: " + f);
  var x = this;
  if (isNaN(x)) return "NaN";
  var s = "";
  if (x < 0) {
    s = "-";
    x = -x;
  }
  if (x >= Math.pow(10, 21)) {
    var m = x.toString();
  } else {
    var power = Math.pow(10, f);
    var zero = x * power;
    var lo = Math.floor(zero);
    var hi = Math.ceil(zero);
    var loValue = Math.abs(lo / power - x);
    var hiValue = Math.abs(hi / power - x);
    var n = (loValue < hiValue) ? lo : hi;
    // this won't work here if n is too large, it will express itself in
    // scientific notation and then you are stuck
    var m = n.toString();
    if (f !== 0) {
      var k = m.length;
      if (k <= f) {
        var z = "";
        for (var i = 0, l = f + 1 - k; i < l; i++) {
          z += "0";
        }
        m = z + m;
        k = f + 1;
      }
      var a = m.substring(0, k - f);
      var b = m.substring(k - f);
      m = a + "." + b;
    }
  }
  return s + m;
};
