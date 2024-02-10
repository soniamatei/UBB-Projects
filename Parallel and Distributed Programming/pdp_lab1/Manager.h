#ifndef PDP_LAB1_MANAGER_H
#define PDP_LAB1_MANAGER_H
#include "vector"
#include "map"
#include "inventory.h"

class Manager {
private:
    struct Sell {
        int product_number, product_quantity;
    };
    struct Bill {
        std::vector<Sell> product_list;
        int total_sum = 0;
    };
    int no_bills, no_products, no_threads, passes_before_control = 1000, finished = 0;
    std::atomic<int> wait = 0, current_bill = -1;
    std::vector<Bill> bill_list;
    Inventory& inventory;
    std::mutex general_lock;
    std::mutex finished_lock;

    void generateBills();
    void threadFunction();
    void control();

public:
    Manager(int no_bills, Inventory& inventory1, int no_products, int no_threads);
    void printBills();
    void execute();

};


#endif //PDP_LAB1_MANAGER_H
