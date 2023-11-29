from exception import UndirectedGraphException
from copy import deepcopy
from random import randint, choice
from heapq import heappush, heappop

class UndirectedGraph:

    def __init__(self):
        self.__in = {}
        self.__cost = {}

    def isVertex(self, vertex):
        """
        Verifies if a vertex is in the graph.
        :param vertex: integer
        :return: boolean
        """

        return vertex in self.__in

    def isEdge(self, source, destination):
        """
        Verifies if an edge is in the graph.
        :param source: integer
        :param destination: integer
        :return: boolean
        """

        return (source, destination) in self.__cost or (destination, source) in self.__cost

    def deleteEdge(self, source, destination):
        """
        Deletes an edge no matter the order of the vertex.
        :param source:
        :param destination:
        :return:
        """

        if (source, destination) in self.__cost:
            del self.__cost[(source, destination)]

        else:
            del self.__cost[(destination, source)]

    @property
    def copy(self):
        return deepcopy(self)

    def addVertex(self, vertex):
        """
        Adds a vertex to the graph.
        :param vertex: integer
        """

        if self.isVertex(vertex):
            raise UndirectedGraphException("Vertex already exists.")
        self.__in[vertex] = []

    def removeVertex(self, vertex):
        """
        Removes a vertex from the graph.
        :param vertex:
        """

        if not self.isVertex(vertex):
            raise UndirectedGraphException("Vertex doesn't exist.")
        del self.__in[vertex]

        if (vertex, vertex) in self.__cost:
            self.deleteEdge(vertex, vertex)

        for other in self.__in:

            if vertex in self.__in[other]:#Todo
                self.__in[other].remove(vertex)
                self.deleteEdge(other, vertex)

    def addEdge(self, source, destination, cost):
        """
        Adds an edge to the graph with a cost.
        :param source: integer
        :param destination: integer
        :param cost: integer
        """

        if not self.isVertex(source) or not self.isVertex(destination):
            raise UndirectedGraphException("One or both vertices don't exist.")
        if self.isEdge(source, destination):
            raise UndirectedGraphException("Edge already exists.")
        self.__in[source].append(destination)
        self.__in[destination].append(source)
        self.__cost[(source, destination)] = cost

    def removeEdge(self, source, destination):
        """
        Removes an edge from the graph.
        :param source: integer
        :param destination: integer
        """

        if not self.isVertex(source) or not self.isVertex(destination):
            raise UndirectedGraphException("One or both vertices don't exist.")
        if not self.isEdge(source, destination):
            raise UndirectedGraphException("Edge doesn't exist.")
        self.__in[source].remove(destination)
        self.__in[destination].remove(source)
        self.deleteEdge(source, destination)

    def getCost(self, source, destination):
        """
        Returns the cost of an edge.
        :param source: integer
        :param destination: integer
        :return: integer
        """

        if not self.isEdge(source, destination):
            raise UndirectedGraphException("Edge doesn't exist.")

        if (source, destination) in self.__cost:
            return self.__cost[(source, destination)]

        else:
            return self.__cost[(destination, source)]

    def setCost(self, source, destination, value):
        """
        Set a new cost to an edge.
        :param source: integer
        :param destination: integer
        :param value: integer
        """

        if not self.isEdge(source, destination):
            raise UndirectedGraphException("Edge doesn't exist.")

        if (source, destination) in self.__cost:
            self.__cost[(source, destination)] = value

        else:
            self.__cost[(destination, source)] = value

    def degree(self, vertex):
        """
        Returns the in degree of a vertex.
        :param vertex: integer
        """

        if not self.isVertex(vertex):
            raise UndirectedGraphException("Vertex doesn't exist.")
        return len(self.__in[vertex])

    def bounds(self, vertex):
        """
        Returns a list of the inbounds neighbours of a vertex.
        :param vertex: integer
        """

        if not self.isVertex(vertex):
            raise UndirectedGraphException("Vertex doesn't exist.")
        return deepcopy(list(self.__in[vertex]))

    @property
    def vertices(self):
        """
        Returns a list with the vertices.
        """

        return deepcopy(list(self.__in.keys()))

    @property
    def edges(self):
        """
        Returns a list with the edges.
        """

        return deepcopy(list(self.__cost.keys()))

    def numberOfVertices(self):
        """
        Returns the number of vertices in the graph.
        """

        return len(self.__in)

    def numberOfEdges(self):
        """
        Returns the number of edges in the graph.
        """

        return len(self.__cost)

    def clear(self):
        """
        Clears the graph.
        """

        self.__in.clear()
        self.__cost.clear()

    def __str__(self):
        string = str(self.numberOfVertices()) + ' ' + str(self.numberOfEdges()) + '\n'

        for edge in self.__cost.keys():
            string += str(edge) + ' ' + str(self.__cost[edge]) + '\n'
        return string

    def prim(self):
        """
        """

        prev = {}
        dist = dict()
        queue = []
        source = choice(list(self.__in.keys()))
        vertices = [source]
        edges = []

        for bound in self.bounds(source):
            dist[bound] = self.getCost(source, bound)
            prev[bound] = source
            queue.append((dist[bound], bound))

        while len(queue):
            vertex = heappop(queue)[1]

            if vertex not in vertices:
                vertices.append(vertex)
                edges.append([vertex, prev[vertex]])

                for bound in self.bounds(vertex):

                    if bound not in dist.keys() or self.getCost(vertex, bound) < dist[bound]:
                        dist[bound] = self.getCost(vertex, bound)
                        heappush(queue, (dist[bound], bound))
                        prev[bound] = vertex

        return vertices, edges


def read_graph_from_file(file_path):
    """
    Reads a graph from a file and creates it
    :param file_path: path to a file
    :return: created graph
    :exception: FileNotFoundError if file was not found
    """
    try:
        with open(file_path, 'r') as file:
            graph = UndirectedGraph()
            line = file.readline().split()
            num_vertices, num_edges = int(line[0].strip()), int(line[1].strip())
            for vertex in range(num_vertices):
                graph.addVertex(vertex)
            for _ in range(num_edges):
                line = file.readline().split()
                source, target, cost = int(line[0].strip()), int(line[1].strip()), int(line[2].strip())
                graph.addEdge(source, target, cost)
            return graph
    except FileNotFoundError:
        print(f"{file_path} not found!")


def write_graph_to_file(graph, file_path):
    """
    Writes a graph to a file
    :param graph: directed graph (instance of DirectedGraph class)
    :param file_path: path to a file
    :exception: FileNotFoundError if file was not found
    """
    if not isinstance(graph, UndirectedGraph):
        raise Exception(f"{graph} is not a directed graph")

    try:
        with open(file_path, 'w') as file:
            num_vertices, num_edges = graph.numberOfVertices(), graph.numberOfEdges()
            file.write(f"{num_vertices} {num_edges}\n")
            for edge in graph.edges:
                source, target, cost = edge[0], edge[1], graph.getCost(edge[0], edge[1])
                file.write(f"{source} {target} {cost}\n")
    except FileNotFoundError:
        print(f"{file_path} not found!")


def generate_rand_graph(num_vertices, num_edges):
    """
    Generates a random graph with `num_vertices` vertices and `num_edges` edges
    :param num_vertices: number of vertices (integer)
    :param num_edges: number of edges (integer)
    :return: the generated graph
    """
    max_num_edges = num_vertices * num_vertices
    if num_edges > max_num_edges:
        num_edges = max_num_edges

    graph = UndirectedGraph()
    for vertex in range(num_vertices):
        graph.addVertex(vertex)
    while num_edges != 0:
        source = randint(0, graph.numberOfVertices() - 1)
        target = randint(0, graph.numberOfVertices() - 1)
        if not graph.isEdge(source, target):
            cost = randint(1, 100000)
            graph.addEdge(source, target, cost)
            num_edges -= 1
    return graph
