# login.py
# Example solution for Lab 4, problem 1
#
# Aseem Kishore
#
# 6.189 - Intro to Python
# IAP 2008 - Class 3


# Some constants...

LARGE_PRIME = 541
_KEY = 171  # to get this number, I used the password "solution"
MAX_FAILURES = 3    # stop when we hit this many failures


# The encrypt function. Remember, functions shouldn't be asking for input or
# printing their result. Any input a function needs (in this case, a string to
# encrypt) should be passed in, and the output should be returned.

def encrypt(text):
    return hash(text) % LARGE_PRIME


# Main program code

num_failures = 0

# We'll keep looping until we hit the max number of failures...
# We need to break out of the loop when we get it correct also, see below.

while num_failures < MAX_FAILURES:

    login = raw_input("Please enter the password: ")

    if encrypt(login) == _KEY:
        print "Correct!"
        break   # remember, this breaks out of the current loop
    else:
        num_failures = num_failures + 1
        print "Incorrect! You have failed", num_failures, "times."

# When we get here, it's either because num_failures == MAX_FAILURES, or
# because we hit the break statement (i.e. we got the correct login), so...

if num_failures >= MAX_FAILURES:
    print "Sorry, you have hit the maximum number of failures allowed."
