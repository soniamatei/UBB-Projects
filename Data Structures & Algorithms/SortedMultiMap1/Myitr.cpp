//
// Created by sonia on 6/2/22.
//

#include "Myitr.h"
#include "SortedMultiMap.h"

ValueIterator::ValueIterator(const smm& d,  TKey k) : map(d){

    list = map.search(k);

    if(list.empty())
        current =  1;
    else current = 0;
}

void ValueIterator::first(){

    if(list.empty())
        current = -1;
    else current = 0;
}

bool ValueIterator::valid() const{

    return current < list.size();
}

TValue ValueIterator::getCurrent() const{

    if(!valid())
        throw exception();
    return list[current];
}

void ValueIterator::next(){

    if(!valid())
        throw exception();
    current++;
}


