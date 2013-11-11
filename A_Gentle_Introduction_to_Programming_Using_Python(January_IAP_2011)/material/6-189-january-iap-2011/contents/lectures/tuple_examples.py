# 6.189 Lecture 5
# tuple_examples.py

# Tuples are immutable and defined by parentheses

new_tuple = (5, 6, 7, 8)
print "new_tuple is:", new_tuple

# We can index them, just like strings
print "new_tuple[2] is:", new_tuple[2]

# And iterate through them:
for item in new_tuple:
    print item

# Even show how long they are
print "Tuple length is:", len(new_tuple)

# and iterate through indicies

for index in range(len(new_tuple)):
    print "Index is:", index
    print "Value at that index is:", new_tuple[index]

# But because they are immutable, we cannot redefine
#  a single element (remember this does work with lists, though)
#new_tuple[1] = 77 # Returns an error


# We can also do something called _tuple unpacking_

(a, b, c, d) = new_tuple
print "a is:", a
print "b is:", b
print "c is:", c
print "d is:", d

# Make sure that you always have the same number of
# variables when you unpack a tuple!

# Tuples are immutable. To change a tuple, we would need
# to first unpack it, change the values, then repack it:

# Redefine b
b = 77

# Repack the tuple
new_tuple = (a, b, c, d)
print "new_tuple is now:", new_tuple
