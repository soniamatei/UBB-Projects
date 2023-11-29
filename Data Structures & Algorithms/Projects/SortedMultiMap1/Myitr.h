//
// Created by sonia on 6/2/22.
//

#ifndef SORTEDMULTIMAP1_MYITR_H
#define SORTEDMULTIMAP1_MYITR_H


#include "smm.h"
#include <vector>

class ValueIterator{
    friend class smm;
private:
    //DO NOT CHANGE THIS PART
    const smm& map;
    ValueIterator(const smm& map, TKey k);
    int current;
    vector<TValue> list;

public:

    void first();
    void next();
    bool valid() const;
    TValue getCurrent() const;
};

#endif //SORTEDMULTIMAP1_MYITR_H
