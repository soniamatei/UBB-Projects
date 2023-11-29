#include "TestFunction.h"
#include <cassert>
#include "SortedMultiMap.h"
#include "SMMIterator.h"
#include <exception>
#include <vector>


bool relation12(TKey cheie1, TKey cheie2) {
    if (cheie1 <= cheie2) {
        return true;
    }
    else {
        return false;
    }
}

void testFunction() {

    SortedMultiMap smm = SortedMultiMap(relation12);

    vector<TKey> empty = smm.keySet();
    assert(empty.size() == 0);

    for (int i = 0; i < 10; i++) {
        smm.add(i, i + 1);
        smm.add(i, i + 2);
    }
    vector<TKey> keys = smm.keySet();

    int count = 0;
    for (auto i = keys.begin(); i < keys.end(); i++, count++) {
        assert(count == *i);
    }
}