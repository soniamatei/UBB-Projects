//
// Created by sonia on 6/2/22.
//

#include "myt.h"
#include "smm.h"
#include "Myitr.h"
#include "assert.h"

bool r(TKey cheie1, TKey cheie2) {
    if (cheie1 <= cheie2) {
        return true;
    }
    else {
        return false;
    }
}

void myt(){

    smm s = smm(r);

    s.add(1,2);
    s.add(1,3);

    ValueIterator it = s.iterator(0);
    it.first();
    assert(it.valid() == false);

    ValueIterator i = s.iterator(1);
    i.first();
    int k = 2;
    while (i.valid()){
        TValue e = i.getCurrent();
        assert(e==k);
        k++;
        i.next();
    }
}