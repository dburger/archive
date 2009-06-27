// Javascript Doubly Ended Queue
function Dequeue() {
    this._head = new Dequeue.Node();
    this._tail = new Dequeue.Node();
    this._head._next = this._tail;
    this._tail._prev = this._head;
}

Dequeue.Node = function(data) {
    this._data = data;
    this._prev = null;
    this._next = null;
};

Dequeue.prototype.empty = function() {
    return this._head._next == this._tail;
};

Dequeue.prototype.push = function(data) {
    var node = new Dequeue.Node(data);
    node._prev = this._tail._prev;
    node._prev._next = node;
    node._next = this._tail;
    this._tail._prev = node;
};

Dequeue.prototype.pop = function() {
    if (this.empty()) {
        throw new Error("pop() called on empty dequeue");
    } else {
        var node = this._tail._prev;
        this._tail._prev = node._prev;
        node._prev._next = this._tail;
        return node._data;
    }
};

Dequeue.prototype.unshift = function(data) {
    var node = new Dequeue.Node(data);
    node._next = this._head._next;
    node._next._prev = node;
    node._prev = this._head;
    this._head._next = node;
};

Dequeue.prototype.shift = function() {
    if (this.empty()) {
        throw new Error("shift() called on empty dequeue");
    } else {
        var node = this._head._next;
        this._head._next = node._next;
        node._next._prev = this._head;
        return node._data;
    }
};
