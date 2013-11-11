A = "gtggcaacgtgc"
B = "gtagcagcgcgc"
C = "gcggcacagggt"
D = "gtgacaacgtgc"


def method1(c1, c2):
    discreps = 0
    for i in range(len(c1)):
        if c1[i] != c2[i]:
            discreps = discreps + 1
    return discreps


def method2(c1, c2):
    discreps_a = abs(c1.count('a') - c2.count('a'))
    discreps_c = abs(c1.count('c') - c2.count('c'))
    discreps_g = abs(c1.count('g') - c2.count('g'))
    discreps_t = abs(c1.count('t') - c2.count('t'))
    return discreps_a + discreps_c + discreps_g + discreps_t


def compare(c1, c2, name1, name2):
    print name1, "and", name2, ":"
    print "Method 1 says there are", method1(c1, c2), "differences."
    print "Method 2 says there are", method2(c1, c2), "differences."
    print


compare(A, B, "A", "B")
compare(A, C, "A", "C")
compare(A, D, "A", "D")
compare(B, C, "B", "C")
compare(B, D, "B", "D")
compare(C, D, "C", "D")
