#include "SortedBagIterator.h"
#include "SortedBag.h"
#include <exception>
#include <algorithm>

using namespace std;

SortedBagIterator::SortedBagIterator(const SortedBag& b) : bag(b) {

    array = new int[bag.length];
    for(int i = 0, k = 0; k < bag.capacity; k++){

        SortedBag::node* current_bag;
        current_bag = bag.array[k];

        while(current_bag != nullptr) {

            int frequency = current_bag->frequency;
            while (frequency) {

                array[i] = current_bag->value;
                i++;
                frequency--;
            }
            current_bag = current_bag->next_in_set;
        }
    }

    sort(&array[0], &array[bag.length], bag.relation);
    current = 0;
}

TComp SortedBagIterator::getCurrent() {

    if(current == bag.length)
        throw exception();

    return array[current];
}

bool SortedBagIterator::valid() {

    return current < bag.length;
}

void SortedBagIterator::next() {

    if(current == bag.length)
        throw exception();
    current++;
}

void SortedBagIterator::first() {

    current = 0;
}

