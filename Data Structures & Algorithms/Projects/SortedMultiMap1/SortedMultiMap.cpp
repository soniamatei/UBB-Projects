#include "SMMIterator.h"
#include "SortedMultiMap.h"
#include <vector>
#include <exception>

using namespace std;

SortedMultiMap::SortedMultiMap(Relation r) {

    root = nullptr;
    length = 0;
    relation = r;
}

void SortedMultiMap::add(TKey c, TValue v) {

    Node *current = root, *previous = nullptr;
    while (current != nullptr){

        previous = current;

        if (relation(c, current->info.first))
            current = current->left;
        else current = current->right;
    }

    current = new Node;
    current->info.first = c;
    current->info.second = v;
    current->left = nullptr;
    current->right = nullptr;

    if (root == nullptr)
        root = current;

    if (previous != nullptr) {

        if (relation(current->info.first, previous->info.first))
            previous->left = current;
        else previous->right = current;
    }

    length++;
}

vector<TValue> SortedMultiMap::search(TKey c) const {

    vector<TValue> found;

    Node *current = root;
    while(current != nullptr) {

        if (current->info.first == c)
            found.push_back(current->info.second);

        if (relation(c, current->info.first))
            current = current->left;
        else current = current->right;
    }
	return found;
}

bool SortedMultiMap::remove(TKey c, TValue v) {

    Node *current = root, *previous = nullptr;
    while (current != nullptr && (current->info.first != c || current->info.second != v)){
        previous = current;

        if (relation(c, current->info.first))
            current = current->left;
        else current = current->right;
    }

    // if the element doesn't exist in the map
    if (current == nullptr)
        return false;

    // if the node has two children
    else if (current->left != nullptr && current->right != nullptr) {

        Node *maximum_node = current->left, *prev_max_node = current;
        while (maximum_node->right != nullptr) {
            prev_max_node = maximum_node;
            maximum_node = maximum_node->right;
        }

        current->info = maximum_node->info;
        (prev_max_node->left == maximum_node) ? prev_max_node->left = nullptr : prev_max_node->right = nullptr;

        delete maximum_node;
    }

    // if the node has one child
    else if (current->left != nullptr) {

        if (previous == nullptr)
            root = current->left;
        else (previous->left == current) ? previous->left = current->left : previous->right = current->left;

        delete current;
    }

    else if (current->right != nullptr) {

        if (previous == nullptr)
            root = current->right;
        else (previous->right == current) ? previous->right = current->right : previous->left = current->right;

        delete current;
    }

    // if the node is a leaf
    else{
        if (previous == nullptr)
            root = nullptr;
        else (previous->left == current) ? previous->left = nullptr : previous->right = nullptr;

        delete current;
    }

    length--;

    return true;
}

int SortedMultiMap::size() const {

    return length;
}

bool SortedMultiMap::isEmpty() const {

	return length == 0;
}

SMMIterator SortedMultiMap::iterator() const {

	return SMMIterator(*this);
}

SortedMultiMap::~SortedMultiMap() {

    if (root == nullptr)
        return;

    vector<Node*> queue;
    queue.push_back(root);

    while (!queue.empty()) {

        Node* current = *(queue.begin());
        queue.erase(queue.begin());

        if (current->left != nullptr)
            queue.push_back(current->left);
        if (current->right != nullptr)
            queue.push_back(current->right);

        delete current;
    }
}
