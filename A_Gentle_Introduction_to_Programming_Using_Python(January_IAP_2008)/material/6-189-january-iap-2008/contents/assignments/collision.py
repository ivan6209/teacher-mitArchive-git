# collision.py
# Example solution for Lab 6, problem 1
#
# Aseem Kishore
#
# 6.189 - Intro to Python
# IAP 2008 - Class 4


# Imports should usually go at the top of a program instead of in the main code.

from math import *


# These helper functions let me "abstract away" the syntax of getting a ball's
# x- and y- coordinates, or its radius. This makes my code more readable and
# also helps prevent bugs where I use x instead of y, etc.

def get_x(ball):
    return ball[0]

def get_y(ball):
    return ball[1]

def get_r(ball):
    return ball[2]


# I got this function from the second day of class. We've been trying to tell
# you guys the importance of functions; here's one -- reuse. There are many
# applications for finding the distance between two points; detecting collision
# is one, so we can reuse the function. This is also why we don't ask for input
# or print our result inside the function.

def distance(x1, y1, x2, y2):
    return sqrt((x2-x1)**2 + (y2-y1)**2)


# Here is my detect collision function. Note that I'm NOT taking six variables
# like x1, y1, r1, x2, y2, r2 -- that's the purpose of combining x, y, r into a
# tuple, as every ball has an x, y and r.

def collision(ball1, ball2):
    d = distance(get_x(ball1), get_y(ball1), get_x(ball2), get_y(ball2))
    sum_of_radii = get_r(ball1) + get_r(ball2)
    return d < sum_of_radii


# My test cases

print "First test case:",

a = (0, 0, 1)
b = (3, 3, 1)

if collision(a, b):
    print "Oops, we detected a collision!"
else:
    print "Passed!"

print "Second test case:",

a = (5, 5, 2)
b = (2, 8, 3)

if collision(a, b):
    print "Passed!"
else:
    print "Oops, we didn't detect a collision!"
