#include "SMMIterator.h"
#include "SortedMultiMap.h"

SMMIterator::SMMIterator(const SortedMultiMap& d) : map(d){

    current = d.head;
}

void SMMIterator::first(){

    current = map.head;
}

void SMMIterator::next(){

    if (current == nullptr)
        throw exception();
    current = current->next;
}

bool SMMIterator::valid() const{

	return current != nullptr;
}

TElem SMMIterator::getCurrent() const{

    if (current == nullptr)
        throw exception();
	return current->info;
}


