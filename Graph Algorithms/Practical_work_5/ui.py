from directed_graph import *
from exception import DirectedGraphException


class UI:

    def __init__(self):
        self.__graph = DirectedGraph()
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
            '9': self.getInDegree,
            '10': self.getOutDegree,
            '11': self.printInbounds,
            '12': self.printOutbounds,
            '13': self.printVertices,
            '14': self.printEdges,
            '15': self.printNumberOfVertices,
            '16': self.printNumberOfEdges,
            '17': self.generateRandomGraph,
            '18': self.readfromFile,
            '19': self.writeToFile,
            '20': self.hc,
            '21': self.clear,
            '22': self.printGraph
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
        print("9. in degree")
        print("10. out degree")
        print("11. inbounds")
        print("12. outbounds")
        print("13. all vertices")
        print("14. all edges")
        print("15. number of vertices")
        print("16. number of edges")
        print("17. generate random graph")
        print("18. read from file")
        print("19. write to file")
        print("20. find lowest hamiltonian cycle")
        print("21. clear")
        print("22. print graph")

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
            except DirectedGraphException as dge:
                print(dge)

    def createGraph(self):

        self.__graph = DirectedGraph()

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
        self.__graph.removeEdge(source, destination)

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

    def getInDegree(self):

        vertex = int(input("Vertex: ").strip())
        print(self.__graph.inDegree(vertex))

    def getOutDegree(self):

        vertex = int(input("Vertex: ").strip())
        print(self.__graph.outDegree(vertex))

    def printVertices(self):

        vertices = self.__graph.vertices
        for vertex in vertices:
            print(str(vertex) + " ", end="")
        print()

    def printEdges(self):

        edges = self.__graph.edges
        for edge in edges:
            print(str(edge))

    def printInbounds(self):

        vertex = int(input("Vertex: ").strip())
        print(self.__graph.inbounds(vertex))

    def printOutbounds(self):

        vertex = int(input("Vertex: ").strip())
        print(self.__graph.outbounds(vertex))

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
        self.__graph = read_graph_from_file(path)
        print("Done")

    def generateRandomGraph(self):

        number_vertices = int(input('Number of vertices: ').strip())
        number_edges = int(input('Number of edges: ').strip())
        self.__graph = generate_rand_graph(number_vertices, number_edges)
        print('Done')

    def hc(self):

        source = int(input("Source: ").strip())
        vertices = self.__graph.hc(source)

        print("Path:  ", end="")
        for vertex in vertices[:-1]:
            print(str(vertex) + "->", end="")
        print(str(source))

    def printGraph(self):

        print(self.__graph)
