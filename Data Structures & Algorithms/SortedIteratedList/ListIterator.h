#pragma once
#include "SortedIteratedList.h"

//DO NOT CHANGE THIS PART
class ListIterator{
	friend class SortedIteratedList;
private:
	const SortedIteratedList& list;
	ListIterator(const SortedIteratedList& list);

	int current;
public:
	void first();
	void next();
	bool valid() const;
    void jumpForward(int k);
    TComp getCurrent() const;
};


