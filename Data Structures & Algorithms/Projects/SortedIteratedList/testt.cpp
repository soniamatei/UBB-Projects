//
// Created by sonia on 5/5/22.
//

#include "testt.h"
#include <assert.h>
#include <cstdlib>
#include <vector>
#include <iostream>
#include "ListIterator.h"
#include "SortedIteratedList.h"

using namespace std;

bool a(TComp c1, TComp c2) {
    if (c1 <= c2) {
        return true;
    } else {
        return false;
    }
}

//generate a vector with values between cMin and cMax so that
//1) no value that is >=cMin and <=cMax which is a multiple of s is not included
//2) values v, v>=cMin and v<=cMax which are a multiple of m (but not of s) are included c/m + 1 times
//3) values >=cMin and <=cMax are in random order
vector<int> ran(int cMin, int cMax, int s, int m) {
    vector<int> v;
    for (int c = cMin; c <= cMax; c++) {
        if (c % s != 0) {
            v.push_back(c);
            if (c % m == 0) {
                for (int j = 0; j < c / m; j++) {
                    v.push_back(c);
                }
            }
        }
    }
    int n = v.size();
    for (int i = 0; i < n - 1; i++) {
        int j = i + rand() % (n - i);
        swap(v[i], v[j]);

    }
    return v;
}

//populate the sorted list with values >=cMin and <=cMax, each included one time, in random order
int popp(SortedIteratedList& list, int cMin, int cMax, int s, int m) {
    vector<int> v = ran(cMin, cMax, s, m);
    int n = v.size();
    for (int i = 0; i < n; i++) {
        list.add(v[i]);
    }
    return n;
}

void testt() {
    SortedIteratedList list = SortedIteratedList(a);
    int n = popp(list, 0, 10, 2, 3);
    assert(!list.isEmpty());
    for (int v = 2; v <= 5; v++) {
        ListIterator p = list.search(v);
        //we can't find values which are a multiple of s
        assert(p.valid() == (v % 2 != 0));
        //values which are a multiple of m can be found exactly v/m+1 times
        if (p.valid() && v%3 == 0){
            for (int i=0; i<=v/3; i++){
                try{
                    assert(list.remove(p) == v);
                } catch (exception&) {
                    assert(false);
                }
            }
            assert(!list.search(v).valid());
        }
    }



}