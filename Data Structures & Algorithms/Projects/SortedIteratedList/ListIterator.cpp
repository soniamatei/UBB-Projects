#include "ListIterator.h"
#include "SortedIteratedList.h"
#include <exception>

using namespace std;

ListIterator::ListIterator(const SortedIteratedList& list) : list(list){
	current = list.head;
}

void ListIterator::first(){
    current = list.head;
}

void ListIterator::next(){

    if(!valid())
        throw exception();
    current = list.nodes[current].next;
}

bool ListIterator::valid() const{
	return current != -1;
}

TComp ListIterator::getCurrent() const{

    if(!valid())
        throw exception();
    return list.nodes[current].info;
}

void ListIterator::jumpForward(int k) {

    if(!valid() or k <= 0)
        throw exception();

    while (valid() && k) {
        next();
        k--;
    }
}


