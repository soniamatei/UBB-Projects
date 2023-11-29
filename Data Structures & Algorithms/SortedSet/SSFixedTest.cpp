#include "SSFixedTest.h"
#include "SortedSetFixed.h"
#include <assert.h>

bool r(TComp e1, TComp e2) {
    if (e1 <= e2) {
        return true;
    }
    else {
        return false;
    }
}

void testSSFixed() {

    SortedSetFixed ss{r, 20};

    assert(ss.isFull() == false);

    for (int i = 0; i < 20; i++)
        assert(ss.add(i) == true);

    assert(ss.add(20) == false);
    assert(ss.isFull() == true);

    return;
}