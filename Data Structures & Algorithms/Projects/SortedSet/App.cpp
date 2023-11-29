#include "ShortTest.h"
#include "ExtendedTest.h"
#include "SSFixedTest.h"
#include "SortedSet.h"
#include "SortedSetIterator.h"
#include <iostream>

using namespace std;

bool rl(TComp e1, TComp e2) {
    if (e1 <= e2) {
        return true;
    }
    else {
        return false;
    }
}

int main() {
	testAll();
	testAllExtended();
    testSSFixed();

	cout << "Test end" << endl;
	system("pause");
}