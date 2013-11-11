# rps_example1.py

# This example uses a subfunction that returns a Boolean type, then
#  has the rps function call the subfunction in a conditional.

def valid_input(inp):
    '''
    A function that determines if a user's input is a valid choice
    for the Rock, Paper, Scissors game.
    inp must be a string.
    Returns a Boolean
    '''
    if inp == "paper" or inp == "rock" or inp == "scissors":
        return True
    else:
        return False

def rps(player1, player2):
    '''
    Plays a game of Rock, Paper, Scissors.
    player1, player2 must be strings - either "rock", "paper", or
      "scissors". Returns a string displaying who won the round.
    '''
    # Since valid_input returns a Boolean, we can use it like this
    # in a conditional block.
    if valid_input(player1) and valid_input(player2):
        if player1 == player2:
            return "Tie game"
        elif (player1 == "paper" and player2 == "rock") or\
             (player1 == "rock" and player2 == "scissors") or\
             (player1 == "scissors" and player2 == "paper"):
            return "player 1 wins!"
        else:
            return "player 2 wins!"

    else:
        return "Invalid input - must be 'paper', 'rock', or 'scissors'"

# Test
print rps("scissors", "paper") # player 1 should win
print rps("rock", "paper") # player 2 should win
print rps("rock", "rock") # Tie game
print rps("rock", "blurple") # Invalid input

