# webindexer1.py
# Stub file for lab 9, problem 2
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
    words = text.lower().split()
    for word in words:
        if word not in index:           # case 1: haven't seen this word ever
            index[word] = [ site ]      #   make a new list for the word
        elif site not in index:         # case 2: haven't seen word on this site
            index[word].append(site)    #   add this site to this word's list
                                        # case 3: have included site for word
                                        #   do nothing (ignore this word)

def search_single_word(word):
    """ Return a list of sites containing the given word. """
    if word not in index:
        return []
    return index[word]

def search_multiple_words(words):
    """ Return a list of sites containing any of the given words. """
    all_sites = []
    for word in words:
        sites = search_single_word(word)
        for site in sites:
            if site not in all_sites:
                all_sites.append(site)
    return all_sites

def build_index():
    """ Build the index by reading and indexing each site. """
    for site in get_sites():
        text = read_site(site)
        while text == False:
            text = read_site(site)  # keep attempting to read until successful
        index_site(site, text)
