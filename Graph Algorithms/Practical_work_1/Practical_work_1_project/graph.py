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
        for vertex2 in graph.nout(vertex1):
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
        if not g.isEdge(x, y):
            g.addEdge(x, y, cost)
            m = m - 1
    return g

class Graph:
    def __init__(self):
        self.__nout = dict()
        self.__nin = dict()
        self.__cost = dict()

    def addVertex(self, vertex):
        if vertex not in self.__nout:
            self.__nout[vertex] = []
            self.__nin[vertex] = []
        else:
            raise GraphException("Vertex already exists!")

    def removeVertex(self, vertex):
        """
        Function remove a vertex from the graph and all its appearances
        """
        self.__nout.pop(vertex)
        self.__nin.pop(vertex)
        if (vertex, vertex) in self.__cost:
            self.__cost.pop((vertex, vertex))
        for v in self.__nout:
            if vertex in self.__nout[v]:
                self.__nout[v].pop(self.__nout[v].index(vertex))
            if vertex in self.__nin[v]:
                self.__nin[v].pop(self.__nin[v].index(vertex))
            if self.isEdge(int(v), vertex):
                self.__cost.pop((int(v), vertex))
            if self.isEdge(vertex, int(v)):
                self.__cost.pop((vertex, int(v)))

    def addEdge(self, vertex1, vertex2, cost):
        """
            Function adds an edge to the graph
        """
        if vertex1 not in self.__nout or vertex2 not in self.__nout:
            raise GraphException("Vertex does not exist!")
        if vertex2 in self.__nout[vertex1]:
            raise GraphException("Edge already exists!")
        self.__nout[vertex1].append(vertex2)
        self.__nin[vertex2].append(vertex1)
        self.__cost[(vertex1, vertex2)] = cost

    def removeEdge(self, vertex1, vertex2):
        """
            Function removes an edge from the graph
        """
        if self.isEdge(vertex1, vertex2) :
            self.__cost.pop((vertex1, vertex2))
            self.__nin[vertex2].pop(self.__nin[vertex2].index(vertex1))
            self.__nout[vertex1].pop(self.__nout[vertex1].index(vertex2))
        else:
            raise GraphException("Edge does not exist!")

    def setCost(self, vertex1, vertex2, newCost):
        """
            Function sets a new cost for an existing edge
        """
        if self.isEdge(vertex1, vertex2) :
            self.__cost[(vertex1, vertex2)] = newCost
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
        return vertex in self.__nout

    def isEdge(self, x, y):
        """
            Function returns true if an edge is in the graph and false otherwise
        """
        if (x, y) in self.__cost:
            return True

    def nout(self, vertex):
        """
            Function returns a list containing all the outbound neighbours of an vertex
        """
        listN = []
        for v in self.noutIterator(vertex):
            listN.append(v)
        return listN

    def nin(self, vertex):
        """
            Function returns a list containing all the inbound neighbours of an vertex
        """
        listN = []
        for v in self.ninIterator(vertex):
            listN.append(v)
        return listN

    def numberOfVertices(self):
        """
             Function returns the number of vertices of the graph
        """
        return len(self.__nout)

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
        else:
            raise GraphException("Edge does not exist!")

    def verticesIterator(self):
        """
        Returns an iterator to the list of vertices
        """
        for vertex in self.__nout:
            yield vertex

    def edgesIterator(self):
        """
            Returns an iterator to the list of edges
        """
        for key, cost in self.__cost.items():
            yield key[0], key[1], cost

    def noutIterator(self, x):
        """
            Returns an iterator to the list of outbound neighbours of a vertex
        """
        if self.isVertex(x):
            for vertex in self.__nout[x]:
                yield vertex

    def ninIterator(self, x):
        """
            Returns an iterator to the list of inbound neighbours of a vertex
        """
        for vertex in self.__nin[x]:
            yield vertex

    def copy(self):
        """
            Returns a deep copy of the graph
        """
        return deepcopy(self)

    def getInDegree(self, vertex):
        """
        Returns the in degree of a vertex.
        """
        return len(self.__nin[vertex])

    def getOutDegree(self, vertex):
        """
        Returns the out degree of a vertex.
        """
        return len(self.__nout[vertex])

    def __str__(self):
        string = str(self.numberOfVertices()) + ' ' + str(self.numberOfEdges()) + '\n'

        for edge in self.edgesIterator():
            string = string + str(edge) + '\n'
        return string
