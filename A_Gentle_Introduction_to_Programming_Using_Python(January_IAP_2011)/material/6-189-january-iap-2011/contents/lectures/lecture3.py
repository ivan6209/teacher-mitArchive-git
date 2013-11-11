# Sarina Canelake
# lecture3.py

base = 10
exp = 4

def hello_world():
    base = 20
    print "inside of helloworld base is", base
    # Display the string "Hello, world!"
    return "Hello, world!"

print hello_world()
print "outside of helloworld base is", base


def ret_5():
    print 5

# What is returned here?
print ret_5()


def compute_exp(base, exp):
    '''
    Computes a base raised to the power of exp
    base must be a float or int
    exp must be a float or int
    '''
    print "inside of function, base is", base
    print "inside of function, exp is:", exp
    return base**exp

print "outside of function, base is", base
print "outside of function, exp is:", exp
# Test cases
print compute_exp(5, 0)
print compute_exp(5, 3)
print compute_exp(8, 2)
