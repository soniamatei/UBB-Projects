#include "SortedBag.h"
#include "SortedBagIterator.h"
#include <cmath>
#include <iostream>

SortedBag::SortedBag(Relation r) {

    length = 0;
    capacity = 51;
    array = new node*[capacity];
    for(int i = 0; i < capacity; i++)
        array[i] = nullptr;
    relation = r;
}


int SortedBag::hash(TComp e) const {

    return abs(e) % capacity;
}


bool SortedBag::verify_load_factor() const {

    return (double)length/capacity < 0.6;
}


void SortedBag::rehash() {

    node** secondary = array;
    capacity *= 2;
    length = 0;

    array = new node*[capacity];
    for(int i = 0; i < capacity; i++)
        array[i] = nullptr;

    for(int i = 0; i < capacity/2; i++){
        node *current_secondary = secondary[i];
        while(current_secondary != nullptr){

            int frequency = current_secondary->frequency;
            while (frequency) {

                add(current_secondary->value);
                frequency--;
            }
            current_secondary = current_secondary->next_in_set;
        }
    }

    delete[] secondary;
}


void SortedBag::add(TComp e) {

    if(!verify_load_factor())
        rehash();

    int index = hash(e);

    node *current = array[index], *previous = nullptr;
    while(current != nullptr && current->value != e) {
        previous = current;
        current = current->next_in_set;
    }

    if (current == nullptr) {
        current = new node;
        current->value = e;
        current->next_in_set = nullptr;
        current->frequency = 1;

        if(previous != nullptr)
            previous->next_in_set = current;

        if(array[index] == nullptr)
            array[index] = current;
    }
    else current->frequency++;

    length++;
}

// B: T(1)  W:(n + 1)
bool SortedBag::remove(TComp e) {

    int index = hash(e);

    node *current = array[index], *previous = nullptr;
    while(current != nullptr && current->value != e) {
        previous = current;
        current = current->next_in_set;
    }

    if (current != nullptr && current->frequency == 1){

        if(previous != nullptr)
            previous->next_in_set = current->next_in_set;
        else if(current->next_in_set != nullptr)
            array[index] = current->next_in_set;
        else array[index] = nullptr;

        delete current;
    }
    else if(current != nullptr && current->frequency > 1)
        current->frequency--;
    else return false;

    length--;

	return true;
}


bool SortedBag::search(TComp elem) const {

    int index = hash(elem);

    node *current = array[index];
    while(current != nullptr && current->value != elem)
        current = current->next_in_set;

    if(current == nullptr)
        return false;
	return true;
}


int SortedBag::nrOccurrences(TComp elem) const {

    int index = hash(elem);

    node *current = array[index];
    while(current != nullptr && current->value != elem)
        current = current->next_in_set;

    if(current == nullptr)
        return 0;
    return current->frequency;
}

int SortedBag::size() const {

	return length;
}


bool SortedBag::isEmpty() const {

	return length == 0;
}


SortedBagIterator SortedBag::iterator() const {

	return SortedBagIterator(*this);
}


SortedBag::~SortedBag() {

    node* previous;
    for(int i = 0; i < capacity; i++)
        while(array[i] != nullptr){
            previous = array[i];
            array[i] = array[i]->next_in_set;
            delete previous;
        }

    delete[] array;
}

// T(n)
int SortedBag::elementsWithMaximumFrequency() {

    int maximum = 0, number_of_values = 0;

    for(int i = 0; i < capacity; i++) {

        node *current = array[i];
        while(current != nullptr) {

            if (current->frequency > maximum) {
                maximum = current->frequency;
                number_of_values = 1;
            }
            else if (current->frequency == maximum)
                number_of_values++;

            current = current->next_in_set;
        }
    }

    return number_of_values;
}


