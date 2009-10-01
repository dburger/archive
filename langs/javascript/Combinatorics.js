var Combinatorics = {

    swap: function(a, i, j) {
        var tmp = a[j];
        a[j] = a[i];
        a[i] = tmp;
    },

    arrayEquals: function(a, b) {
        if (a.length !== b.length) return false;
        for (var i = 0, l = a.length; i < l; ++i) {
            if (a[i] !== b[i]) return false;
        }
        return true;
    },

    // nPr index permutation lexicographic order.
    nextPerm: function(a) {
        var j = a.length - 2;
        while (a[j] > a[j + 1]) j--;

        var k = a.length - 1;
        while (a[j] > a[k]) k--;

        this.swap(a, j, k);

        var r = a.length - 1;
        var s = j + 1;
        while (r > s) this.swap(a, r--, s++);

        return a;
    },

    /// callback over nPr index permutation lexicographic order.
    generatePerms: function(length, callback) {
        var currPerm = [];
        var lastPerm = [];
        for (var i = 0; i < length; i++) {
            currPerm.push(i);
            lastPerm.unshift(i);
        }
        while (!this.arrayEquals(currPerm, lastPerm)) {
            callback(currPerm);
            currPerm = this.nextPerm(currPerm);
        }
        callback(currPerm);
    },

    // nPr with replacement index permutation lexicographic order.
    nextPermWithReplacement: function (perm, n) {
        var hiValue = n - 1;
        var digit = perm.length - 1;
        while (digit > -1) {
            if (perm[digit] < hiValue) {
                perm[digit]++;
                return perm;
            } else {
                perm[digit--] = 0;
            }
        }
        throw new Error("Illegal permutation state.");
    },

    // callback over nPr with replacement index permutation lexicographic order.
    generatePermsWithReplacement: function(n, r, callback) {
        var currPerm = [];
        var lastPerm = [];
        for (var i = 0; i < r; i++) {
            currPerm.push(0);
            lastPerm.push(n - 1);
        }
        print("last: " + lastPerm);
        while (!this.arrayEquals(currPerm, lastPerm)) {
            callback(currPerm);
            currPerm = this.nextPermWithReplacement(currPerm, n);
        }
        callback(currPerm);
    },

    // nCr index combination lexicographic order.
    nextRComb: function(a, n) {
        var r = a.length;
        var i = r - 1;
        while (a[i] === n - r + i) i--;

        a[i]++;

        for (var j = i + 1; j < r; j++) a[j] = a[i] + j - i;

        return a;
    },

    generateRCombs: function(n, r, callback) {
        var currComb = [];
        var lastComb = [];
        for (var i = 0; i < r; i++) {
            currComb.push(i);
            lastComb.push(n - r + i);
        }
        while (!this.arrayEquals(currComb, lastComb)) {
            callback(currComb);
            currComb = this.nextRComb(currComb, n);
        }
        callback(currComb);
    }

};

print("generate all permutations of length 3");
Combinatorics.generatePerms(3, function(p) {print(p);});

print("generate all permutations of length 2 with replacement from 3 items");
Combinatorics.generatePermsWithReplacement(3, 2, function(p) {print(p);});

print("generate all combinations of 5 choose 2");
Combinatorics.generateRCombs(5, 2, function(p) {print(p);});
