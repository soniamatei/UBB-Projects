#include "SortedSet.h"
#include "SortedSetIterator.h"

/// θ(1)
SortedSet::SortedSet(Relation r) {

    this->elements = new TElem[20];
    this->length = 0;
    this->relation = r;
    this->capacity = 20;
}

/// Best: θ(1)/O(log(n)); Worst: θ(n); Average: θ(n); => Total: O(n)
bool SortedSet::add(TComp elem) {

    if (search(elem))
        return false;

    int position = getPosition(elem);

    if (this->length == this->capacity)
        this->resize();

    this->length++;
    for(int i = this->length - 1; i > position; i--)
        this->elements[i] = this->elements[i - 1];

    this->elements[position] = elem;
	return true;
}

/// Best: θ(1)/O(log(n)); Worst: θ(n); Average: θ(n); => Total: O(n)
bool SortedSet::remove(TComp elem) {

    if (!search(elem))
        return false;

    int position = getPosition(elem);

    for(int i = position; i < this->length - 1; i++)
        this->elements[i] = this->elements[i + 1];

    this->length--;

	return true;
}

/// O(log(n))
bool SortedSet::search(TComp elem) const {

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
int SortedSet::size() const {

    return this->length;
}

/// θ(1)
bool SortedSet::isEmpty() const {

    if (this->length != 0)
        return false;
    return true;
}

/// θ(1)
SortedSetIterator SortedSet::iterator() const {

	return SortedSetIterator(*this);
}

/// θ(1)
SortedSet::~SortedSet() {

    delete[] this->elements;
}

/// Best: θ(1); Worst: θ(log(n)); Average: θ(log(n)); => O(n)
int SortedSet::getPosition(TComp elem) {

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

/// θ(n)
void SortedSet::resize() {

    this->capacity *= 2;

    TComp* secondary = new TComp [this->capacity];
    for(int i = 0; i < this->length; i++)
        secondary[i] = this->elements[i];

    delete[] this->elements;
    this->elements = secondary;
}

