#include "SortedSetFixed.h"
#include "SortedSetIterator.h"

/// θ(1)
SortedSetFixed::SortedSetFixed(Relation r, int capacity) {

    this->elements = new TElem[capacity];
    this->length = 0;
    this->relation = r;
    this->capacity = capacity;
}

/// Best: θ(1)/O(log(n)); Worst: θ(n); Average: θ(n); => Total: O(n)
bool SortedSetFixed::add(TComp elem) {

    if (search(elem))
        return false;

    int position = getPosition(elem);

    if (this->length == this->capacity)
        return false;

    this->length++;
    for(int i = this->length - 1; i > position; i--)
        this->elements[i] = this->elements[i - 1];

    this->elements[position] = elem;
    return true;
}

/// Best: θ(1)/O(log(n)); Worst: θ(n); Average: θ(n); => Total: O(n)
bool SortedSetFixed::remove(TComp elem) {

    if (!search(elem))
        return false;

    int position = getPosition(elem);

    for(int i = position; i < this->length - 1; i++)
        this->elements[i] = this->elements[i + 1];

    this->length--;

    return true;
}

/// O(log(n))
bool SortedSetFixed::search(TComp elem) const {

    int position = -1;
    for (int left = 0, right = this->length - 1, middle; left <= right;) {

        middle = (left + right) / 2;

        if (elem == this->elements[middle]) {
            position = middle;
            break;
        } else if (this->relation(elem, this->elements[middle]))
            right = middle - 1;
        else {
            left = middle + 1;
        }
    }

    if (position == -1)
        return false;
    return true;

}

/// θ(1)
int SortedSetFixed::size() const {

    return this->length;
}

/// θ(1)
bool SortedSetFixed::isEmpty() const {

    if (this->length != 0)
        return false;
    return true;
}

///// θ(1)
//SortedSetIterator SortedSetFixed::iterator() const {
//
//    return SortedSetIterator(*this);
//}

/// θ(1)
SortedSetFixed::~SortedSetFixed() {

    delete[] this->elements;
}

/// Best: θ(1); Worst: θ(log(n)); Average: θ(log(n)); => O(n)
int SortedSetFixed::getPosition(TComp elem) {

    int position = -1, left, right, middle;
    for (left = 0, right = this->length - 1; left <= right;) {

        middle = (left + right) / 2;

        if (elem == this->elements[middle]) {
            position = middle;
            break;
        } else if (this->relation(elem, this->elements[middle]))
            right = middle - 1;
        else {
            left = middle + 1;
        }
    }

    if (position == -1)
        position = left;

    return position;
}

/// θ(1)
bool SortedSetFixed::isFull() {

    if (this->length == this->capacity)
        return true;
    return false;
}
