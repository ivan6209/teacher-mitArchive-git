# piglatin.py
# Example solution for Lab 6, problem 2
#
# Aseem Kishore
#
# 6.189 - Intro to Python
# IAP 2008 - Class 4


VOWELS = ('a', 'e', 'i', 'o', 'u')


# Helper function that converts one word into Pig-Latin. Remember, our word is
# the function's argument, like 4 is the argument in sqrt(4). We don't need to
# know anything about the sentence from which the word came.
#
# Also, remember that strings are index-able, just like lists and tuples. But,
# they are immutable, like tuples. So when we want to append "ay" or "hay" to
# the end, we can't use append(). But, we can use the string concatenation (+)
# operator to return a new string.
#
# e.g. we can't do "a".append("b"), but we can do "a" + "b".

def convert_word(word):
    first_letter = word[0]
    if first_letter in VOWELS:  # if word starts with a vowel...
        return word + "hay"     # then keep it as it is and add hay to the end
    else:
        return word[1:] + word[0] + "ay"    # like the lab mentions, word[1:]
                                            # returns the word except word[0]


# From this function, it's easy to take a sentence and convert it to Pig-Latin.

def convert_sentence(sentence):
    list_of_words = sentence.split(' ')
    new_sentence = ""   # we'll keep concatenating words to this...
    for word in list_of_words:
        new_sentence = new_sentence + convert_word(word)    # ...like this
        new_sentence = new_sentence + " "   # but don't forget the space!
    return new_sentence


# Now, let's write the main program code, to ask the user and convert.

print "Type in a sentence, and it'll get converted to Pig-Latin!"
print "Please don't use punctuation or numbers."
print "Also, we can't handle uppercase/lowercase yet, so lowers only please!"
print

text = raw_input()  # nothing in the parentheses, because there's nothing else
                    # extra to tell the user before he is allowed to type

print
print convert_sentence(text)
