# 6.189 Sample Exam Solutions
# Prepared by Kat Kononov & Sarina Canelake
# January 2011

import math

###############################################
## 1.) procedure for solving quadratic equations
###############################################
# a.) code for roots function
def roots(a, b, c):
    #form of equation is a*x**2 + b*x + c = 0
    #quadratic formula is   x = (-b + sqrt(b**2 - 4 * a * c))/(2 * a)
    #                   or  x = (-b - sqrt(b**2 - 4 * a * c))/(2 * a)
    #roots are complex when the discriminant (b**2 - 4*a*c) is negative
    discriminant = b**2 - (4 * a * c)
    if discriminant < 0:
        return "Roots are complex"
    return "x = "+str((-b + math.sqrt(discriminant)) / (2 * a))+" or x = "+\
        str((-b - math.sqrt(discriminant)) / (2 * a))

# Test Cases (assertions are just to automate)
##print '\nTesting roots'
##
##print roots(1, 2, 1) #(x+1)^2: double root at x = -1
##assert roots(1, 2, 1) == 'x = -1.0 or x = -1.0'
##
##print roots(1, -2, -3) #(x+1)(x-3): roots at x = 3 or x = -1
##assert roots(1, -2, -3) == 'x = 3.0 or x = -1.0'
##
##print roots(2, 2, 2) #2x^2 + 2x + 2: complex roots
##assert roots(2, 2, 2) == 'Roots are complex'

# b.) same code, modified to handle complex roots
def roots(a, b, c):
    discriminant = b**2 - (4 * a * c)
    if discriminant < 0:
        discriminant = discriminant + 0j
    return "x = "+str((-b + discriminant**0.5) / (2 * a))+ " or x = " +\
        str((-b - discriminant**0.5) / (2 * a)) # math.sqrt does not work

# Test Cases (assertions are just to automate)
##print '\nTesting roots'
##
##print roots(1, 2, 1) #(x+1)^2: double root at x = -1
##assert roots(1, 2, 1) == 'x = -1.0 or x = -1.0'
##
##print roots(1, -2, -3) #(x+1)(x-3): roots at x = 3 or x = -1
##assert roots(1, -2, -3) == 'x = 3.0 or x = -1.0'
##
##print roots(2, 2, 2) #2x^2 + 2x + 2: complex roots
##assert roots(2, 2, 2) == 'x = (-0.5+0.866025403784j) or x = (-0.5-0.866025403784j)'

###########################################
## 2.) procedure for evaluating polynomials
###########################################
def eval_poly(x, coeffs):
    total=0 #will keep a running total of the sum
    coeffs.reverse() # to put the low order coeffs first
    for i in range(len(coeffs)):
        total+=coeffs[i]*(x**i) #add the curent term to the total
    return total

# Test cases
##print '/nTesting Polynomial'
##
##print eval_poly(1,[1,2,3])
##assert eval_poly(1,[1,2,3]) == 6
##
##print eval_poly(2,[1,2,3,4])
##assert eval_poly(2,[1,2,3,4]) == 26

###########################################
## 3.) procedure to make change
###########################################
def make_change(cost, paid):
    change=paid-cost #calculate the change due
    bills={20:0,10:0,5:0,2:0,1:0} #dictionary that maps each bill to the amount of it
    bill_list=bills.keys() #bill_list is a list of the available bills
    bill_list.sort() #sort it in ascending order
    bill_list.reverse() #now reverse it to be in descending order
                        #this is to make sure you get the smallest number of bills
    for bill in bill_list: 
        while change >=bill: 
            bills[bill]+=1 #increment the amount of that bill
            change-=bill #decrease the change by that bill
            
    print "Change is:"
    for bill in bill_list:
        if bills[bill] == 1:
            print bills[bill], bill, "dollar bill"
        elif bills[bill] > 1:
            print bills[bill], bill, "dollar bills"

    #return bills #return the dictionary with amounts of each bill needed

make_change(1, 6)
make_change(4, 109)
##########################################
## 4.) procedure for finding target words
##########################################
#a.)
def procedure(string,target):
    words=string.split(" ") #turn the string into a list of words
    result=[] #declare a list that will be returned
    for i in range(len(words)):
        if words[i]==target: result.append(i)
    if len(result)==0: return False
    return result

#test case
##string="we dont need no education we dont need no thought control no we dont"
##print procedure(string, "dont")
##assert procedure(string, "dont") == [1, 6, 13]

def inverted_index(string):
    words=string.split(" ") #turn the string into a list of words
    index={} # declare a dictionary to keep track of the words
    for i in range(len(words)):
        word=words[i]
        if word not in index:
            index[word]=[] #if the dictionary doesn't have an entry for this word, create a blank list
        index[word].append(i)
    return index

def print_nice(string, index):
    # takes a string & a dictionary that represents its inverted
    # indeex, and prints it out nicely
    non_dups = [] # Initalize a list of non-duplicate words from the string
    # Build up the list by looking through the string and adding each
    # new word we see
    for word in string.split(' '):
        if word not in non_dups:
            non_dups.append(word)
    # Now for each unique word we print out its count nicely
    for word in non_dups:
        # This makes a string representation of the list returned
        #  by index[word]
        cnt_str = ', '.join([str(cnt) for cnt in index[word]])
        print word+":", cnt_str

test_s="we dont need no education we dont need no thought control no we dont"
test_s_index = inverted_index(test_s)
print_nice(test_s, test_s_index)
