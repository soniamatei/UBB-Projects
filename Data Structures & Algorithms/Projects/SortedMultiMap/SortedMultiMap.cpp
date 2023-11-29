#include "SMMIterator.h"
#include "SortedMultiMap.h"
#include <iostream>
#include <vector>
#include <exception>
using namespace std;

// θ(1)
SortedMultiMap::SortedMultiMap(Relation r) {

    head = nullptr;
    relation = r;
    length = 0;
}

// θ(1)
SortedMultiMap::SLLNode::SLLNode(TElem info, PNode next) {

    this->info = info;
    this->next = next;
}

// Best: θ(1)      Worst: θ(n)        Average: θ(n)      =>      Total: O(n)
void SortedMultiMap::add(TKey c, TValue v) {

    PNode current_node_ptr = head, prev_node_ptr;
    while (current_node_ptr != nullptr && relation(current_node_ptr->info.first, c) &&
           (current_node_ptr->info.first != c || current_node_ptr->info.second != v)) {

        prev_node_ptr = current_node_ptr;
        current_node_ptr = current_node_ptr->next;
    }

    // create a new node with information given
    PNode new_node = new SLLNode(TElem{c, v} , nullptr);

    // if the element exits already
//    if (current_node_ptr != nullptr && c == current_node_ptr->info.first &&
//        v == current_node_ptr->info.second)
//            return;
    if (current_node_ptr == new_node)
        return;

    // if the new element is added at the end of the list
    else if (head != nullptr && current_node_ptr == nullptr) {

       prev_node_ptr->next = new_node;
    }

    // if the new element is added in the middle or beginning
    else if (head != nullptr && current_node_ptr != nullptr) {

        PNode replacer = new SLLNode(TElem{current_node_ptr->info.first,
                                                current_node_ptr->info.second} , current_node_ptr->next);
        new_node->next = replacer;
        *current_node_ptr = *new_node;
    }

    // if the element is the first
    else head = new_node;

    length++;
}

// Best: θ(1)      Worst: θ(n + m)        Average: θ(n + m)      =>      Total: O(n + m)
vector<TValue> SortedMultiMap::search(TKey c) const {

    PNode node_ptr = head;
    while (node_ptr != nullptr && node_ptr->info.first != c) {

        node_ptr = node_ptr->next;
    }

    vector<TValue> values;

    // if the key doesn't exist, return empty vector
    if (node_ptr == nullptr)
        return values;

    // push every value with the key 'c'
    while (node_ptr != nullptr && node_ptr->info.first == c) {

        values.push_back(node_ptr->info.second);
        node_ptr = node_ptr->next;
    }

	return values;
}

// Best: θ(1)      Worst: θ(n)        Average: θ(n)      =>      Total: O(n)
bool SortedMultiMap::remove(TKey c, TValue v) {

    PNode current_node_ptr = head, prev_node_ptr;
    while (current_node_ptr != nullptr && relation(current_node_ptr->info.first, c) &&
           (current_node_ptr->info.first != c || current_node_ptr->info.second != v)) {

        prev_node_ptr = current_node_ptr;
        current_node_ptr = current_node_ptr->next;
    }

    // if element doesn't exist
    if (current_node_ptr == nullptr || current_node_ptr->info.first != c || current_node_ptr->info.second != v)
        return false;

    // if element is the head
    else if (head == current_node_ptr)
        head = current_node_ptr->next;

    // if element is in the middle or at the end
    else prev_node_ptr->next = current_node_ptr->next;

    delete current_node_ptr;
    length--;

    return true;
}

// θ(1)
int SortedMultiMap::size() const {

	return length;
}

// θ(1)
bool SortedMultiMap::isEmpty() const {

    if (length == 0)
        return true;
	return false;
}

// θ(1)
SMMIterator SortedMultiMap::iterator() const {

	return SMMIterator(*this);
}

// Best: θ(1)      Worst: θ(n)        Average: θ(n)      =>      Total: O(n)
SortedMultiMap::~SortedMultiMap() {

    if (head == nullptr)
        return;

    if (head->next == nullptr) {
        delete head;
        return;
    }

    PNode current_node_ptr = head->next, prev_node_ptr = head;

    while (current_node_ptr != nullptr) {

        delete prev_node_ptr;
        prev_node_ptr = current_node_ptr;
        current_node_ptr = current_node_ptr->next;
    }
}

// θ(n)
vector<TKey> SortedMultiMap::keySet() const {

    vector<TKey> keys;
    PNode current_node = head;

    while (current_node != nullptr) {
        TKey key = current_node->info.first;

        while (current_node != nullptr && key == current_node->info.first)
            current_node = current_node->next;

        keys.push_back(key);
    }
    return keys;
}