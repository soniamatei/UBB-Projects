#include <iostream>
#include <vector>
#include <thread>
#include <mutex>

using namespace std;

void print(const vector<int>& v) {
    for (auto& i: v)
        cout << i << " ";
    cout << "\n";
}

//------------------------
vector<int> multiplyPolynomialsRegular(const vector<int>& A, const vector<int>& B) {
    int m = A.size();
    int n = B.size();

    vector<int> result(m + n - 1, 0);

    for (int i = 0; i < m; ++i) {
        for (int j = 0; j < n; ++j) {
            result[i + j] += A[i] * B[j];
        }
    }

    return result;
}

//------------------------
vector<int> add(const vector<int>& A, const vector<int>& B) {
    int size = max(A.size(), B.size());
    vector<int> result(size, 0);

    for (int i = 0; i < A.size(); ++i) {
        result[i] += A[i];
    }

    for (int i = 0; i < B.size(); ++i) {
        result[i] += B[i];
    }

    return result;
}

void multiplyPolynomialsKaratsubaParallel(const vector<int>& A, const vector<int>& B, vector<int>& Result, int depth,
                                          mutex& mtx) {
    int m = A.size();
    int n = B.size();

    if (m <= 2 || n <= 2 || depth < 0) {
        Result = multiplyPolynomialsRegular(A, B);
        return;
    }

    int mid = min(m, n) / 2;

    vector<int> A0(A.begin(), A.begin() + mid);
    vector<int> A1(A.begin() + mid, A.end());
    vector<int> B0(B.begin(), B.begin() + mid);
    vector<int> B1(B.begin() + mid, B.end());

    vector<int> P0, P1, P2;
    vector<thread> threads;

    threads.emplace_back(multiplyPolynomialsKaratsubaParallel, ref(A0), ref(B0), ref(P0), depth - 1, ref(mtx));
    threads.emplace_back(multiplyPolynomialsKaratsubaParallel, ref(A1), ref(B1), ref(P1), depth - 1, ref(mtx));
    threads.emplace_back(multiplyPolynomialsKaratsubaParallel, add(A0, A1), add(B0, B1), ref(P2), depth - 1, ref(mtx));


    for (auto& thread: threads) {
        thread.join();
    }

    vector<int> result(m + n - 1, 0);

    for (int i = 0; i < P0.size(); ++i) {
        result[i] += P0[i];
    }

    for (int i = 0; i < P1.size(); ++i) {
        result[i + mid * 2] += P1[i];
    }

    for (int i = 0; i < P2.size(); ++i) {
        result[i + mid] += P2[i];
        if (i < P0.size())
            result[i + mid] -= P0[i];
        if (i < P1.size())
            result[i + mid] -= P1[i];
    }

    Result = result;
}

//-------------------
void multiplyPolynomialsKaratsuba(const vector<int>& A, const vector<int>& B, vector<int>& Result) {
    int m = A.size();
    int n = B.size();

    if (m <= 2 || n <= 2) {
        Result = multiplyPolynomialsRegular(A, B);
        return;
    }

    int mid = min(m, n) / 2 ;
    vector<int> P0, P1, P2;

    vector<int> A0(A.begin(), A.begin() + mid);
    vector<int> A1(A.begin() + mid, A.end());
    vector<int> B0(B.begin(), B.begin() + mid);
    vector<int> B1(B.begin() + mid, B.end());

    multiplyPolynomialsKaratsuba(A0, B0, P0);
    multiplyPolynomialsKaratsuba(A1, B1, P1);
    multiplyPolynomialsKaratsuba(add(A0, A1), add(B0, B1), P2);

    vector<int> result(m + n - 1, 0);

    for (int i = 0; i < P0.size(); ++i) {
        result[i] += P0[i];
    }

    for (int i = 0; i < P1.size(); ++i) {
        result[i + mid * 2] += P1[i];
    }

    for (int i = 0; i < P2.size(); ++i) {
        result[i + mid] += P2[i];
        if (i < P0.size())
            result[i + mid] -= P0[i];
        if (i < P1.size())
            result[i + mid] -= P1[i];
    }

    Result = result;
}

//--------------------
vector<int> multiplyPolynomialsParallel(const vector<int>& A, const vector<int>& B, int numThreads) {
    int m = A.size();
    int n = B.size();
    vector<int> result(m + n - 1, 0);

    int chunkSize = m / numThreads;
    vector<thread> threads;

    mutex mtx;

    auto multiplyChunk = [&](int start, int end) {
        for (int i = start; i < end; ++i) {
            for (int j = 0; j < n; ++j) {
                mtx.lock();
                result[i + j] += A[i] * B[j];
                mtx.unlock();
            }
        }
    };

    for (int i = 0; i < numThreads; ++i) {
        int start = i * chunkSize;
        int end = (i == numThreads - 1) ? m : (i + 1) * chunkSize;
        threads.emplace_back(multiplyChunk, start, end);
    }

    for (auto& thread: threads) {
        thread.join();
    }

    return result;
}

int main() {
    vector<int> A = {1, 14, 2};
    vector<int> B = {13, 20, 22, 14};

    auto start = chrono::high_resolution_clock::now();
    vector<int> resultRegular = multiplyPolynomialsRegular(A, B);
    auto end = chrono::high_resolution_clock::now();
    chrono::duration<double> durationRegular = end - start;
    cout << "\nRegular Multiplication Duration: " << durationRegular.count() << " seconds\n";
    print(resultRegular);

    mutex mutexP;
    int depth = 3;
    vector<int> resultKaratsubaParallel;
    start = chrono::high_resolution_clock::now();
    multiplyPolynomialsKaratsubaParallel(A, B, resultKaratsubaParallel, depth, mutexP);
    end = chrono::high_resolution_clock::now();
    chrono::duration<double> durationKaratsubaParallel = end - start;
    cout << "\nKaratsuba Parallel Multiplication Duration: " << durationKaratsubaParallel.count() << " seconds\n";
    print(resultKaratsubaParallel);

    mutex mutex;
    vector<int> resultKaratsuba;
    start = chrono::high_resolution_clock::now();
    multiplyPolynomialsKaratsuba(A, B, resultKaratsuba);
    end = chrono::high_resolution_clock::now();
    chrono::duration<double> durationKaratsuba = end - start;
    cout << "\nKaratsuba Multiplication Duration: " << durationKaratsuba.count() << " seconds\n";
    print(resultKaratsuba);

    int numThreads = 4;
    start = chrono::high_resolution_clock::now();
    vector<int> resultParallel = multiplyPolynomialsParallel(A, B, numThreads);
    end = chrono::high_resolution_clock::now();
    chrono::duration<double> durationRegularParallel = end - start;
    cout << "\nParallel Multiplication Duration: " << durationRegularParallel.count() << " seconds\n";
    print(resultParallel);

    return 0;
}
