# Code explanation of how to use a while/else block
# while_else.py

# 'while/else' Blocks

# We went over 'if/else' blocks in lecture, though in Pset 1 we also saw
# a few people using 'while/else' blocks, which we didn't talk about in
# lecture. 'while/else' blocks work in a somewhat different (perhaps
# slightly counterintuitive) manner than 'if/else' blocks, and it's easy
# to use them in an incorrect manner. With 'if/else' blocks, if the
# condition in the 'if' statement evaluates to True, the 'if' block is
# executed, while if the condition evaluates to False, the 'else' block
# is executed. The behavior is mutually exclusive. With 'while/else'
# blocks, this is not necessarily the case. The 'else' of the
# 'while/else' will be executed if the 'while' loop is exited normally,
# meaning if the condition in the 'while' loop ever evaluates to False.
# So the 'while' loop may run its course, but then the 'else' clause can
# still be executed! Thus, the 'while' and 'else' are NOT mutually
# exclusive, as in the 'if/else' case. Let's look at an example, part 2
# from loops.py in Pset 1.

# Here is a possible implementation, but it is buggy:

###
n = input('Enter a nonnegative number: ')

while n >= 0:
  print n
  n -= 1
else:
  print "You've failed to enter a nonnegative number."
###

# Let's check our cases. Say I inputted the number -1 for n. We would
# bypass the loop since -1 < 0, and since the while loop condition
# evaluated to false, the expected error message would be printed.
# Great. However, say I inputted a 1 for n. The program would output:
# 1
# 0
# You've failed to enter a nonnegative number.

# That is because the loop exited normally; on the final iteration of
# the loop, n = -1, the condition evaluates to False, and the error
# message prints, which is not what we wanted at all; 1 is a perfectly
# valid nonnegative number to input!

# How could we fix this buggy code? Well, what if we just checked for a
# negative number before the loop? Merely replace the 'else' with an
# 'if' and move the code before the loop:

###
n = input('Enter a nonnegative number: ')

if n < 0:
  print "You've failed to enter a nonnegative number."

while n >= 0:
  print n
  n -= 1
###

# Just to mention, loops can also be exited via 'break' statements or
# exceptions, which we covered briefly in Lecture 4 and you can read about 
# in the textbook. If a loop were exited because of these, the 'else' block
# would not execute since the loop was not terminated normally.

# For what it's worth, I don't ever use 'while/else' blocks, so this
# isn't even an issue for me; there are always ways to get around them.
