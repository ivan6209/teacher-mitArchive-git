# htmltext.py
# An HTML parser that captures *only* the text of the HTML.
#
# Author: Aseem Kishore
#
# No license -- free to use. Just give credit where it's due please. =)


from sgmllib import SGMLParser
from string import *


class HtmlTextParser(SGMLParser):
    
    """ An HTML parser that captures *only* the text of the HTML. """

    ## Constructor ##

    def __init__(self):
        """ Initialize a new HtmlTextParser. """
        SGMLParser.__init__(self)
        self.text_list = []
        self.inside_unwanted_tags = 0   # how many unwanted tags we're inside

    ## Public methods ##

    def parse(self, html):
        """ Parse the given html. """
        assert type(html) is str,\
               "html must be a string, " + str(type(html)) + " given."
        self.feed(html)
        self.close()

    def get_text(self):
        """ Return the text that has been parsed so far. """
        return join(self.text_list)

    ## Overridden methods ##

    def start_script(self, attributes):
        """ Process a <script> tag and its attributes. Only used internally. """
        self.inside_unwanted_tags += 1

    def end_script(self):
        """ End a <script> tag. Only used internally. """
        self.inside_unwanted_tags -= 1

    def start_style(self, attributes):
        """ Process a <style> tag and its attributes. Only used internally. """
        self.inside_unwanted_tags += 1

    def end_style(self):
        """ End a <style> tag. Only used internally. """
        self.inside_unwanted_tags -= 1

    def start_img(self, attributes):
        """ Process an <img> tag and its attributes. Only used internally. """
        for name, value in attributes:
            if name == "alt":   # we want to capture the alt text of imgs
                data = value.strip()
                if data != "":
                    self.text_list.append(data)

    def end_img(self):
        """ End an <img> tag. Only used internally. """
        pass    # doing nothing

    def handle_data(self, data):
        """ Handle the given textual data. Only used internally. """
        # we don't want to read data inside tags like <script> and <style>
        if self.inside_unwanted_tags > 0:
            return
        # we're going to strip the data first of leading/trailing spaces, and
        # only add it if the result is not the empty string
        data = data.strip()
        if data != "":
            self.text_list.append(data)
    

## Testing ##

def _test(url):     # the _ means private to this module -- won't get imported

    print "Processing", url, ". . ."
    print

    site = urlopen(url)
    html = site.read()
    site.close()

    parser = HtmlTextParser()
    parser.parse(html)
    text = parser.get_text()
    
    print text
    print

    return text

if __name__ == "__main__":      # only do this if we're not being imported
    
    from urllib import urlopen

    t1 = _test("http://www.mit.edu/~mihirk/6.189/")
    t2 = _test("http://web.mit.edu/")
    t3 = _test("http://www.google.com/")
