pragma solidity >=0.4.22 <0.6.0;

library UintList {
    struct data {
        uint first;
        uint last;
        uint count;
        Item[] items;
    }
    uint constant None = uint(0);
    struct Item {
        uint prev;
        uint next;
        uint data;
    }

    /// Appends `_data` to the end of the list `self`.
    function append(data storage self, uint _data) public {
        uint index = uint(self.items.push(Item({prev: self.last, next: None, data: _data})));
        if (self.last == None) {
            if (self.first != None || self.count != 0) revert();
            self.first = self.last = index;
            self.count = 1;
        } else {
            self.items[self.last - 1].next = index;
            self.last = index;
            self.count ++;
        }
    }

    /// Removes the element identified by the iterator
    /// `_index` from the list `self`.
    function remove(data storage self, uint _index) public {
        Item storage item = self.items[_index - 1];
        if (item.prev == None)
            self.first = item.next;
        if (item.next == None)
            self.last = item.prev;
        if (item.prev != None)
            self.items[item.prev - 1].next = item.next;
        if (item.next != None)
            self.items[item.next - 1].prev = item.prev;
        delete self.items[_index - 1];
        self.count--;
    }

    /// @return an iterator pointing to the first element whose data
    /// is `_value` or an invalid iterator otherwise.
    function find(data storage self, uint _value) public view returns (uint) {
        uint it = iterate_start(self);
        while (iterate_valid(self, it)) {
            if (iterate_get(self, it) == _value)
                return it;
            it = iterate_next(self, it);
        }
        return it;
    }

    // Iterator interface
    function iterate_start(data storage self) public view returns (uint) { return self.first; }
    function iterate_valid(data storage self, uint _index) public view returns (bool) { return _index - 1 < self.items.length; }
    function iterate_prev(data storage self, uint _index) public view returns (uint) { return self.items[_index - 1].prev; }
    function iterate_next(data storage self, uint _index) public view returns (uint) { return self.items[_index - 1].next; }
    function iterate_get(data storage self, uint _index) public view returns (uint) { return self.items[_index - 1].data; }
}
