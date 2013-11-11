# 6.189 Lecture 4
# list_examples.py

# Lists are defined by brackets

new_list = [3, 4, 5, 6]
print "new_list is:", new_list

# Just like strings, we can index & slice them
print "new_list[2] is:", new_list[2]
print "new_list[0:2] is:", new_list[0:2]

# And iterate through them:
for item in new_list:
    print item

# Lists, however, are mutable! So, if we want we can change the
# value of one element

new_list[2] = 100
print "new_list is:", new_list

# Or, add on a new element with append:
new_list.append(87)
print "new_list is:", new_list

# Or insert
new_list.insert(0, 200) # insert at position 0 the element 200
print "new_list is:", new_list

# Or even delete an element using remove
new_list.remove(100) # Write in the item that you want to remove from the list
print "new_list is:", new_list

# Lists are possibly the most useful data structure in Python!
# We'll see more about them in lab; check out the documentation on
# list methods for more cool things to do
