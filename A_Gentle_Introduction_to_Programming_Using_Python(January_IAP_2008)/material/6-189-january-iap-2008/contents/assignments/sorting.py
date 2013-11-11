# sorting.py
# Example solution for Lab 5, problem 1
#
# Aseem Kishore
#
# 6.189 - Intro to Python
# IAP 2008 - Class 4


L = []

for i in range(10):
    a = int(raw_input("Please enter a number. "))
    # DON'T do this: L[i] = a
    L.append(a)


def find_largest(L):

    maximum = 0
    index = 0

    for i in range(len(L)):
        if L[i] > maximum:
            maximum = L[i]
            index = i

    del L[index]
    return maximum


# this is fine: while len(L) > 0:
for i in range(10):
    print find_largest(L),


