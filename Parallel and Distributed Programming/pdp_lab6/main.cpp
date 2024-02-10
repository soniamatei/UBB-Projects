#include <iostream>
#include <algorithm>
#include <thread>
#include <mutex>
#include <future>
#include "vector"

using namespace std;

int cp =1 ;
mutex mtx;

class Graph {
private:
    struct PathNode {
        int vertex = -1;
        bool visited = false;
    };
    int vertices;
    vector<vector<int>> adjList;
    vector<PathNode> path;
    mutex adjList_mtx;
    mutex path_mtx;

public:
    explicit Graph(int v) : vertices(v), adjList(v), path(v) {}

    void addEdge(int vertex, int other) {
        unique_lock<std::mutex> uniqueLock(adjList_mtx);
        adjList[vertex].push_back(other);
    }

    [[nodiscard]] bool isAdjacent(int vertex, int other) const {
        return any_of(adjList[vertex].begin(), adjList[vertex].end(), [other](int neighbor) {
            return neighbor == other;
        });
    }

    [[nodiscard]] bool isSafe(int current_vertex, int last_vertex_path) const {
        // verify there is an edge between current_vertex and last vertex in path searched till now
        if (!isAdjacent(last_vertex_path, current_vertex)) {
            return false;
        }

        // check current_vertex isn't in path already
        return std::all_of(path.begin(), path.end(), [current_vertex](PathNode node) {
            return node.vertex != current_vertex;
        });
    }

    void loop(int start_vertex, int end_vertex, int current_position_path, promise<bool>& promise) {

        // we got to the end of dividing
        if (start_vertex == end_vertex || start_vertex == end_vertex - 1) {

            // set if the node is safe
            if (isSafe(start_vertex, path[cp - 1].vertex)) {

                unique_lock<std::mutex> uniqueLock(path_mtx);
                path[cp].vertex = start_vertex;
                promise.set_value(true);
                return;
            }

            promise.set_value(false);
            return;
        }

        // computation from child nodes is true
        if (hamiltonianCycle(current_position_path, start_vertex, end_vertex)) {

            // we found a node for the current position, so we increase it
            cp++;
            for (int vertex = start_vertex; vertex <= end_vertex; vertex++) {
                if (isSafe(vertex, path[cp - 1].vertex)) {
                    unique_lock<std::mutex> uniqueLock(path_mtx);
                    path[cp].vertex = vertex;
                    promise.set_value(true);
                    return;
                }
            }

            // if there is no edge or the existing one is not safe
            promise.set_value(false);
        }
        else {
            promise.set_value(false);
        }


    }

    bool hamiltonianCycle(int current_position_path, int start_vertex, int end_vertex) {

        if (cp == vertices && isSafe(0, path[cp -1 ].vertex)) {
            return true;
        }

        promise<bool> p_1;
        promise<bool> p_2;

        int mid = (start_vertex + end_vertex) / 2;
        cout << mid << "mid" << start_vertex << "s" << end_vertex << "e" << endl;
        thread th_1(&Graph::loop, this, start_vertex, mid, current_position_path, ref(p_1));
        thread th_2(&Graph::loop, this, mid, end_vertex, current_position_path, ref(p_2));

        th_1.join();
        th_2.join();

        return p_1.get_future().get() || p_2.get_future().get();
    }

    void findHamiltonianCycle() {
        // start from vertex 0 as the initial vertex
        path[0].vertex = 0;

        if (hamiltonianCycle(1, 1, vertices)) {
            cout << "Hamiltonian Cycle found:\n";
            for (PathNode node : path) {
                cout << node.vertex << " ";
            }
            cout << path[0].vertex << "\n";
        } else {
            cout << "No Hamiltonian Cycle exists.";
        }
    }
};



int main() {
    Graph graph(4);

    graph.addEdge(0, 1);
    graph.addEdge(1, 2);
    graph.addEdge(2, 3);
    graph.addEdge(3, 0);

    graph.findHamiltonianCycle();

    return 0;
}
