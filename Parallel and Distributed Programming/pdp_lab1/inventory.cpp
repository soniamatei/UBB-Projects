#include "inventory.h"
#include <cstdlib>
#include <iostream>
#include <random>

Inventory::Inventory(int average_quantity, int no_products) {
    this->average_quantity = average_quantity;
    this->no_products = no_products;

    createProducts();
}


void Inventory::createProducts() {
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> dis_quantity(average_quantity - 10, average_quantity + 11); // random quantity around average
    for (int i = 0; i < no_products; i++) {
        Product product{};
        product.quantity = dis_quantity(gen);
        products.push_back(product);
    }
    std::vector<std::mutex> short_locks(no_products);
    locks.swap(short_locks);
}

void Inventory::printProducts() {
    int count = 0;
    std::cout << locks.size() << " (l size)\n";
    for (auto iter = products.begin(); iter != products.end(); iter++) {
        std::cout << count << " " << iter->quantity << "\n";
        count+=1;
    }
    std::cout << "\n\n";
}

void Inventory::registerSale(int product_number, int no_products, int bill) {
    std::lock_guard<std::mutex> guard(locks.at(product_number));
    Product product = products.at(product_number % granularity + product_number / granularity);
//    Product product = products.at(product_number);
    if (product.quantity != 0) {
        if (product.quantity - no_products >= 0) {
            product.quantity -= no_products;
            loc_total_sum.lock();
            total_sum += no_products * price_per_product;
//            std::cout << "first " << no_products * price_per_product << "sum  bill" << bill << "\n";
            loc_total_sum.unlock();
        }
        else {
            loc_total_sum.lock();
            total_sum += product.quantity * price_per_product;
//            std::cout << "second " << product.quantity * price_per_product << "sum bill" << bill << "\n";
            loc_total_sum.unlock();
            product.quantity = 0;
        }
    }
}

int Inventory::getTotalSum() const {
    return total_sum;
}


