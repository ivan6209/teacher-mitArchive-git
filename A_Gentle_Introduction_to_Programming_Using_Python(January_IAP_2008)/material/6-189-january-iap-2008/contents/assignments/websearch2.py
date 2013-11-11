# websearch2.py
# Allows the user to search the web using a solution to lab 10, problem 2.
#
# Aseem Kishore
#
# 6.189 - Intro to Python
# IAP 2008 - Class 8


from webindexer2 import *


QUIT = "QUIT"
search = ""


print "6.189 Web Search! (version 2)"
print

print "Building the index... (this may take a while)"
build_index()
print "Done!"

print
print "At any time, you may search for", ('"' + QUIT + '"'), "to quit."
print

while True:     # generally this is bad, but I'm using a break statement.
                # still not great, but the code seems cleaner with break.

    print "- " * 39
    print
    
    search = raw_input("What would you like to search for? ")
    print

    if search == QUIT:
        break
    
    sites = search_multiple_words(search.lower().split())
    n = len(sites)

    if n == 0:
        print "No sites found with the terms", ('"' + search + '".')
        print "Try a broader search."
        print
    else:
        print n, "site(s) found with the terms", ('"' + search + '":')
        print
        for site, freq in sites:
            print "(" + str(freq) + " hits)\t", site
        print

print "Thanks for searching!"
