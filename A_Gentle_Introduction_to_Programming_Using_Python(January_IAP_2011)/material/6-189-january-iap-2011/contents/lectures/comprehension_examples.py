# 6.189 Lecture 4
# comprehension_examples.py

## Examples of List Comprehensions in Python

###
print "Example 1: Make a list of letters in a string"
print [letter for letter in "Hello, World!"]

###
print "\nExample 2: Add an exclamation point to every letter"
print [letter+"!" for letter in "Hello, World!"]

###
print "\nExample 3: A multiplication table for the 9's"
print [9*num for num in range(13)]

###
print "\nExample 4: Make a list of letters in a string if they're not 'o'"
print [letter for letter in "Hello, World!" if letter != 'o']
