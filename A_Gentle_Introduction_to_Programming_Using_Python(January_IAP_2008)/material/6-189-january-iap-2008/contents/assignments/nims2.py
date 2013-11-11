# nims.py
# Example solution for Lab 4, problem 2.
#
# Aseem Kishore
#
# 6.189 - Intro to Python
# IAP 2008 - Class 3


TOTAL = 100
MAX = 5

pile = TOTAL # number of stones in the pile at any given time


def is_valid(x):
    # returns True iff x is between 1 and MAX, and there's also enough stones,
    # otherwise returns False
    return (x >= 1) and (x <= MAX) and (x <= pile)


while pile > 0:

    # player 1 turn

    print "Player 1's turn. There are", pile, "stones in the pile."
    x = 0
    while not is_valid(x):
        # ask
        x = int(raw_input("Player 1, how many? "))
        # check
        if not is_valid(x):
            print "That's not valid, it has to be between 1 and 5, and",\
                  "you can't pick up more than there are in the pile."

    pile = pile - x
    if pile == 0:
        # win -- do something
        print "Congratulations, Player 1, you win!"
        break


    # player 2 turn

    print "Player 2's turn. There are", pile, "stones in the pile."
    y = 0
    while not is_valid(y):
        y = int(raw_input("Player 2, how many? "))
        if not is_valid(x):
            print "That's not valid, it has to be between 1 and 5, and",\
                  "you can't pick up more than there are in the pile."
    
    pile = pile - y
    if pile == 0:
        # win -- do something
        print "Congratulations, Player 2, you win!"
        break


print "Game over."
