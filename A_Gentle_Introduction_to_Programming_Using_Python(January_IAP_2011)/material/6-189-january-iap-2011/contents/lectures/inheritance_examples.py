# 6.189 Lecture 8
# inheritance_examples.py

class Computer:
    def __init__(self, color, mnftr):
        self.compu_color = color
        self.mnftr = mnftr
        self.os = ""

    def install_os(self, new_os):
        self.os = new_os

    def which_os(self):
        return self.os

c = Computer("black", "lenovo")
print c.which_os()

class Apple(Computer):
    # This class inherits from Computer because it is a Computer -
    #  it is a specialized subset of Computer.
    def __init__(self, color):
        # Inherit Computer's init method
        # So, call the init method of our superclass
        Computer.__init__(self, color, "Macintosh")
        self.ilife_installed = False

    def install_ilife(self):
        self.ilife_installed = True
    


my_computer = Apple("silver")
your_computer = Apple("white")
print my_computer.compu_color # silver
print your_computer.compu_color # white
print my_computer.mnftr # Macintosh
print your_computer.mnftr # Macintosh

my_computer.install_os("OS X")
print my_computer.os # OS X
print your_computer.os # ""

# The difference between inheritance (like the Apple class)
#  and attributes

class Desk:
    # Desk is a class that represents what Sarina has on her desk
    def __init__(self):
        # My desk has, AS AN ATTRIBUTE, a computer
        self.my_computer = Computer("black", "lenovo")
        self.my_computer.install_os("Ubuntu")
        # My desk is NOT a computer, so we do not use inheritance here
