// Javascript Doubly Ended Queue
function Deque() {
    this._head = new Deque.Node();
    this._tail = new Deque.Node();
    this._head._next = this._tail;
    this._tail._prev = this._head;
}

Deque.Node = function(data) {
    this._data = data;
    this._prev = null;
    this._next = null;
};

Deque.prototype.empty = function() {
    return this._head._next === this._tail;
};

Deque.prototype.push = function(data) {
    var node = new Deque.Node(data);
    node._prev = this._tail._prev;
    node._prev._next = node;
    node._next = this._tail;
    this._tail._prev = node;
};

Deque.prototype.pop = function() {
    if (this.empty()) {
        throw new Error("pop() called on empty deque");
    } else {
        var node = this._tail._prev;
        this._tail._prev = node._prev;
        node._prev._next = this._tail;
        return node._data;
    }
};

Deque.prototype.unshift = function(data) {
    var node = new Deque.Node(data);
    node._next = this._head._next;
    node._next._prev = node;
    node._prev = this._head;
    this._head._next = node;
};

Deque.prototype.shift = function() {
    if (this.empty()) {
        throw new Error("shift() called on empty deque");
    } else {
        var node = this._head._next;
        this._head._next = node._next;
        node._next._prev = this._head;
        return node._data;
    }
};
