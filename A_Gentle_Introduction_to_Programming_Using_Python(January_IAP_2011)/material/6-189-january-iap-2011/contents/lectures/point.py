# 6.189 Lecture 6
# point.py

class Point:
    # A class that represents a 2D Point

    def __init__(self, x, y):
        # Initalization method, called when we create
        #  a Point. Takes 2 arguments, x and y,
        #  that must be numbers

        # Make 2 object attributes
        self.x = x
        self.y = y

    def __str__(self):
        # The point's string method. When you print an object,
        #  the __str__ method is called
        return "A Point at coordinates " + str((self.x, self.y))

    def move_point(self, delta_x, delta_y):
        # Moves this Point delta_x units in the x-direction
        #  and delta_y units in the y direction.
        # delta_x and delta_y must be numbers.
        # Returns the new coordinates.
        self.x += delta_x
        self.y += delta_y
        return (self.x, self.y)

    def move_point_incorrect(self, delta_x, delta_y):
        # An incorrect implementation of move_point, because
        #  we do not change the _attributes_ self.x and self.y;
        #  instead, we only change a local variable x and y.

        x = self.x
        y = self.y

        x += delta_x
        y += delta_y

        return (x, y)


# Creating a Point object. What method is called?
myPoint = Point(7, 4)
# When we ask to print an object, its __str__ method is called
print "After initializing the Point:", myPoint

# We want to permanently move the point, but this method
#  does that incorrectly because it does not change the 
#  object's attribute; it only alters a local variable
print myPoint.move_point_incorrect(-1, 5)
print "After moving the Point incorrectly:", myPoint

# Moving the point permanently works now because this method
#  alters the object's attributes, which permanently changes
#  them!
print myPoint.move_point(-1, 5)
print "After moving the Point correctly:", myPoint
