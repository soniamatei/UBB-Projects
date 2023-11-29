from exceptions import GraphException
from graph import buildGraphRandom, Graph, readFromFile, writeToFile


class UI:
    def __init__(self):
        self.__graph = None
        self.__copyGraph = None
        self.__commands = {"2": self.addVertex, "3": self.removeVertex, "4": self.addEdge, "5": self.removeEdge,
                           "6": self.getNumberOfVertices, "7":self.updateCost, "8": self.checkEdge, "9": self.getDegree,
                            "11": self.printVertices, "12": self.printGraph, "13":self.printCost,
                            "14": self.printNeighbours,
                           "16": self.writeFile, "17": self.numberOfEdges,
                           "18": self.connectedComponents}
        self.__createCommands = {"1": self.createGraph, "10": self.createRandomGraph, "14": self.readFile,}

    def printMenu(self):
        print("1 -> Create a graph")
        print("2 -> Add a vertex")
        print("3 -> Remove a vertex")
        print("4 -> Add an edge")
        print("5 -> Remove an edge")
        print("6 -> Get number of vertices")
        print("7 -> Change cost of an edge")
        print("8 -> Check if edge exists")
        print("9 -> Get degree of vertex")
        print("10 -> Create random graph")
        print("11 -> Print vertices")
        print("12 -> Print graph")
        print("13 -> Print cost of an edge")
        print("14 -> Print neighbours of vertex")
        print("15 -> Read graph from file")
        print("16 -> Write graph to file")
        print("17 -> Print number of edges")
        print("18 -> Print connected components")

    def start(self):
        while True:
            self.printMenu()
            print("Command: ", end='')
            command = input().strip()
            try:
                if command in self.__commands and self.__graph != None:
                    self.__commands[command]()
                elif command in self.__createCommands:
                    self.__createCommands[command]()
                elif command == '0':
                    return
                else:
                    print("Invalid command")
            except GraphException as ge:
                print("error - ", str(ge))

    def addVertex(self):
        print("Write vertex number: ", end='')
        vertex = input().strip()
        if not vertex.isdigit():
            raise GraphException("Vertex must be a number!")
        self.__graph.addVertex(int(vertex))

    def createGraph(self):
        print("Number of vertices: ", end='')
        numberOfVertices = input().strip()
        if not numberOfVertices.isdigit():
            raise GraphException("Not a number!")
        self.__graph = Graph()
        for i in range(0, int(numberOfVertices)):
            self.__graph.addVertex(i)

    def getNumberOfVertices(self):
        print(self.__graph.numberOfVertices())

    def updateCost(self):
        print("Specify the edges vertices!")
        vertex1, vertex2 = self.readVertices()
        newCost = self.readNumber("Write new cost : ")
        self.__graph.setCost(vertex1, vertex2, newCost)

    def printCost(self):
        print("Specify the edges vertices!")
        vertex1, vertex2 = self.readVertices()
        print(self.__graph.getCostOfEdge(vertex1, vertex2))

    def removeVertex(self):
        vertex = self.readNumber("Write vertex name:")
        if int(vertex) not in self.__graph.vertices():
            print("Vertex does not exist")
            return
        self.__graph.removeVertex(int(vertex))

    def removeEdge(self):
        vertex1, vertex2 = self.readVertices()
        self.__graph.removeEdge(int(vertex1), int(vertex2))

    def addEdge(self):
        vertex1, vertex2 = self.readVertices()
        cost = self.readNumber("Write edge cost: ")
        self.__graph.addEdge(int(vertex1), int(vertex2), int(cost))

    def printVertices(self):
        print(self.__graph.vertices())

    def printGraph(self):
        print(self.__graph)

    def createRandomGraph(self):
        n = self.readNumber("Write number of vertices: ")
        m = self.readNumber("Write number of edges: ")
        self.__graph = buildGraphRandom(int(n), int(m))

    def checkEdge(self):
        vertex1, vertex2 = self.readVertices()
        if self.__graph.isEdge(vertex1, vertex2):
            print("There is an edge from ", vertex1, " to ", vertex2)
        else:
            print("There is no edge from ", vertex1, " to ", vertex2)

    def getDegree(self):
        vertex = self.readNumber("Write vertex number: ")
        print("The in degree of the vertex ", vertex, " is ", self.__graph.getDegree(int(vertex)))

    def printNeighbours(self):
        vertex = self.readNumber("Write vertex number: ")
        if self.__graph.isVertex(vertex):
            print("The outbound neighbours of the vertex ", vertex, " are ", self.__graph.neighbours(int(vertex)))
        else:
            print("Vertex does not exist")

    def readFile(self):
        print("Write file path/name: ", end='')
        filePath = input()
        self.__graph = readFromFile(filePath)

    def writeFile(self):
        print("Write file path/name: ", end='')
        filePath = input()
        writeToFile(self.__graph, filePath)

    def readVertices(self):
        print("Write first vertex: ", end='')
        vertex1 = input().strip()
        if not vertex1.isdigit():
            raise GraphException("Value must be a number!")
        print("Write second vertex: ", end='')
        vertex2 = input().strip()
        if not vertex2.isdigit():
            raise GraphException("Value must be a number!")
        return int(vertex1), int(vertex2)

    def readNumber(self, message):
        print(message, end='')
        number = input().strip()
        if not number.isdigit():
            raise GraphException("Value must be a number!")
        return int(number)

    def numberOfEdges(self):
        print(self.__graph.numberOfEdges())

    def connectedComponents(self):
        list = self.__graph.connectedComponents()
        count = 1
        for gr in list:
            print("Component " + str(count))
            print(gr)
            count+=1