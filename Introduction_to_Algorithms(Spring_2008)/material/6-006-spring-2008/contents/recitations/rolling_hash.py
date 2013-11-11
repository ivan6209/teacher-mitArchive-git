#!/usr/bin/python
import unittest
from collections import deque

class AmnesiacRollingHash:
    """
    Efficiently computes the hash value of a rolling sequence of numbers.
    Doesn't store the sequence of numbers, so it consumes a constant ammount of memory.
    """
    def __init__(self, base = 256, prime = 1009):
        self.hash_value = 0
        self.base = base
        self.prime = prime
        # inv_base is computed s.t. (base * inv_base) % prime == 1
        self.inv_base = pow(base, prime - 2, prime)
        self.skip_multiplier = 1
        
    def append(self, value):
        "Appends a number at the end of the rolling sequence"
        self.hash_value = (self.hash_value * self.base + value) % self.prime
        self.skip_multiplier = (self.skip_multiplier * self.base) % self.prime
        
    def skip(self, value):
        """
        Removes the number at the beginning of the rolling sequence.
        The parameter value must indicate the number that will be removed.
        """
        self.skip_multiplier = (self.skip_multiplier * self.inv_base) % self.prime
        self.hash_value = (self.hash_value + self.prime - (value * self.skip_multiplier) % self.prime) % self.prime
        
class RollingHash(AmnesiacRollingHash):
    """
    Efficiently computes the hash value of a rolling sequence of numbers.
    """
    def __init__(self, *args):
        AmnesiacRollingHash.__init__(self, *args)
        self.data = deque()
        
    def append(self, value):
        "Appends a number at the end of the rolling sequence"
        AmnesiacRollingHash.append(self, value)
        self.data.append(value)
        
    def skip(self):
        "Removes the number at the beginning of the rolling sequence."        
        AmnesiacRollingHash.skip(self, self.data.popleft())
        
class TestRollingHash(unittest.TestCase):
    def setUp(self):
        pass

    def straight_hash(self, list):
        h = RollingHash()
        for i in list:
            h.append(i)
        return h.hash_value

    def trace_pattern(self, list, pattern):
        h = RollingHash()
        left = 0
        right = 0
        for i in range(0, len(pattern)):
            if pattern[i] > 0:
                h.append(list[right])
                right += 1
            else:
                h.skip()
                left += 1
            self.assertEqual(h.hash_value, self.straight_hash(list[left:right]))

    def test1(self):
        l = [91, 62, 55, 73, 22, 85]
        self.trace_pattern(l, [1, 1, 1, 1, 1, 1])
        
    def test2(self):
        l = [91, 62, 55, 73, 22, 85]
        self.trace_pattern(l, [1, -1])        

    def test3(self):
        l = [91, 62, 55, 73, 22, 85]
        self.trace_pattern(l, [1, -1, 1, 1, -1, -1, 1, 1, 1, -1, -1, -1])        

    def test4(self):
        a1 = 'amazinglyrandomstringwithfluff'
        b1 = []
        for c in a1:
            b1.append(ord(c))
        self.trace_pattern(b1, [1, -1, 1, 1, -1, -1, 1, 1, 1, -1, 1, 1, -1, -1, 1, -1, -1, -1 -1, 1, -1, 1, 1, -1])        

if __name__ == '__main__':
    suite = unittest.TestLoader().loadTestsFromTestCase(TestRollingHash)
    unittest.TextTestRunner(verbosity=2).run(suite)
