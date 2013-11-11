# 6.189 Lecture 3
# check_for_vowels.py

def is_a_vowel(c):
    # check if c is a vowel
    if c == 'a' or c == 'e' or c == 'i' or c == 'o' or c == 'u':
        # Return True if c is a vowel
        return True
    elif c == 'A' or c == 'E' or c == 'I' or c == 'O' or c == 'U':
        # Also return True if c is a capital vowel
        return True
    else:
        # c must not be a vowel; return False
        return False


## Testing
print is_a_vowel("u")
print is_a_vowel("E")
print is_a_vowel("x")

def only_vowels(phrase):
    # Takes a phrase, and returns a string of all the vowels
    # Initalize an empty string to hold all of the vowels
    vowel_string = ''
    for letter in phrase:
        # check if each letter is a vowel
        if is_a_vowel(letter):
            # If it's a vowel, we append the letter to the vowel string
            vowel_string = vowel_string + letter
        # if not a vowel, we don't care about it- so do nothing!

    return vowel_string
    # Code after a "return" doesn't print
    print "A line of code after the return!"

# Testing the functions
print "The vowels in the phrase 'tim the beAver' are:", only_vowels("tim the beAver")
print only_vowels("HeLlO wOrLd!!")
print only_vowels("klxn") # Expect no vowels from this one!
    
