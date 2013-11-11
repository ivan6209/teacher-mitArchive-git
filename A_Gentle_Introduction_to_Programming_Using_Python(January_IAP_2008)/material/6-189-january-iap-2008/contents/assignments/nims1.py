#
# Mihir Kedia
# Homework 3 - Nim
#
# Notes: This program will crash if someone enters a non-integer at the prompt.
#        We haven't learned how to fix this yet.
#

print '    ____...----....'
print '   |""--..__...------._'
print '   `""--..__|.__       `.'
print '       |        `\      |'
print '       |          |     |'
print '      /           |     |'
print '   __\'           /      |'
print ' ,\'  ""--..__ ,-\'       |'
print '|""--..__   ,\'          |'
print '|        ""|            |'
print '|  ;  ,    |            |'
print '|     \'    |            |"'
print '|          |            |.-.___'
print '|          |            |      "---(='
print '|__        |        __..\''
print '   ""--..__|__..--""'
print
print "Welcome to Nim!"
print
print "The rules of this game are simple. You start with a pile of stones.", \
      "Each player takes turns removing between 1 and 5 stones from the pile.", \
      "The player who removes the last stone wins!"
print
print

#get a valid initial pile size
pile_size = int(raw_input("How many stones would you like to start with?\n"))
while pile_size <= 0:
  pile_size = int(raw_input("You need to start with at least one stone in the pile!\n"))

#2 players; player 1 and player 2. Start with player 1
player = 1

#main game loop
while pile_size > 0:
  prompt = "Player " + str(player) + ", there are " + str(pile_size) + " stones in front of you. " + \
           "How many stones would you like to remove (1-5)?\n"
  move = int(raw_input(prompt))
  if move <= 0:
    print "Hey! You have to remove at least one stone!"
  elif move > pile_size:
    print "There aren't even that many stones in the pile..."
  elif move > 5:
    print "You can't remove more than five stones."
  else:
    #if we're here, they gave a valid move
    pile_size = pile_size - move
    player = 2-(player-1) #this is kind of cute: changes 1 to 2 and 2 to 1.

#If we've exited the loop, the pile size is 0. The player whose turn it is NOW just lost the game..
print "Player", 2-(player-1), "has won the game!"
