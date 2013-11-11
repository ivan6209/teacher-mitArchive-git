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
    words = text.lower().split()
    for word in words:
        if word not in index:           # case 1: haven't seen word anywhere
            index[word] = {site:1}      #   make a new entry for the word
        elif site not in index[word]:   # case 2: haven't seen word on this site
            index[word][site] = 1       #   make a new entry for this site
        else:                           # case 3: seen this word on this site
            index[word][site] += 1      #   increment the frequency by 1

def search_single_word(word):
    """ Return a list of (site, frequency) tuples for all sites containing the
    given word, sorted by decreasing frequency. """
    if word not in index:
        return []
    L = index[word].items()
    L.sort(key = lambda pair: pair[1], reverse = True)
    return L

def search_multiple_words(words):
    """ Return a list of (site, frequency) tuples for all sites containing any
    of the given words, sorted by decreasing frequency. """
    all_sites = {}
    for word in words:
        for site, freq in search_single_word(word):
            if site not in all_sites:   # case 1: haven't included this site
                all_sites[site] = freq  #   make a new entry for site, freq
            else:                       # case 2: have included this site
                all_sites[site] += freq #   add the frequencies
    L = all_sites.items()
    L.sort(key = lambda pair: pair[1], reverse = True)
    return L

def build_index():
    """ Build the index by reading and indexing each site. """
    for site in get_sites():
        text = read_site(site)
        while text == False:
            text = read_site(site)  # keep attempting to read until successful
        index_site(site, text)
