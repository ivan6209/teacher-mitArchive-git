# 6.189 Lecture 4
# string_examples.py

# Strings 

# Define a string
new_string = "Hi Class!"
# Remember we can iterate through it
for letter in new_string:
    print letter

# We can concatenate two strings together
s1 = "Hi"
s2 = "Class"
print s1 + s2

# but remember, gluing together with a comma adds an extra space
print s1, s2

# and with a comma you can glue together different data types
print s1, 6.189, s2

# We can index the string 
print "new_string[0] is", new_string[0]
# And slice it
print "new_string[0:3] is", new_string[0:3]

# We can get the length of our string using the len function
print "len(new_string) is:", len(new_string)

# And use various string methods on it
print "new_string.upper()", new_string.upper()
print "new_string.lower()", new_string.lower()

# Check the Python documentation for more string methods!
