//
// Created by sonia on 5/27/22.
//


#include "SortedBag.h"
#include "SortedBagIterator.h"
#include <assert.h>
#include <iostream>
#include <exception>
#include "MyTest.h"


bool relationI(TComp r1, TComp r2) {
    return r1 <= r2;
}

bool relationII(TComp r1, TComp r2) {
    return r1 >= r2;
}

void MyTest() {

    SortedBag sb(relationI);
    sb.add(5);
    sb.add(5);
    sb.add(6);
    sb.add(7);
    sb.add(6);
    sb.add(9);
    assert(sb.elementsWithMaximumFrequency() == 2);

    sb.remove(6);
    assert(sb.elementsWithMaximumFrequency() == 1);

    SortedBag s(relationII);
    s.add(5);
    s.add(5);
    s.add(6);
    s.add(7);
    s.add(6);
    s.add(9);
    assert(s.elementsWithMaximumFrequency() == 2);

    s.remove(6);
    assert(s.elementsWithMaximumFrequency() == 1);
    std::cout << "My test.\n";

    return;
}
