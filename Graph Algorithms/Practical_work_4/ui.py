from undirected_graph import *
from exception import UndirectedGraphException


class UI:

    def __init__(self):
        self.__graph = UndirectedGraph()
        self.__functions = {
            '0': self.createGraph,
            '1': self.addVertex,
            '2': self.removeVertex,
            '3': self.addEdge,
            '4': self.removeEdge,
            '5': self.isVertex,
            '6': self.isEdge,
            '7': self.getCost,
            '8': self.setCost,
            '9': self.getDegree,
            '10': self.printBounds,
            '11': self.printVertices,
            '12': self.printEdges,
            '13': self.printNumberOfVertices,
            '14': self.printNumberOfEdges,
            '15': self.generateRandomGraph,
            '16': self.readfromFile,
            '17': self.writeToFile,
            '18': self.clear,
            '19': self.printGraph,
            '20': self.printPrim
        }

    def menu(self):
        print("0. create graph")
        print("1. add vertex")
        print("2. remove vertex")
        print("3. add edge")
        print("4. remove edge")
        print("5. verify if vertex")
        print("6. verify if edge")
        print("7. get cost")
        print("8. set cost")
        print("9. degree")
        print("10. bounds")
        print("11. all vertices")
        print("12. all edges")
        print("13. number of vertices")
        print("14. number of edges")
        print("15. generate random graph")
        print("16. read from file")
        print("17. write to file")
        print("18. clear")
        print("19. print graph")
        print("20. prim")

    def start(self):

        while True:

            self.menu()
            option = input("Option: ").strip()
            try:
                self.__functions[option]()
            except KeyError:
                print("Invalid option.")
            except ValueError as ve:
                print(ve)
            except UndirectedGraphException as dge:
                print(dge)

    def createGraph(self):

        self.__graph = UndirectedGraph()

    def addVertex(self):

        vertex = int(input("Vertex: ").strip())
        self.__graph.addVertex(vertex)

    def removeVertex(self):

        vertex = int(input("Vertex: ").strip())
        self.__graph.removeVertex(vertex)

    def addEdge(self):

        source = int(input("Source: ").strip())
        destination = int(input("Destination: ").strip())
        cost = int(input("Cost: ").strip())
        self.__graph.addEdge(source, destination, cost)

    def removeEdge(self):

        source = int(input("Source: ").strip())
        destination = int(input("Destination: ").strip())
        cost = int(input("Cost: ").strip())
        self.__graph.removeEdge(source, destination, cost)

    def getCost(self):

        source = int(input("Source: ").strip())
        destination = int(input("Destination: ").strip())
        print(self.__graph.getCost(source, destination))

    def setCost(self):

        source = int(input("Source: ").strip())
        destination = int(input("Destination: ").strip())
        cost = int(input("Cost: ").strip())
        self.__graph.setCost(source, destination, cost)
        print("Done")

    def isVertex(self):

        vertex = int(input("Vertex: ").strip())
        self.__graph.isVertex(vertex)

    def isEdge(self):

        source = int(input("Source: ").strip())
        destination = int(input("Destination: ").strip())
        self.__graph.isEdge(source, destination)

    def getDegree(self):

        vertex = int(input("Vertex: ").strip())
        print(self.__graph.degree(vertex))

    def printVertices(self):

        vertices = self.__graph.vertices
        for vertex in vertices:
            print(str(vertex) + " ", end="")
        print()

    def printEdges(self):

        edges = self.__graph.edges
        for edge in edges:
            print(str(edge))

    def printBounds(self):

        vertex = int(input("Vertex: ").strip())
        print(self.__graph.bounds(vertex))

    def printNumberOfVertices(self):

        print(self.__graph.numberOfVertices())

    def printNumberOfEdges(self):

        print(self.__graph.numberOfEdges())

    def clear(self):

        self.__graph.clear()

    def writeToFile(self):

        path = input("File path: ").strip()
        write_graph_to_file(self.__graph, path)
        print("Done")

    def readfromFile(self):

        path = input("File path: ").strip()
        read_graph_from_file(self.__graph, path)
        print("Done")

    def generateRandomGraph(self):

        number_vertices = int(input('Number of vertices: ').strip())
        number_edges = int(input('Number of edges: ').strip())
        self.__graph = generate_rand_graph(number_vertices, number_edges)
        print('Done')

    def printGraph(self):

        print(self.__graph)

    def printPrim(self):

        vertices, edges = self.__graph.prim()

        print("Vertices: ", end="")
        for vertex in vertices:
            print(vertex, end=" ")
        print()

        print("Edges:")
        for edge in edges:
            print(edge)
        print()
