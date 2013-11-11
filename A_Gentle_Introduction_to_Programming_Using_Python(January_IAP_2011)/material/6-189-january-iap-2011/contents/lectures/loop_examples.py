# 6.189 Lecture 2
# loop_examples.py

# An example of a for loop

# A string
hello_world = 'hello, world!'

# Initalize a variable to hold a count of letters
letter_count = 0

# Go through all the letters in a string
for letter in hello_world: # Remember the colon!
    # Print out the position of each letter
    print "Letter number", letter_count, "is", letter
    # And increment the counter
    letter_count = letter_count + 1 # Can also do letter_count += 1

# Finally print how many letters were in the string
print "There were", letter_count, "letters in the string", hello_world


# For loop examples using range:

# Range with 1 argument goes from 0 through n-1
#for num in range(10):
#    print num

# Range with 2 arguments goes from the first number through the last-1
#for num in range(7, 15):
#    print num

# Range with 3 arguments goes from the first number through the
#  second-1, in increments determined by the third number
#for num in range(2, 12, 2): # What happens if the 3rd number is negative?
#    print num


# A while loop example

# Initialize a counter
#count = 1
#print "Count is initially", count
# Want to keep looping until the counter is bigger than 100
#while count < 100:
#    count = count * 9
#    print "Now count is", count

# When we get here, the while loop is done - so count must be > 100
#print "the counter is", count
