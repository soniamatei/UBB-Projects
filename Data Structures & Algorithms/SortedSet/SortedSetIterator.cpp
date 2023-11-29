#include "SortedSetIterator.h"
#include <exception>

using namespace std;

/// θ(1)
SortedSetIterator::SortedSetIterator(const SortedSet& m) : multime(m) {

    this->current = 0;
}

/// θ(1)
void SortedSetIterator::first() {

    this->current = 0;
}

/// θ(1)
void SortedSetIterator::next() {

    if (this->current == multime.length)
        throw exception();

    this->current++;
}

/// θ(1)
TElem SortedSetIterator::getCurrent() {

    if (this->current == multime.length)
        throw exception();

	return multime.elements[this->current];
}

/// θ(1)
bool SortedSetIterator::valid() const {

	return this->current < multime.length;
}

