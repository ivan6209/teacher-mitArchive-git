def make32(x):
    x = x % (2**32)
    if x >= 2**31: 
        x = x - 2**32
    x = int(x)
    return x

class SuperList(object):
    "A python list, wrapped in an object claiming to be a dictionary key"
    def __init__(self, list):
        self.list = list
    def __hash__(self):
        "The hash value of the object (the list wrapped inside)"
        
        # using code stolen from tuples
        m = 1000003
        x = 0x345678
        v = self.list
        for i in range(len(v)):
            y = v[i].__hash__() 
            if y == -1: return -1
            x = make32((x^y)*m)
            m = make32(m + 82520 + 2*((len(v)-i-1)))
        x = make32(x+97531)
        if x == -1: 
            x = -2
        return x
    
    def __eq__(self, other):
        "Equality predicate needed for dictionary keys"
        return self.list.__eq__(other.list)

# everything works just fine
k1 = SuperList([1, 2, 3])
k2 = SuperList([1, 2, 3])
k3 = SuperList([4, 5, 6])

k1 == k2
k1 == k3

d = {}
d[k1] = 'a'
d[k2] = 'b'
d[k3] = 'c'
print d

# dictionary breaks because a key changed
print d[k1], d[k2], d[k3]
k1.list.append(4)
print d[k1], d[k2], d[k3]

k1 == k2
k1 == k3
hash(k1)
hash(k3)
