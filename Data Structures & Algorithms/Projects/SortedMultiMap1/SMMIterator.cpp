#include "SMMIterator.h"
#include "SortedMultiMap.h"

SMMIterator::SMMIterator(const SortedMultiMap& d) : map(d){

    stack.clear();

    SortedMultiMap::Node* node = map.root;
    while (node != nullptr) {

        stack.push_back(node);
        node = node->left;
    }

    if (stack.empty())
        current = nullptr;
    else {
        current = stack.back();
        stack.pop_back();
    }
}

void SMMIterator::first(){

    stack.clear();

    SortedMultiMap::Node* node = map.root;
    while (node != nullptr) {

        stack.push_back(node);
        node = node->left;
    }

    if (stack.empty())
        current = nullptr;
    else {
        current = stack.back();
        stack.pop_back();
    }
}

void SMMIterator::next(){

    if (!valid())
        throw  exception();

    SortedMultiMap::Node* node = current->right;
    while (node != nullptr) {

        stack.push_back(node);
        node = node->left;
    }

    if (stack.empty())
        current = nullptr;
    else {
        current = stack.back();
        stack.pop_back();
    }
}

bool SMMIterator::valid() const{

	return current != nullptr;
}

TElem SMMIterator::getCurrent() const{

    if(!valid())
        throw exception();
	return current->info;
}


