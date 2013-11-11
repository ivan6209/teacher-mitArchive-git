# webindexer2.py
# Stub file for lab 10, problem 2
#
# 6.189 - Intro to Python
# IAP 2008 - Class 8


from urllib import urlopen
from htmltext import HtmlTextParser


FILENAME = "smallsites.txt"
index = {}


def get_sites():
    """ Return all the sites that are in FILENAME. """
    sites_file = open(FILENAME)
    sites = []
    for site in sites_file:
        sites.append("http://" + site.strip())
    return sites

def read_site(site):
    """ Attempt to read the given site. Return the text of the site if
    successful, otherwise returns False. """
    try:
        connection = urlopen(site)
        html = connection.read()
        connection.close()
    except:
        return False
    
    parser = HtmlTextParser()
    parser.parse(html)
    return parser.get_text()

def index_site(site, text):
    """ Index the given site with the given text. """
    # YOUR CODE HERE #
    pass    # delete this when you write your code

def search_single_word(word):
    """ Return a list of (site, frequency) tuples for all sites containing the
    given word, sorted by decreasing frequency. """
    # YOUR CODE HERE #
    pass    # delete this when you write your code

def search_multiple_words(words):
    """ Return a list of (site, frequency) tuples for all sites containing any
    of the given words, sorted by decreasing frequency. """
    # YOUR CODE HERE #
    pass    # delete this when you write your code

def build_index():
    """ Build the index by reading and indexing each site. """
    for site in get_sites():
        text = read_site(site)
        while text == False:
            text = read_site(site)  # keep attempting to read until successful
        index_site(site, text)
