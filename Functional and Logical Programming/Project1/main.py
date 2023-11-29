class Node:
    def __init__(self, element):
        self.element = element
        self.next = None


class List:
    def __init__(self):
        self.head = None


def make_list(nbs):
    l = List()
    l.head = make_list_rec(nbs)
    return l


def make_list_rec(l):

    if len(l) == 0:
        return None
    else:
        x = l.pop(0)
        node = Node(x)
        node.next = make_list_rec(l)
        return node


def print_list(node):
    if node is not None:
        print(node.element, end=" ")
        print_list(node.next)


def substitute(node, poz, index, number):

    if index == poz:
        node.element = number
        return
    if node.next is None:
        return
    substitute(node.next, poz, index + 1, number)


def verify(head_1, head_2):
    if head_2 is None:
        return True
    if head_1.element == head_2.element:
        return False
    else:
        return verify(head_1, head_2.next)


def get_elements(head_1, head_2):

    if head_1.next is None:
        return
    secondary = head_2
    ok = verify(head_1, head_2)
    # while head_2.next is not None and ok is True:
    #     if head_1.element == head_2.element:
    #         ok = False
    #     head_2 = head_2.next
    if ok is True:
        print(head_1.element, end=' ')
    get_elements(head_1.next, secondary)


def difference_of_sets(head_1, head_2):
    get_elements(head_1, head_2)
0


def main():

    my_list_1 = [4,5,9,2,0,2]
    rec_list_1 = make_list(my_list_1)
    print_list(rec_list_1.head)
    print()

    substitute(rec_list_1.head, 3, 1, 1)
    print_list(rec_list_1.head)
    print()

    my_list_2 = [4, 1, 7, 9, 2]
    rec_list_2 = make_list(my_list_2)
    print("\nList 1:")
    print_list(rec_list_1.head)
    print("\nList 2:")
    print_list(rec_list_2.head)
    print("\nDifference:")
    difference_of_sets(rec_list_1.head, rec_list_2.head)

main()