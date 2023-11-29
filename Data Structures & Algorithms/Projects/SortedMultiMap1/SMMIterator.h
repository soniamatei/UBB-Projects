#pragma once

#include "SortedMultiMap.h"
#include <vector>

class SMMIterator{
	friend class SortedMultiMap;
private:
	//DO NOT CHANGE THIS PART
	const SortedMultiMap& map;
	SMMIterator(const SortedMultiMap& map);

	vector<SortedMultiMap::Node*> stack;
    SortedMultiMap::Node* current;

public:
	void first();
	void next();
	bool valid() const;
   	TElem getCurrent() const;
};

