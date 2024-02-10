#include <iostream>
#include "condition_variable"
#include "thread"
#include "mutex"
#include "queue"
#include "random"
#include "atomic"

using namespace std;

queue<int> que;
int no_numbers = 10, number1, number2, final_result = 0;
atomic<bool> ready_consumer = true, ready_producer = false;
condition_variable cv_finished;
mutex mutex_finished;
std::random_device rd;
std::mt19937 gen(rd());
std::uniform_int_distribution<> distrib(1, 5);

void consumer() {
    try {
        while(no_numbers) { //this should take until empty queue, wait for notif
            unique_lock lock(mutex_finished);
            cv_finished.wait(lock, []{return ready_producer == true;});

            if (!que.empty()) {
                final_result += que.front();
                que.pop();
            }

            ready_producer = false;
            ready_consumer = true;
            cout << "consumer\n";
            cv_finished.notify_all();
        }
    }
    catch (exception &e) {
        cout << e.what() << " consumer";
    }
}

void producer() {
    try {
        while (no_numbers) {  //this should add until the buffer is full, notify at each step?
            unique_lock lock(mutex_finished);
            cv_finished.wait(lock, []{return ready_consumer == true;});

            number1 = distrib(gen);
            number2 = distrib(gen);
            cout << number1 << " " << number2 << " producer\n";
            que.push(number1 * number2);
            ready_consumer = false;
            ready_producer = true;
            no_numbers--;
            cv_finished.notify_all();
        }
    }
    catch (exception &e) {
        cout << e.what() << " producer";
    }
}

int main() {

    thread c(consumer), p(producer);
    c.join();
    p.join();
    cout << final_result;
    return 0;
}
