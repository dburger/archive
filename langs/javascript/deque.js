// Javascript Doubly Ended Queue
var deque = function() {
    var node = function(data, prev, next) {
        var that = {};
        that.data = data;
        that.prev = prev;
        that.next = next;
        return that;
    }

    var that = {};
    var head = node(null);
    var tail = node(null, head);
    head.next = tail;
    that.empty = function() {return head.next === tail;};
    that.push = function(data) {
        var n = node(data, tail.prev, tail)
        tail.prev.next = n;
        tail.prev = n;
    };
    that.pop = function() {
        if (that.empty()) {
            throw new Error("pop() called on empty deque");
        } else {
            var n = tail.prev;
            tail.prev = n.prev;
            tail.prev.next = tail;
            return n.data;
        }
    };
    that.unshift = function(data) {
        var n = node(data, head, head.next);
        head.next.prev = n;
        head.next = n;
    };
    that.shift = function() {
        if (that.empty()) {
            throw new Error("shift() called on empty deque");
        } else {
            var n = head.next;
            head.next = n.next;
            head.next.prev = head;
            return n.data;
        }
    };
    return that;
};
