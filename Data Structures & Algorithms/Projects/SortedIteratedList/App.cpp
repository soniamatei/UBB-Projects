#include <iostream>

#include "ShortTest.h"
#include "ExtendedTest.h"
#include "testt.h"

int main(){
    testAll();
    testAllExtended();
//    testt();
    std::cout<<"Finished IL Tests!"<<std::endl;
	system("pause");
}