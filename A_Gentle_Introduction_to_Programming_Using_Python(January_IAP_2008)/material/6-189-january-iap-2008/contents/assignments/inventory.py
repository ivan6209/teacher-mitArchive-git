# inventory.py
# Stub file for lab 10, problem 1
#
# 6.189 - Intro to Python
# IAP 2008 - Class 8


CHEAP = "cheap"         # less than $20
MODERATE = "moderate"   # between $20 and $100
EXPENSIVE = "expensive" # more than $100


HAMMER = "hammer"
HAMMER_PRICE = 10
HAMMER_COUNT = 100

SCREW = "screw"
SCREW_PRICE = 1
SCREW_COUNT = 1000

NAIL = "nail"
NAIL_PRICE = 1
NAIL_COUNT = 1000

SCREWDRIVER = "screwdriver"
SCREWDRIVER_PRICE = 8
SCREWDRIVER_COUNT = 100

DRILL = "drill"
DRILL_PRICE = 50
DRILL_COUNT = 20

WORKBENCH = "workbench"
WORKBENCH_PRICE = 150
WORKBENCH_COUNT = 5

HANDSAW = "handsaw"
HANDSAW_PRICE = 15
HANDSAW_COUNT = 50

CHAINSAW = "chainsaw"
CHAINSAW_PRICE = 80
CHAINSAW_COUNT = 30


# You should put all of the stuff above logically into this dictionary.
# You can just put it all in right here, like shown.
# Try to use only one *variable*, called inventory here.

inventory = { # key1 : value1,      note how I can continue on the next line,
              # key2 : value2,      I don't need a backslash or anything.
              # key3 : value3
            }


def get_items(cheapness):
    """ Return a list of (item, (price, count) tuples that are the given
    cheapness. Note that the second element of the tuple is another tuple. """
    # your code here
    return []    # delete this


# Testing

cheap = get_items(CHEAP)
print type(cheap) is list
print len(cheap) == 5
print (HAMMER, (HAMMER_PRICE, HAMMER_COUNT)) in cheap
print (NAIL, (NAIL_PRICE, NAIL_COUNT)) in cheap
print (SCREW, (SCREW_PRICE, SCREW_COUNT)) in cheap
print (SCREWDRIVER, (SCREWDRIVER_PRICE, SCREWDRIVER_COUNT)) in cheap
print (HANDSAW, (HANDSAW_PRICE, HANDSAW_COUNT)) in cheap

moderate = get_items(MODERATE)
print type(moderate) is list
print len(moderate) == 2
print (DRILL, (DRILL_PRICE, DRILL_COUNT)) in moderate
print (CHAINSAW, (CHAINSAW_PRICE, CHAINSAW_COUNT)) in moderate

expensive = get_items(EXPENSIVE)
print type(expensive) is list
print len(expensive) == 1
print (WORKBENCH, (WORKBENCH_PRICE, WORKBENCH_COUNT)) in expensive
