#ifndef PDP_LAB1_INVENTORY_H
#define PDP_LAB1_INVENTORY_H

#include <mutex>
#include "vector"

class Inventory {
private:
    struct Product {
//        std::mutex lock;
        int quantity;
    };
    int average_quantity, no_products, price_per_product = 7, total_sum = 0, granularity = 1000;
    std::mutex loc_total_sum;
    std::vector<Product> products;
    std::vector<std::mutex> locks;

    void createProducts();

public:
    Inventory(int average_quantity, int no_products);
    void printProducts();
    void registerSale(int product_number, int no_products, int bill);
    int getTotalSum() const;
};


#endif //PDP_LAB1_INVENTORY_H
