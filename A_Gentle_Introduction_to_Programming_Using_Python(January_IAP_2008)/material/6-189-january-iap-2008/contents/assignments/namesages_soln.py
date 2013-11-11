# namesages.py
# Stub file for lab 9, problem 1
#
# 6.189 - Intro to Python
# IAP 2008 - Class 8


NAMES = ["Alice", "Bob", "Cathy", "Dan", "Ed", "Frank",
         "Gary", "Helen", "Irene", "Jack", "Kelly", "Larry"]
AGES = [20, 21, 18, 18, 19, 20, 20, 19, 19, 19, 22, 19]


# Put code here that will combine these lists into a dictionary

ages_to_names = {}

for i in range(len(NAMES)):
    name = NAMES[i]
    age = AGES[i]
    if age in ages_to_names:
        ages_to_names[age].append(name)
    else:
        ages_to_names[age] = [name] # the LIST containing the name


# You can rename this function

def people(age):
    """ Return the names of all the people who are the given age. """
    if age in ages_to_names:
        return ages_to_names[age]
    return []


# Testing

print people(18) == ["Cathy", "Dan"]
print people(19) == ["Ed", "Helen", "Irene", "Jack", "Larry"]
print people(20) == ["Alice", "Frank", "Gary"]
print people(21) == ["Bob"]
print people(22) == ["Kelly"]
print people(23) == []
