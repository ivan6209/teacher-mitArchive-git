# connectfour.py
# A two-player command-line implementation of Connect Four.
#
# Author: Aseem Kishore
#
# License: None -- free to use. Just give credit where it's due please! =)


from string import lower, upper, join
from random import randint


## Constants ##

NUM_ROWS = 6
NUM_COLS = 7

ROWS = range(1, NUM_ROWS + 1)
COLS = [chr(i) for i in range(ord("A"), ord("A") + NUM_COLS)]

EMPTY = " "
PL_1 = "x"
PL_2 = "o"

NEEDED_TO_WIN = 4   # number in-a-row needed to win


## Board implementation ##

# The board is implemented as a list of columns. Each column is implemented
# as a list of tokens. The length of each of these column lists is exactly
# the number of tokens in that column. So initially, each column list is
# empty. When a token is added, we'll append that to the end of that list,
# so this means that the bottom token is always index 0.
#
# The abstract representation of the board is a grid with numbered rows and
# lettered columns. The bottom row is row 1, then row 2, etc. The position
# of a particular square is then a (row, col) tuple, so the position (1, A)
# refers to the bottom-left square.

_board = [ [] for i in range(NUM_COLS) ]    # list of 7 columns, each list
                                            # initially empty

def _assert_valid_position(position):
    assert type(position) is tuple and len(position) == 2,\
           "position must be a (row, col) tuple, %s given" % position
    _assert_valid_row(position[0])
    _assert_valid_col(position[1])

def _assert_valid_row(row):
    assert row in ROWS,\
           "row must be an integer in the range %i-%i, %s given" %\
           (ROWS[0], ROWS[-1], row)

def _assert_valid_col(col):
    assert type(col) is str and upper(col) in COLS,\
           "col must be a letter in the range %c-%c, %s given" %\
           (COLS[0], COLS[-1], col)

def _col_num(col):
    """
    Returns the column number (1, 2, ...) of the given column (A, B, ...).
    """
    return COLS.index(upper(col)) + 1

def position(row, col):
    """
    Returns the position at the given row and column.
    """
    _assert_valid_row(row)
    _assert_valid_col(col)
    return (row, col)

def row(position):
    """
    Returns the row of the given position.
    """
    _assert_valid_position(position)
    return position[0]

def col(position):
    """
    Returns the column of the given position.
    """
    _assert_valid_position(position)
    return position[1]

def get_square(position):
    """
    Returns the square (EMPTY, PL_1 or PL_2) at the given position.
    """
    _assert_valid_position(position)
    row_i = row(position) - 1
    col_i = _col_num(col(position)) - 1
    column = _board[col_i]
    if row_i >= len(column):
        return EMPTY
    return column[row_i]

def get_row(row):
    """
    Returns a list of squares (EMPTY, PL_1 or PL_2) in the given row.
    The first square is at column A, the next at column B, etc.
    """
    _assert_valid_row(row)
    row_i = row - 1
    squares = []
    for col_i in range(NUM_COLS):
        column = _board[col_i]
        if row > len(column):
            squares.append(EMPTY)
        else:
            squares.append(column[row_i])
    assert len(squares) == NUM_COLS,\
           "INTERNAL ERROR: squares should be %i long, %i long instead" %\
           (NUM_COLS, len(squares))
    return squares

def get_column(col):
    """
    Returns a list of squares (EMPTY, PL_1 or PL_2) in the given column.
    The first square is at row 1, the next at row 2, etc.
    """
    _assert_valid_col(col)
    col_i = _col_num(col) - 1
    squares = list(_board[col_i])
    while len(squares) < NUM_ROWS:
        squares.append(EMPTY)
    return squares

def get_diagonal_TL_to_BR(tl_position):
    """
    Returns the top-left to bottom-right diagonal that begins at the given
    top-left position (meaning a position on the top or left edges).
    """
    _assert_valid_position(tl_position)
    assert row(tl_position) == ROWS[-1] or col(tl_position) == COLS[0],\
           ("tl_position must be on the top (row %i) or left (col %c)" +\
           " edges, %s given") % (ROWS[-1], COLS[0], tl_position)
    squares = []
    row_i = row(tl_position) - 1
    col_i = _col_num(col(tl_position)) - 1
    while row_i >= 0 and col_i < NUM_COLS:
        column = _board[col_i]
        if row_i >= len(column):
            squares.append(EMPTY)
        else:
            squares.append(column[row_i])
        row_i -= 1  # moving down, i.e. row_i is decreasing
        col_i += 1  # moving right, i.e. col_i is increasing
    assert len(squares) >= 1,\
           "INTERNAL ERROR: squares is empty"
    assert len(squares) <= min(NUM_ROWS, NUM_COLS),\
           "INTERNAL ERROR: should have at most %i squares, have %i" %\
           (min(NUM_ROWS, NUM_COLS), len(squares))
    return squares

def get_diagonal_BL_to_TR(bl_position):
    """
    Returns the bottom-left to top-right diagonal that begins at the given
    bottom-left position (meaning a position on the bottom or left edges).
    """
    _assert_valid_position(bl_position)
    assert row(bl_position) == ROWS[0] or col(bl_position) == COLS[0],\
           ("bl_position must be on the bottom (row %i) or left (col %c)" +\
           " edges, %s given") % (ROWS[0], COLS[0], bl_position)
    squares = []
    row_i = row(bl_position) - 1
    col_i = _col_num(col(bl_position)) - 1
    while row_i < NUM_ROWS and col_i < NUM_COLS:
        column = _board[col_i]
        if row_i >= len(column):
            squares.append(EMPTY)
        else:
            squares.append(column[row_i])
        row_i += 1  # moving up, i.e. row_i is increasing
        col_i += 1  # moving right, i.e. col_i is increasing
    assert len(squares) >= 1,\
           "INTERNAL ERROR: squares is empty"
    assert len(squares) <= min(NUM_ROWS, NUM_COLS),\
           "INTERNAL ERROR: should have at most %i squares, have %i" %\
           (min(NUM_ROWS, NUM_COLS), len(squares))
    return squares

def drop_into_column(col, mark):
    """
    Drops a token with the given mark into the given column. Raises an
    Exception if the given column is filled.
    """
    _assert_valid_col(col)
    col_i = _col_num(col) - 1
    column = _board[col_i]
    if len(column) == NUM_ROWS:
        raise Exception, "column %c is filled" % col
    column.append(mark)

def board_filled():
    """
    Returns True iff the board has been completely filled.
    """
    for col_i in range(NUM_COLS):
        if len(_board[col_i]) < NUM_ROWS:
            return False
    return True

def clear_board():
    """
    Clears the board so that all squares are EMPTY.
    """
    for col_i in range(NUM_COLS):
        _board[col_i] = []


## Game logic ##

def enough_to_win(mark):
    """
    Returns True iff the board contains enough in-a-row of the given mark
    needed to win. All rows, columns and diagonals are considered.
    """
    N = NEEDED_TO_WIN   # the number we need to win, e.g. 4
    win = [mark for i in range(N)]

    # to compare win against a list of squares, we'll go square by square
    # and when we find one that is our mark, we'll slice it to look at the
    # next N-1 elements also, then compare that against win
    def contains_win(squares):
        for i in range(len(squares)):
            if squares[i] == mark:
                if squares[i:i+N] == win:
                    return True
        return False

    # go row by row first
    for row in ROWS:
        squares = get_row(row)
        if contains_win(squares):
            return True

    # same for columns
    for col in COLS:
        squares = get_column(col)
        if contains_win(squares):
            return True

    # diagonals are a bitch. we'll try all the TL-to-BR diagonals first.
    # try all the left-edge positions first, then all the top-edge ones.
    col = COLS[0]
    for row in ROWS:
        squares = get_diagonal_TL_to_BR(position(row, col))
        if contains_win(squares):
            return True
    row = ROWS[-1]
    for col in COLS:
        squares = get_diagonal_TL_to_BR(position(row, col))
        if contains_win(squares):
            return True

    # and same for all the BL-to-TR diagonals. left then bottom edges.
    col = COLS[0]
    for row in ROWS:
        squares = get_diagonal_BL_to_TR(position(row, col))
        if contains_win(squares):
            return True
    row = ROWS[0]
    for col in COLS:
        squares = get_diagonal_BL_to_TR(position(row, col))
        if contains_win(squares):
            return True

    # nothing found in rows, columns or diagonals
    return False


## Display ##

#
# a b c d e f g
#
# . . . . . . .
# . . . . . . .
# . . . . . . .
# . . . . . . .
# . . o x . . .
# . o x o x . .
#

def _get_simple_display():
    # see commented display above to understand the process
    lines = []
    lines.append("")

    # column letters
    col_letters = [lower(col) for col in COLS]
    lines.append(join(col_letters)) # space between each letter
    lines.append("")

    # each row will display each square in that row, from top to bottom
    ROWS_REVERSED = list(ROWS)
    ROWS_REVERSED.reverse()
    for row in ROWS_REVERSED:
        row_letters = []
        for square in get_row(row):
            if square == EMPTY:
                row_letters.append(".")
            else:
                row_letters.append(square)
        lines.append(join(row_letters)) # space between each letter

    lines.append("")
    return lines

#
#    A   B   C   D   E   F   G   
# __                           __
# ||   |   |   |   |   |   |   ||
# |+---+---+---+---+---+---+---+|
# ||   |   |   |   |   |   |   ||
# |+---+---+---+---+---+---+---+|
# ||   |   |   |   |   |   |   ||
# |+---+---+---+---+---+---+---+|
# ||   |   |   |   |   |   |   ||
# |+---+---+---+---+---+---+---+|
# ||   |   |   |   |   |   |   ||
# |+---+---+---+---+---+---+---+|
# || o | o | x | o | x | x | o ||
# |+---+---+---+---+---+---+---+|
# ^^                           ^^
#

def _get_fancy_display():
    # see commented display above to understand the process
    lines = []
    lines.append("")

    # column letters
    col_letters = []
    for col in COLS:
        col_letters.append(" %c " % col)    # space, letter, space

    lines.append("  " + join(col_letters) + "  ") # join here puts a space
            # between each element, but we also need a space for the first
            # column's left edge and the last column's right edge
    lines.append("__" + join(["   "] * NUM_COLS) + "__")

    # each row will now display its own left, right and bottom edges,
    # but we need to do it from top down instead of bottom up
    ROWS_REVERSED = list(ROWS)
    ROWS_REVERSED.reverse()
    for row in ROWS_REVERSED:

        # each square will display its own left and bottom edges
        row_letters_1 = []  # e.g. | X |   | O | X  ...
        row_letters_2 = []  # e.g. +---+---+---+---
        
        row_letters_1.append("|")   # for the left-most outer edge
        row_letters_2.append("|")
        
        squares = get_row(row)
        for square in squares:
            row_letters_1.append("| %c " % square)
            row_letters_2.append("+---")

        row_letters_1.append("||")   # for the right-most outer edge
        row_letters_2.append("+|")

        lines.append(join(row_letters_1, ""))   # no space between each
        lines.append(join(row_letters_2, ""))

    lines.append("^^" + join(["   "] * NUM_COLS) + "^^")
    lines.append("")
    
    return lines

def get_display():
    """
    Returns a list of lines that represent the display of the board.
    """
    #return _get_simple_display()
    return _get_fancy_display()


## Main game code ##

def play_game():

    clear_board()
    current_player = randint(1, 2)  # randomly decide who's first

    # quick helper function to get the given player's mark
    def get_mark(player):
        if player == 1:
            return PL_1
        else:
            return PL_2

    print "Connect Four!"
    print

    player1_name = raw_input("Player 1, what is your name? ")
    player2_name = raw_input("Player 2, what is your name? ")

    # quick helper function to get the given player's name
    def get_name(player):
        if player == 1:
            return player1_name
        else:
            return player2_name

    print
    print "Welcome, %s and %s!" % (player1_name, player2_name)
    print "%s will be %s, and %s will be %s." %\
          (player1_name, PL_1, player2_name, PL_2)
    print "By coinflip, %s will go first." % get_name(current_player)
    print

    raw_input("[Press enter when ready to play.] ")

    # quick helper function to print the board
    def print_board():
        print join(get_display(), "\n\t")

    print_board()

    while not board_filled():

        name = get_name(current_player)
        mark = get_mark(current_player)
        
        prompt = "%s (%c), which column? (e.g. A, a, B, b) " % (name, mark)
        choice = raw_input(prompt)

        if len(choice) != 1 or upper(choice) not in COLS:
            print ("A column is one letter, from %c to %c." %\
                  (COLS[0], COLS[-1])), "Lowercase is fine."
            print "Please try again."
            print
            continue

        if get_column(choice)[-1] != EMPTY:
            print "Sorry, column %c is already filled." % choice
            print "Please try again."
            print
            continue

        drop_into_column(choice, mark)

        print_board()

        if enough_to_win(mark):
            print "Congratulations, %s -- you win!" % name
            print
            break

        if board_filled():
            print "The board is filled. The game ends in a draw."
            print
            break

        # now switch players
        current_player = 3 - current_player     # sets 1 to 2 and 2 to 1

    print "Game Over"
    print

if __name__ == "__main__":

    keep_playing = True

    while keep_playing:

        print "+-" * 37 + "+"
        print
        
        play_game()
        again = lower(raw_input("Play again? (y/n) "))

        print

        if lower(again) != "y":
            keep_playing = False

    print "Thanks for playing!"
    print
