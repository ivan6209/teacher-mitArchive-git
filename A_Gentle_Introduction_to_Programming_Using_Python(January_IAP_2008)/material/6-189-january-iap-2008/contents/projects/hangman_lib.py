# hangman_lib.py
# A set of library functions for use with your Hangman game
#
# Author: Mihir Kedia
#
# The gallows image used by the print_hangman_image(..) function is
# copyrighted! If you use that function, your program MUST appropriately
# give credit to the internet artist sk. Have your program print out 
# something akin to "Art created by sk" at the beginning or end.

def print_hangman_image(mistakes = 6):
  """Prints out a gallows image for hangman. The image printed depends on
the number of mistakes (0-6)."""
  
  if mistakes <= 0:
    print''' ____________________
| .__________________|
| | / /     
| |/ /  
| | /     
| |/   
| |     
| |   
| |    
| |     
| |    
| |   
| |   
| |    
| |      
| |      
| |       
| |      
""""""""""""""""""""""""|
|"|"""""""""""""""""""|"|
| |                   | |
: :                   : : 
. .                   . .'''

  elif mistakes == 1:
    print''' ___________.._______
| .__________))______|
| | / /      ||
| |/ /       ||
| | /        ||.-''.
| |/         |/  _  \\
| |          ||  `/,|
| |          (\\\\`_.'
| |        
| |     
| |    
| |   
| |   
| |    
| |      
| |      
| |       
| |      
""""""""""""""""""""""""|
|"|"""""""""""""""""""|"|
| |                   | |
: :                   : : 
. .                   . .'''
  elif mistakes == 2:
    print''' ___________.._______
| .__________))______|
| | / /      ||
| |/ /       ||
| | /        ||.-''.
| |/         |/  _  \\
| |          ||  `/,|
| |          (\\\\`_.'
| |          -`--' 
| |          |. .|  
| |          |   |   
| |          | . |    
| |          |   |     
| |          || ||
| |      
| |      
| |       
| |      
""""""""""""""""""""""""|
|"|"""""""""""""""""""|"|
| |                   | |
: :                   : : 
. .                   . .'''
  elif mistakes == 3:
    print''' ___________.._______
| .__________))______|
| | / /      ||
| |/ /       ||
| | /        ||.-''.
| |/         |/  _  \\
| |          ||  `/,|
| |          (\\\\`_.'
| |         .-`--' 
| |        /Y . .|
| |       // |   |  
| |      //  | . |   
| |     ')   |   |     
| |          || ||
| |      
| |      
| |       
| |      
""""""""""""""""""""""""|
|"|"""""""""""""""""""|"|
| |                   | |
: :                   : : 
. .                   . .'''
  elif mistakes == 4:
    print''' ___________.._______
| .__________))______|
| | / /      ||
| |/ /       ||
| | /        ||.-''.
| |/         |/  _  \\
| |          ||  `/,|
| |          (\\\\`_.'
| |         .-`--'.
| |        /Y . . Y\\
| |       // |   | \\\\
| |      //  | . |  \\\\
| |     ')   |   |   (`
| |          || ||
| |      
| |      
| |       
| |      
""""""""""""""""""""""""|
|"|"""""""""""""""""""|"|
| |                   | |
: :                   : : 
. .                   . .'''
  elif mistakes == 5:
    print''' ___________.._______
| .__________))______|
| | / /      ||
| |/ /       ||
| | /        ||.-''.
| |/         |/  _  \\
| |          ||  `/,|
| |          (\\\\`_.'
| |         .-`--'.
| |        /Y . . Y\\
| |       // |   | \\\\
| |      //  | . |  \\\\
| |     ')   |   |   (`
| |          ||'||
| |          ||   
| |          ||   
| |          ||   
| |         / |  
""""""""""""""""""""""""|
|"|"""""""""""""""""""|"|
| |                   | |
: :                   : : 
. .                   . .'''
  else: #mistakes >= 6
    print''' ___________.._______
| .__________))______|
| | / /      ||
| |/ /       ||
| | /        ||.-''.
| |/         |/  _  \\
| |          ||  `/,|
| |          (\\\\`_.'
| |         .-`--'.
| |        /Y . . Y\\
| |       // |   | \\\\
| |      //  | . |  \\\\
| |     ')   |   |   (`
| |          ||'||
| |          || ||
| |          || ||
| |          || ||
| |         / | | \\
""""""""""|_`-' `-' |"""|
|"|"""""""\ \       '"|"|
| |        \ \        | |
: :         \ \       : : 
. .          `'       . .'''

import random
def get_random_word():
  """Returns a random word from the file word_list.txt in the same directory"""
  input_file = open('word_list.txt','r')
  word_list = [word.strip().lower() for word in input_file.readlines() if word.strip().isalpha() and len(word) > 4]
  input_file.close()
  
  return word_list[random.randint(0,len(word_list)-1)]
  
