#include <iostream>
#include <utility>
#include <vector>
#include <mpi.h>

enum Tag {
    A = 1,
    B = 2,
    m = 3,
    n = 4,
    height = 5,
};

using namespace std;

void print(const vector<int>& v) {
    for (auto& i: v)
        cout << i << " ";
    cout << endl;
}

//------------------------
vector<int> multiplyPolynomialsRegular(const vector<int>& A, const vector<int>& B) {
    unsigned long long m = A.size(), n = B.size();

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
    unsigned long long size = max(A.size(), B.size());
    vector<int> result(size, 0);

    for (int i = 0; i < A.size(); ++i) {
        result[i] += A[i];
    }

    for (int i = 0; i < B.size(); ++i) {
        result[i] += B[i];
    }

    return result;
}

void multiplyPolynomialsKaratsubaMPI(int argc, char** argv, vector<int> vector1, vector<int> vector2) {
    MPI_Init(&argc, &argv);

    int rank, size;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    // round down to the nearest integer to get the height of the full binary tree processes
    int tree_height = static_cast<int>(log2(size));


    if (pow(2, tree_height + 1) - 1 != size) {
        cerr << "This MPI program requires 2^n - 1 processes." << endl;
        MPI_Abort(MPI_COMM_WORLD, 1);
    }

    vector<int> A, B;
    unsigned long long m, n;
    int height;

    if (rank == 0) {
        // process 0 distributes the work
        A = move(vector1);
        B = move(vector2);
        m = A.size();
        n = B.size();

        if (size > m || size > n) {
            cerr << "The number of processes is bigger than the smallest vector." << endl;
            MPI_Abort(MPI_COMM_WORLD, 1);
        }

        if (size < 3) {
            cerr << "The number of processes is smaller than required minimum." << endl;
            MPI_Abort(MPI_COMM_WORLD, 1);
        }

        int min_size = min(m, n);
        int rank_index = 1;
        // needed later
        height = 0;

        for (int it = 0, current_height = 1; it < min_size / 2; it++, current_height++) {
            int mid = min(m, n) / 2;
            int rank_first_process = rank_index++, rank_second_process = rank_index++;

            // get all the necessary vectors to be sent
            vector<int> A0(A.begin(), A.begin() + mid);
            vector<int> A1(A.begin() + mid, A.end());
            vector<int> B0(B.begin(), B.begin() + mid);
            vector<int> B1(B.begin() + mid, B.end());
            unsigned long long m0 = A0.size(), m1 = A1.size(), n0 = B0.size(), n1 = B1.size();
            cout << rank_first_process << rank_second_process << endl;

            // A and B in first process
            MPI_Send(&current_height, 1, MPI_INT, rank_first_process, Tag::height, MPI_COMM_WORLD);
            MPI_Send(&m0, 1, MPI_UNSIGNED_LONG_LONG, rank_first_process, Tag::m, MPI_COMM_WORLD);
            MPI_Send(&n0, 1, MPI_UNSIGNED_LONG_LONG, rank_first_process, Tag::n, MPI_COMM_WORLD);
            MPI_Send(A0.data(), m0, MPI_INT, rank_first_process, Tag::A, MPI_COMM_WORLD);
            MPI_Send(B0.data(), n0, MPI_INT, rank_first_process, Tag::B, MPI_COMM_WORLD);
            // A and B in second process
            MPI_Send(&current_height, 1, MPI_INT, rank_second_process, Tag::height, MPI_COMM_WORLD);
            MPI_Send(&m1, 1, MPI_UNSIGNED_LONG_LONG, rank_second_process, Tag::m, MPI_COMM_WORLD);
            MPI_Send(&n1, 1, MPI_UNSIGNED_LONG_LONG, rank_second_process, Tag::n, MPI_COMM_WORLD);
            MPI_Send(A1.data(), m1, MPI_INT, rank_second_process, Tag::A, MPI_COMM_WORLD);
            MPI_Send(B1.data(), n1, MPI_INT, rank_second_process, Tag::B, MPI_COMM_WORLD);
            cout << rank_first_process << rank_second_process << endl;
            cout << it << min_size << endl;

        }

    }
    else {
        // if process not main process, wait for initialization of variables
        MPI_Recv(&height, 1, MPI_INT, 0, Tag::height, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        MPI_Recv(&m, 1, MPI_UNSIGNED_LONG_LONG, 0, Tag::m, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        MPI_Recv(&n, 1, MPI_UNSIGNED_LONG_LONG, 0, Tag::n, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        A.resize(m);
        B.resize(n);
        MPI_Recv(A.data(), m, MPI_INT, 0, Tag::A, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        MPI_Recv(B.data(), n, MPI_INT, 0, Tag::B, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
    }

    // if leaf process, do the calculation normally
    if (height == tree_height) {
        vector<int> resultKaratsubaMPI;
        resultKaratsubaMPI = multiplyPolynomialsRegular(A, B);
        unsigned long long resultKaratsubaMPI_size = resultKaratsubaMPI.size();

        MPI_Send(&resultKaratsubaMPI_size, 1, MPI_UNSIGNED_LONG_LONG, (rank - 1) / 2, Tag::m, MPI_COMM_WORLD);
        MPI_Send(resultKaratsubaMPI.data(), resultKaratsubaMPI_size, MPI_INT, (rank - 1) / 2, Tag::A, MPI_COMM_WORLD);

        MPI_Finalize();

        return;
    }

    vector<int> P0, P1, P2;
    unsigned long long l0, l1;
    int mid = min(m, n) / 2;

    vector<int> A0(A.begin(), A.begin() + mid);
    vector<int> A1(A.begin() + mid, A.end());
    vector<int> B0(B.begin(), B.begin() + mid);
    vector<int> B1(B.begin() + mid, B.end());

    // receive from first child
    MPI_Recv(&l0, 1, MPI_UNSIGNED_LONG_LONG, rank * 2 + 1, Tag::m, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
    P0.resize(l0);
    MPI_Recv(P0.data(), l0, MPI_INT, rank * 2 + 1, Tag::A, MPI_COMM_WORLD, MPI_STATUS_IGNORE);

    // receive from second child
    MPI_Recv(&l1, 1, MPI_UNSIGNED_LONG_LONG, rank * 2 + 2, Tag::m, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
    P1.resize(l1);
    MPI_Recv(P1.data(), l1, MPI_INT, rank * 2 + 2, Tag::A, MPI_COMM_WORLD, MPI_STATUS_IGNORE);

    // calculate the rest
    P2 = multiplyPolynomialsRegular(add(A0, A1), add(B0, B1));

    vector<int> resultKaratsubaMPI(m + n - 1, 0);

    for (int i = 0; i < P0.size(); ++i) {
        resultKaratsubaMPI[i] += P0[i];
    }

    for (int i = 0; i < P1.size(); ++i) {
        resultKaratsubaMPI[i + mid * 2] += P1[i];
    }

    for (int i = 0; i < P2.size(); ++i) {
        resultKaratsubaMPI[i + mid] += P2[i];
        if (i < P0.size())
            resultKaratsubaMPI[i + mid] -= P0[i];
        if (i < P1.size())
            resultKaratsubaMPI[i + mid] -= P1[i];
    }

    if (rank != 0) {
        unsigned long long resultKaratsubaMPI_size = resultKaratsubaMPI.size();
        MPI_Send(&resultKaratsubaMPI_size, 1, MPI_UNSIGNED_LONG_LONG, (rank - 1) / 2, Tag::m, MPI_COMM_WORLD);
        MPI_Send(resultKaratsubaMPI.data(), resultKaratsubaMPI_size, MPI_INT, (rank - 1) / 2, Tag::A, MPI_COMM_WORLD);
    }
    else {
        print(resultKaratsubaMPI);
    }

    MPI_Finalize();
}


//--------------------
void multiplyPolynomialRegularMPI(int argc, char** argv, vector<int> vector1, vector<int> vector2) {
    MPI_Init(&argc, &argv);

    int rank, size;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    vector<int> A = std::move(vector1);
    vector<int> B = std::move(vector2);
    unsigned long long m = A.size();
    unsigned long long n = B.size();

    if (size > m || size > n) {
        cerr << "The number of processes is bigger than the smallest vector." << endl;
        MPI_Abort(MPI_COMM_WORLD, 1);
    }

    if (size < 3) {
        cerr << "The number of processes is smaller than required minimum." << endl;
        MPI_Abort(MPI_COMM_WORLD, 1);
    }

    vector<int> localResult;
    localResult.resize(m + n - 1, 0);

    if (rank != size - 1) {

        // portion of the result each process will compute
        // size - 1 -> without last process
        unsigned long long stepA = (m  + 1)/ (size - 1);
        unsigned long long localStart = rank * stepA;
        unsigned long long localEnd = localStart + stepA < m ? localStart + stepA: m;

        for (unsigned long long i = localStart; i < localEnd; ++i) {
            for (unsigned long long j = 0; j < n; ++j) {
                localResult[i + j] += A[i] * B[j];
            }
        }
        print(localResult);
    }

    vector<int> globalResult(m + n - 1, 0);
    // gather results from processes with sum on the same position
    MPI_Reduce(localResult.data(), globalResult.data(), localResult.size(), MPI_INT, MPI_SUM, size - 1, MPI_COMM_WORLD);

    if (rank == size - 1) {
        print(globalResult);
    }

    MPI_Finalize();
}


int main(int argc, char** argv) {
    
    vector<int> A = {1, 14, 2};
    vector<int> B = {13, 20, 22, 14};

    multiplyPolynomialsKaratsubaMPI(argc, argv, A, B);
    return 0;
}
