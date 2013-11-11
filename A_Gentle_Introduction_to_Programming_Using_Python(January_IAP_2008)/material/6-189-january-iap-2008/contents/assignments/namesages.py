# namesages.py
# Stub file for lab 9, problem 1
#
# 6.189 - Intro to Python
# IAP 2008 - Class 8


NAMES = ["Alice", "Bob", "Cathy", "Dan", "Ed", "Frank",
         "Gary", "Helen", "Irene", "Jack", "Kelly", "Larry"]
AGES = [20, 21, 18, 18, 19, 20, 20, 19, 19, 19, 22, 19]


# Put code here that will combine these lists into a dictionary



# You can rename this function

def people(age):
    """ Return the names of all the people who are the given age. """

    # your code here
    pass    # delete this line when you write your code


# Testing

print people(18) == ["Cathy", "Dan"]
print people(19) == ["Ed", "Helen", "Irene", "Jack", "Larry"]
print people(20) == ["Alice", "Frank", "Gary"]
print people(21) == ["Bob"]
print people(22) == ["Kelly"]
print people(23) == []
