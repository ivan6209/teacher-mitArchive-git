#!/usr/bin/python
import unittest

class DeletedEntry:
    pass

# TODO: docstrings
class OpenAddressingTable:
    
    def __init__(self, hash_function, m = 1009):
        self.entries = [None for i in range(m)]
        self.hash = hash_function
        self.deleted_entry = DeletedEntry()
    
    def get_entry(self, key):
        "Searches the hash table for an entry with the given key."
        for attempt in xrange(len(self.entries)):
            h = self.hash(key, attempt)
            if self.entries[h] is None: 
                return None    # empty slot, end of the "chain"
            if self.entries[h] is not self.deleted_entry and \
               self.entries[h][0] == key:
                return self.entries[h] # key matched
    
    def __getitem__(self, key):
        "Searches the hash table for an item with the given key."
        entry = self.get_entry(key)
        if entry is None:
            raise KeyError(key)
        return entry[1]
        
    def __contains__(self, key):
        return self.get_entry(key) is not None
        
    def __setitem__(self, key, value):
        "Inserts the given (key, value) association in the table."
        if value is None: raise 'Cannot set value to None'
        del self[key]  # delete key if it's already there
        for attempt in xrange(len(self.entries)):
            h = self.hash(key, attempt)
            if self.entries[h] is None or \
               self.entries[h] is self.deleted_entry:
                self.entries[h] = (key, value)
                return
        raise 'Table full'
            
    def __delitem__(self, key):
        "Removes the value associated with the given key from the table."
        for attempt in xrange(len(self.entries)):
            h = self.hash(key, attempt)
            if self.entries[h] is None: 
                return    # empty slot, end of the "chain"
            if self.entries[h] is not self.deleted_entry and \
               self.entries[h][0] == key:
                # delete the key
                self.entries[h] = self.deleted_entry
                return
        return    # exhausted table
            
def linear_probing(m = 1009):
    "Builds a hashing function that implements linear probing, modulo m."
    def hf(key, attempt):
        return (hash(key) + attempt) % m
    return hf
    
def double_hashing(hf2, m = 1009):
    "Builds a hashing function that implements double hashing."
    def hf(key, attempt):
        return (hash(key) + attempt * hf2(key)) % m
    return hf

class TestOpenAddressing(unittest.TestCase):
    def setUp(self):
        pass
    
    def test1(self):
        "Insertion and search without collisions or deletions"
        d = OpenAddressingTable(linear_probing(5), 5)
        d[1] = 'a'; d[3] = 'b'; d[5] = 'c'; d[7] = 'd';
        v = [d[1], d[2], d[3], d[4], d[5], d[6], d[7], d[8]]
        self.assertEqual(v, ['a', None, 'b', None, 'c', None, 'd', None])
        
    def test2(self):
        "Insertion and search with collisions"
        d = OpenAddressingTable(linear_probing(5), 5)
        d[0] = 'a'; d[5] = 'b'; d[10] = 'c'; d[15] = 'd'; d[20] = 'e';
        v = [d[0], d[1], d[2], d[3], d[4], d[5], d[10], d[15], d[20]]
        self.assertEqual(v, ['a', None, None, None, None, 'b', 'c', 'd', 'e'])
        
    def test3(self):
        "Insertion and search with collisions and deletions"
        d = OpenAddressingTable(linear_probing(5), 5)
        d[0] = 'a'; d[5] = 'b'; d[10] = 'c'; d[15] = 'd'; d[20] = 'e';
        del d[5]; del d[15]
        v = [d[0], d[1], d[2], d[3], d[4], d[5], d[10], d[15], d[20], d[25]]
        self.assertEqual(v, ['a', None, None, None, None, None, 'c', None, 'e', None])
        d[25] = 'f';
        v = [d[0], d[1], d[2], d[3], d[4], d[5], d[10], d[15], d[20], d[25]]
        self.assertEqual(v, ['a', None, None, None, None, None, 'c', None, 'e', 'f'])

if __name__ == '__main__':
    suite = unittest.TestLoader().loadTestsFromTestCase(TestOpenAddressing)
    unittest.TextTestRunner(verbosity=2).run(suite)
