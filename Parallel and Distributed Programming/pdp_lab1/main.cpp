#include <iostream>
#include "inventory.h"
#include "Manager.h"

int main() {
    Inventory inventory{1000, 1000};
    Manager manager{100000, inventory, 1000, 100};
//    inventory.printProducts();
//    manager.printBills();
    manager.execute();
    return 0;
}
