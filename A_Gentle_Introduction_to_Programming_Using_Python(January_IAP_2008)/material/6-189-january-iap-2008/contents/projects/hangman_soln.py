# hangman_soln.py
# Example solution for Project 1: Hangman
#
# Aseem Kishore
#
# 6.189 - Intro to Python
# IAP 2008 - Class 5


from string import *
from hangman_lib import *


## Constants ##

MAX_MISTAKES = 6


## State variables ##

secret_word = get_random_word()     # from hangman_lib
letters_guessed = []    # empty list -- no letters guessed initially
mistakes_made = 0


## Helper functions ##

def word_guessed():
    """ Returns True iff the player has successfully guessed the word. """
    for letter in secret_word:  # go through each letter in the secret word...
        if letter not in letters_guessed:   # check if we've guessed it...
            return False    # if not, we haven't guessed the word!
    return True     # if we've gotten here, we've guessed every letter!

def print_guessed():
    """ Returns a string of the word with not-guessed letters as dashes. """
    list_of_letters = []    # we'll keep adding letters to this
    for letter in secret_word:  # go through each letter in the secret word...
        if letter in letters_guessed:   # check if we've guessed it...
            list_of_letters.append(letter)  # if so, add it!
        else:
            list_of_letters.append('-')     # otherwise, add a dash
    return join(list_of_letters, '')    # remember to return the string!
                                        # to conver to string, use join(...)
                                        # the second argument means no spaces
                                        # between the different letters.


## Main game code ##

# Some intro stuff...

print "Welcome to Hangman!"
print

first_time = lower(raw_input("Is this your first time playing Hangman? (y/n) "))

print

if first_time == "y":
    # it's their first time -- let's give them instructions.
    print "The objective of Hangman is to guess a secret word letter by letter."
    print "If you guess a letter in the word, we'll show you that letter."
    print "But if you guess wrong, we'll draw part of the hangman's body."
    print "Don't let his whole body get drawn, or else you lose!"
    print

print "Great, so you're ready to play. Just two things that might help:"
print "1) The secret word has", len(secret_word), "letters."
print "2) It takes", MAX_MISTAKES, "wrong guesses to lose."
print
print "Good luck!"
print
print "[Press enter when ready to play.]"
raw_input()     # this just waits for them to press enter... they can type
                # other stuff but it doesn't affect anything.

print_hangman_image(0)
print

# On to our main game loop... we can exit out of our loop either by losing
# (hitting MAX_MISTAKES), or by winning. Let's loop as long as we're under
# MAX_MISTAKES, and if we win, we'll use the break statement.

while mistakes_made < MAX_MISTAKES:

    # Each turn, let's display the hangman image, the word with dashes, the
    # letters they've guessed so far, and how many mistakes they have left.

    print
    print "The word so far: ", print_guessed()
    print "Letters guessed so far:",

    # to print the letters guessed, we'll have to loop over the list
    for letter in letters_guessed:
        print letter,

    print
    print "Wrong guesses remaining:", MAX_MISTAKES - mistakes_made
    print

    guess = lower(raw_input("What letter will you guess? "))

    # Now we'll only do one of the below actions...

    if guess == "":
        print "You have to guess something..."

    elif len(guess) > 1:
        print "You can only guess one letter at a time!"

    elif guess < "a" or guess > "z":
        print "You can only guess letters, not numbers or symbols!"

    elif guess in letters_guessed:
        print "You've already guessed this letter!"

    else:   # valid guess!
        
        letters_guessed.append(guess)  # so add to our list of guessed letters
        
        if guess in secret_word:   # check if letter is in the word...
            print "Good guess!", guess, "is in the word."
            if word_guessed():  # let's see if we've won with this guess...
                print "In fact, that's the last letter!"
                break

        else:
            mistakes_made = mistakes_made + 1
            print "Sorry, no luck.", guess, "is not in the word."
            print
            print_hangman_image(mistakes_made)
            print

# Now we're out of the main game loop. As we said above, this means either we
# guessed wrong too many times, or we won. Let's check.

print

if mistakes_made >= MAX_MISTAKES:
    print "Oh no, you guessed wrong too many times! You lose."
    print "The word was", '"' + secret_word + '".'
    print
    print "GAME OVER"
else:
    print "Congratulations... you win!"
    print "You correctly guessed the word", '"' + secret_word + '".'

print
