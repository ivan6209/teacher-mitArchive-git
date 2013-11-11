# reportcard.py
# Example solution for Lab 5, problem 2
#
# Aseem Kishore
#
# 6.189 - Intro to Python
# IAP 2008 - Class 4


# Helper function that takes a list of grades and returns the GPA.
# Remember that average (mean) is the sum divided by the number of grades.
# Just like in math, you sum first, THEN divide -- order of operations.
# Don't make the mistake of dividing inside the loop!

def calculate_gpa(grades):
    running_sum = 0
    for grade in grades:
        running_sum = running_sum + grade
    return float(running_sum) / len(grades) # remember we want decimals, so
                                            # use float(...)


# Main program code

class_names = []
class_grades = []

number_classes = int(raw_input("How many classes did you take? "))
print   # this prints a blank line

# Now we're going to ask the same two questions over and over --> loop!
# Since we know how many times we're looping (number_classes), we use for.
# Note that we need a variable name for the "for", but we don't use it here.
# What does range return? A list of numbers, from 0 to number_classes.

for arbitrary_variable_name in range(number_classes):
    name = raw_input("What is the name of this class? ")
    grade = int(raw_input("What grade did you get? "))
    class_names.append(name)    # add the two things to our lists...
    class_grades.append(grade)
    print   # blank line

# Now we'll print the report card. The report card should look like:
# class name - grade
# Over and over again --> loop! How many of these lines? number_classes

print "Report card:"
print

for class_number in range(number_classes):
    print class_names[class_number], "-", class_grades[class_number]

print
print "Term GPA:", calculate_gpa(class_grades)
