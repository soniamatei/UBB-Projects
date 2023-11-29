#include "ListIterator.h"
#include "SortedIteratedList.h"
#include <iostream>
using namespace std;
#include <exception>

SortedIteratedList::SortedIteratedList(Relation r) {

    relation = r;
    head = -1;
    nodes = new DLLNode[capacity];

    for(int i = 0; i < capacity - 1; i++) {
        nodes[i].prev = i - 1;
        nodes[i].next = i + 1;
    }
    nodes[capacity - 1].prev = capacity - 2;
    nodes[capacity - 1].next = -1;

    length = 0;
    first_free = 0;
}

int SortedIteratedList::size() const {
    return length;
}

bool SortedIteratedList::isEmpty() const {
	return length == 0;
}

ListIterator SortedIteratedList::first() const {
    ListIterator it{*this};
	return it;
}

TComp SortedIteratedList::getElement(ListIterator poz) {
	return poz.getCurrent();
}

TComp SortedIteratedList::remove(ListIterator& poz) {

    if (!poz.valid())
        throw exception();

    int current = head, prev = -1;
    while (current != poz.current) {
        prev = current;
        current = nodes[current].next;
    }

    // if head removed
    if (poz.current == head) {
        head = nodes[head].next;
        nodes[head].prev = -1;
    }
    // if tail removed
    else if (nodes[poz.current].next == -1) {
        nodes[prev].next = -1;
    }
    // if middle removed
    else {
        nodes[prev].next = nodes[poz.current].next;
//        nodes[nodes[poz.current].next].prev = nodes[poz.current].prev;
    }

    nodes[poz.current].next = first_free;
//    nodes[poz.current].prev = -1;
    first_free = poz.current;
    length--;

    current = poz.current;
    poz.next();

    return nodes[current].info;
}

ListIterator SortedIteratedList::search(TComp e) const{

    ListIterator it{*this};
    it.first();
    while (it.valid() && it.getCurrent() != e)
        it.next();

	return it;
}

void SortedIteratedList::add(TComp e) {

    int position = head, prev = -1;
    while (position != -1 && relation(nodes[position].info, e)) {
        prev = position;
        position = nodes[position].next;
    }

    if (length == capacity)
        resize();

    // if relation broke the while
    if(position != -1) {

        // if insert on the first position
        if (position == head)
            head = first_free;

        int current = first_free;
        first_free  = nodes[first_free].next;

        nodes[current].next = position;
        nodes[current].prev = nodes[position].prev;

        // if there's a previous node
        if (prev != -1)
            nodes[prev].next = current;
        nodes[position].prev = current;

        nodes[current].info = e;
    }
    // if it got to the end of array
    else{

        // if first element introduced
        if(head == -1)
            head = first_free;

        int current = first_free;
        first_free = nodes[first_free].next;

        nodes[current].next = -1;

        // if element introduced at the end
        if (prev != -1)
            nodes[prev].next = current;

        nodes[current].info = e;
    }

    length++;
}

void SortedIteratedList::resize() {

    capacity *= 2;

    DLLNode* secondary = new DLLNode [capacity];
    for(int i = 0; i < length; i++)
        secondary[i] = nodes[i];

    delete[] nodes;
    nodes = secondary;

    for(int i = length; i < capacity - 1; i++) {
        nodes[i].prev = i - 1;
        nodes[i].next = i + 1;
    }
    nodes[capacity - 1].prev = capacity - 2;
    nodes[capacity - 1].next = -1;

    first_free = length;
}

SortedIteratedList::~SortedIteratedList()=default;
