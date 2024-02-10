#include <iostream>
#include "vector"
#include "random"
#include "ThreadPool.h"
#include "chrono"

using namespace std;

int length = 500;
vector<vector<int>> matrix1(length, vector<int>(length));
vector<vector<int>> matrix2(length, vector<int>(length));
vector<vector<int>> matrix3(length, vector<int>(length));
vector<vector<int>> matrix4(length, vector<int>(length));
vector<thread> t;

void multiplyStep(int row_first_matrix, int col_second_matrix) {

    int result = 0;
    for (int i = 0; i < length; i++) {
        result += matrix1[row_first_matrix][i] * matrix2[i][col_second_matrix]; // do it with more elements at once
    }
    matrix3[row_first_matrix][col_second_matrix] = result;
}

void initializeMatrix(vector<vector<int>>& matrix) {

    random_device rd;
    mt19937 gen(rd());
    uniform_int_distribution<> distrib(1, 3);

    for ( vector<int>& vec : matrix) {
        for (int& elem : vec) {
            elem = distrib(gen);
        }
    }
}

void printMatrix(vector<vector<int>>& matrix) {

    for (int i = 0; i < length; i++) {
        for (int j = 0; j < length; ++j) {
            cout << matrix[i][j] << " ";
        }
        cout << "\n";
    }
    cout << "\n";
}

int main() {

    initializeMatrix(matrix1);
    initializeMatrix(matrix2);

    auto t1 = chrono::high_resolution_clock::now();

    ThreadPool thread_pool(3);

    for (int i = 0; i < length; i++) {
        for (int j = 0; j < length; ++j) {
            thread_pool.enqueue([i, j]() { multiplyStep(i, j);});
        }
    }

    thread_pool.close();

    auto t2 = chrono::high_resolution_clock::now();

    for (int i = 0; i < length; i++) {
        for (int j = 0; j < length; ++j) {
            t.emplace_back(multiplyStep, i, j);
        }
    }

    for (thread& t : t){
        t.join();
    }

    auto t3 = chrono::high_resolution_clock::now();

//    printMatrix(matrix1);
//    printMatrix(matrix2);
//    printMatrix(matrix3);
    cout << "threadpool: " << chrono::duration_cast<chrono::milliseconds>(t2 - t1).count() << "\nsimple: " << chrono::duration_cast<chrono::milliseconds>(t3 - t2).count();
    return 0;
}
