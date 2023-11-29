#include <iostream>
#include "TestFunction.h"
#include "ShortTest.h"
#include "ExtendedTest.h"

int main(){
    testAll();
	testAllExtended();
    testFunction();

    std::cout<<"Finished SMM Tests!"<<std::endl;
	system("pause");
}
