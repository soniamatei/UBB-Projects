#include <iostream>

#include "ShortTest.h"
#include "ExtendedTest.h"
#include "myt.h"

int main(){
    testAll();
	testAllExtended();
    myt();

    std::cout<<"Finished SMM Tests!"<<std::endl;
	system("pause");
}
