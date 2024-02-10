#include <iostream>
#include <random>
#include <thread>
#include "Manager.h"

Manager::Manager(int no_bills, Inventory& inventory1, int no_products, int no_threads) : inventory(inventory1) {
    this->no_bills = no_bills;
    this->no_products = no_products;
    this->no_threads = no_threads;
    generateBills();
}

void Manager::generateBills() {
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> dis_product_number(0, no_products-1); // random product from how many there are
    std::uniform_int_distribution<> dis_product_quantity(1, 6); // random quantity between 1-6)
    std::uniform_int_distribution<> dis_no_sells(1, 3); // random how many products
    for (int i = 0; i < no_bills; i++) {
        Bill bill;
        int no_sells = dis_no_sells(gen);
        for (int j = 0; j < no_sells; j++) {
            int product_number = dis_product_number(gen);
            int product_quantity = dis_product_quantity(gen);
            Sell sell{product_number, product_quantity};
            bill.product_list.emplace_back(sell);
            bill.total_sum += 7 * product_quantity;
        }
        bill_list.emplace_back(std::move(bill));
    }
}

void Manager::printBills() {
    for (const auto& bill : bill_list) {
        for (auto sell :bill.product_list)
            std::cout <<"p:"<< sell.product_number << " q:" << sell.product_quantity << "\n";
        std::cout << "sum: " << bill.total_sum << "\n\n";
    }
}

void Manager::execute() {
    auto start = std::chrono::high_resolution_clock::now();
    std::vector<std::thread> threads;
    for(int i = 0; i < no_threads; i++)
        threads.emplace_back(&Manager::threadFunction, this);

    std::thread controller{&Manager::control, this};

    for(auto& t : threads)
        t.join();

    controller.join();
    auto stop = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::microseconds>(stop - start);
    std::cout << "Time taken by function: " << duration.count() << " microseconds\n";
}

void Manager::threadFunction() {
    try {
        //signal finished work on previous bill
        finished_lock.lock();
        finished++;
        finished_lock.unlock();

        general_lock.lock();

        // if bills are done, exit
        if(current_bill == no_bills - 1) {
            general_lock.unlock();
            wait = 1;
            return;
        }

        Bill bill = bill_list.at(++current_bill);
        int bbb = current_bill;

        // increase the pass and start waiting
        if (current_bill % passes_before_control == 0)
            wait = 1;

        // wait while control is done and make others wait too
        while(wait) {
            std::this_thread::sleep_for(std::chrono::seconds(0));
        }
        general_lock.unlock();

        // signalize start working on next bill
        finished_lock.lock();
        finished--;
        finished_lock.unlock();

        // consume
        for (auto sell : bill.product_list) {
    //        std::cout << "sell" << " " << std::this_thread::get_id() << "\n";
            inventory.registerSale(sell.product_number, sell.product_quantity, bbb);
        }
    }
    catch (std::exception & e) {
        std::cout << e.what() ;
    }
    threadFunction();
}

void Manager::control() {
    // wait until all threads are done
    while(!wait || finished != no_threads)
        std::this_thread::sleep_for(std::chrono::seconds(0));

    int current_sum = 0;
    for (int i = 0; i < current_bill; i++) {
//        std::cout << i << "i\n";
        current_sum += bill_list.at(i).total_sum;
    }

    // verify the result
    if (current_sum == inventory.getTotalSum())
        std::cout << "Cool  ";
    else std::cout << "Not cool  ";
    std::cout << current_sum << " " << inventory.getTotalSum() << " bill" << current_bill << "\n";

    if(current_bill == no_bills - 1) {
        wait = 0; // let threads continue
        return;
    }
    else {
        wait = 0;
        control();
    }
}


