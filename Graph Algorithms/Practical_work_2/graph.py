import random
from copy import deepcopy

from exceptions import GraphException


def readFromFile(filePath):
    f = open(filePath, 'r')
    n, m = f.readline().split(" ")
    graph = Graph()

    for i in range(int(n)):
        graph.addVertex(i)

    for i in range(int(m)):
        vertex1, vertex2, cost = f.readline().strip().split(" ")
        graph.addEdge(int(vertex1), int(vertex2), int(cost))

    f.close()

    return graph

def writeToFile(graph, filePath):
    f = open(filePath, 'w')
    f.write("{0} {1}\n".format(graph.numberOfVertices(), graph.numberOfEdges()))
    for vertex1 in graph.vertices():
        for vertex2 in graph.neighbours(vertex1):
            if graph.isEdge(vertex1, vertex2):
                f.write("{0} {1} {2}\n".format(vertex1, vertex2, graph.getCostOfEdge(vertex1, vertex2)))

    f.close()

def buildGraphRandom(n, m):
    g = Graph()
    for x in range(n):
        g.addVertex(x)
    while m > 0:
        x = random.randrange(n)
        y = random.randrange(n)
        cost = random.randrange((100000))
        if not g.isEdge(x, y)  and x != y:
            g.addEdge(x, y, cost)
            m = m - 1
    return g

class Graph:
    def __init__(self):
        self.__neighbours = dict()
        self.__cost = dict()

    def addVertex(self, vertex):
        if vertex not in self.__neighbours:
            self.__neighbours[vertex] = []
        else:
            raise GraphException("Vertex already exists!")

    def removeVertex(self, vertex):
        """
        Function remove a vertex from the graph and all its appearances
        """
        self.__neighbours.pop(vertex)
        for v in self.__neighbours:
            if vertex in self.__neighbours[v]:
                self.__neighbours[v].pop(self.__neighbours[v].index(vertex))
            if (int(v), vertex) in self.__cost:
                self.__cost.pop((int(v), vertex))
            if (vertex, int(v)) in self.__cost:
                self.__cost.pop((vertex, int(v)))

    def addEdge(self, vertex1, vertex2, cost):
        """
            Function adds an edge to the graph
        """
        if vertex1 == vertex2:
            raise GraphException("No loops.")
        if vertex1 not in self.__neighbours or vertex2 not in self.__neighbours:
            raise GraphException("Vertex does not exist!")
        if vertex2 in self.__neighbours[vertex1] or vertex1 in self.__neighbours[vertex2]:
            raise GraphException("Edge already exists!")
        self.__neighbours[vertex1].append(vertex2)
        self.__neighbours[vertex2].append(vertex1)
        self.__cost[(vertex1, vertex2)] = cost

    def removeEdge(self, vertex1, vertex2):
        """
            Function removes an edge from the graph
        """
        if self.isEdge(vertex1, vertex2) or self.isEdge(vertex2, vertex1):
            if (int(v), vertex) in self.__cost:
                self.__cost.pop((int(v), vertex))
            if (vertex, int(v)) in self.__cost:
                self.__cost.pop((vertex, int(v)))
            self.__neighbours[vertex2].pop(self.__neighbours[vertex2].index(vertex1))
            self.__neighbours[vertex1].pop(self.__neighbours[vertex1].index(vertex2))
        else:
            raise GraphException("Edge does not exist!")

    def setCost(self, vertex1, vertex2, newCost):
        """
            Function sets a new cost for an existing edge
        """
        if self.isEdge(vertex1, vertex2) :
            self.__cost[(vertex1, vertex2)] = newCost
        elif self.isEdge(vertex1, vertex1):
            self.__cost[(vertex2, vertex1)] = newCost
        else:
            raise GraphException("Edge does not exist!")

    def vertices(self):
        """
            Function returns a list containing all the vertices of the graph
        """
        listVertices = []
        for vertex in self.verticesIterator():
            listVertices.append(vertex)
        return listVertices

    def edges(self):
        """
            Function returns a list containing al the edges of the graph
        """
        listEdges = []
        for edge in self.edgesIterator():
            listEdges.append(edge)
        return listEdges

    def isVertex(self, vertex):
        """
            Function returns true if a vertex is in the graph and false otherwise
        """
        return vertex in self.__neighbours

    def isEdge(self, x, y):
        """
            Function returns true if an edge is in the graph and false otherwise
        """
        if (x, y) in self.__cost or (y, x) in self.__cost:
            return True

    def neighbours(self, vertex):
        """
            Function returns a list containing all the outbound neighbours of an vertex
        """
        listN = []
        for v in self.neighboursIterator(vertex):
            listN.append(v)
        return listN

    def numberOfVertices(self):
        """
             Function returns the number of vertices of the graph
        """
        return len(self.__neighbours)

    def numberOfEdges(self):
        """
            Function returns the number of edges of the graph
        """
        return len(self.__cost)

    def getCostOfEdge(self, vertex1, vertex2):
        """
            Function returns the cost of an edge
        """
        if (vertex1, vertex2) in self.__cost:
            return self.__cost[(vertex1, vertex2)]
        elif (vertex2, vertex1) in self.__cost:
            return self.__cost[(vertex2, vertex1)]
        else:
            raise GraphException("Edge does not exist!")

    def verticesIterator(self):
        """
        Returns an iterator to the list of vertices
        """
        for vertex in self.__neighbours:
            yield vertex

    def edgesIterator(self):
        """
            Returns an iterator to the list of edges
        """
        for key, cost in self.__cost.items():
            yield key[0], key[1], cost

    def neighboursIterator(self, x):
        """
            Returns an iterator to the list of outbound neighbours of a vertex
        """
        if self.isVertex(x):
            for vertex in self.__neighbours[x]:
                yield vertex

    def copy(self):
        """
            Returns a deep copy of the graph
        """
        return deepcopy(self)

    def getDegree(self, vertex):
        """
        Returns the out degree of a vertex.
        """
        return len(self.__neighbours[vertex])

    def connectedComponents(self):
        '''Parses the accessible vertices in a Breadth First Search traversal starting from start_vertex.
        Returns a dictionary where the keys are the vertices accessible from start_vertex and
        the values are the distances from start_vertex to each of them.
        '''
        used = []
        components_v = []
        for vertex in self.__neighbours.keys():
            if vertex not in used:
                distances = {vertex: 0}
                queue = [vertex]
                while queue != []:
                    current_vertex = queue.pop(0)
                    for vertex_ in self.neighbours(current_vertex):
                        if not vertex_ in distances:
                            queue.append(vertex_)
                            distances[vertex_] = distances[current_vertex] + 1
                    if current_vertex not in used:
                        used.append(current_vertex)
                components_v.append(list(distances.keys()))
        components = []
        for vl in components_v:
            graph = Graph();
            for vertex in vl:
                graph.addVertex(vertex)
            for vertex_ in self.__neighbours.keys():
                if graph.isVertex(vertex_):
                    for vertex__ in self.__neighbours[vertex_]:
                        if not graph.isEdge(vertex_, vertex__):
                            graph.addEdge(vertex_, vertex__, self.getCostOfEdge(vertex_, vertex__))
            components.append(graph)
        return components


    def __str__(self):
        string = str(self.numberOfVertices()) + ' ' + str(self.numberOfEdges()) + '\n'

        for edge in self.edgesIterator():
            string = string + str(edge) + '\n'
        return string
