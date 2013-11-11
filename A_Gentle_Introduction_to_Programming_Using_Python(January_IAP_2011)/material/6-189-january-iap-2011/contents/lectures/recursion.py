# Solutions -- Optional Recursion Exercises
# recursion.py
# Jan 14, 2011  

# 1. 
def RecMult(num_1, num_2):
    """Takes in two numbers nonnegative and recursively multiplies them together."""
    if num_1 == 1:  # Base case.
        return num_2
    elif num_1 == 0: # Deal with input case 0.
        return 0
    else:
        return num_2 + RecMult(num_1 - 1, num_2) # Recursive case.

# Tests
assert RecMult(0,5) == 0
assert RecMult(5,4) == 20
assert RecMult(3,0) == 0

# 2. 
def RecExpo(base, exp):
    """Recursively computes base^exp for nonnegative exponents."""
    if exp == 0:
        return 1
    else: 
        return base * RecExpo(base, exp - 1)

# Tests                                                                                                                                      
assert RecExpo(0,5) == 0
assert RecExpo(2,4) == 16
assert RecExpo(3,0) == 1

# 3.
def RecCountdown(n):
    """Prints the numbers from n to 0."""
    if n == 0:
        return 0
    elif n < 0:
        print n
        return RecCountdown(n + 1)
    else:
        print n
        return RecCountdown(n - 1)

# Tests
print RecCountdown(5)
print RecCountdown(0)
print RecCountdown(-2)


# 4.
def RecCountup(n, j):
    """Counts up to n from 0."""
    if j == n:
        return n
    elif n < 0:
        print j
        return RecCountup(n, j - 1)
    else:
        print j
        return RecCountup(n, j + 1)
# Tests
print RecCountup(5, 0)
print RecCountup(0, 0)
print RecCountup(-2, 0)


# 5.
def RecReverseString(input):
    """Reverse the input string using recursion."""
    if len(input) == 0:
        return ""
    else:
        return input[-1] + RecReverseString(input[:-1])

# Tests
assert RecReverseString("Sarina") == "aniraS"
assert RecReverseString("") == ""
assert RecReverseString("A") == "A"


# 6.
def RecIsPrime(m):
    """Uses recursion to check if m is prime."""
    def PrimeHelper(m, j):
        """Helper Function to iterate through all j less than m up to 1 to look for even divisors."""
        if j == 1:  # Assume 1 is a prime number even though it's debatable.
            return True
        else:
            return m % j != 0 and PrimeHelper(m, j - 1)
    return PrimeHelper(m, m -1)

# Tests
assert RecIsPrime(5)
assert not RecIsPrime(6)

# 7.
def RecFib(n):
    """Returns the nth Fibonacci number."""
    if n == 0:
        return 0
    elif n == 1:
        return 1
    else:
        return RecFib(n - 1) + RecFib(n - 2)

assert RecFib(3) == 2
assert RecFib(4) == 3
