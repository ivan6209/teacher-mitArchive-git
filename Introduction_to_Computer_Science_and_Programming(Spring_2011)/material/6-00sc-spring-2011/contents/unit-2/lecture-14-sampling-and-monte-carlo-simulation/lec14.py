import random, pylab

principal = 10000.0 #initial investment
interestRate = 0.05
years = 20
values = []
for i in range(years + 1):
    values.append(principal)
    principal += principal*interestRate
pylab.plot(values)
##pylab.show()

##pylab.title('5% Growth, Compounded Annually')
##pylab.xlabel('Years of Compounding')
##pylab.ylabel('Value of Principal ($)')
##pylab.show()

def rollDie():
    """returns a random int between 1 and 6"""
    return random.choice([1,2,3,4,5,6])

def testRoll(n = 10):
    result = ''
    for i in range(n):
        result = result + str(rollDie())
    print(result)

def checkPascal(numTrials = 100000):
    yes = 0.0
    for i in range(numTrials):
        for j in range(24):
            d1 = rollDie()
            d2 = rollDie()
            if d1 == 6 and d2 == 6:
                yes += 1
                break
    print 'Probability of losing = ' + str(1.0 - yes/numTrials)

##checkPascal()

def testRoll(numTrials):
    results = [0]*13
    for t in range(numTrials):
        roll = rollDie() + rollDie()
        results[roll] += 1
    probs = pylab.array(results)/float(numTrials)
    pylab.plot(range(2,13), probs[2:13], 'ro')
    pylab.title('Results of Rolling a Pair of Dice')
    pylab.xlabel('Sum of Pair')
    pylab.ylabel('Probability')
    limits = pylab.axis()
    limits = (1, 13, 0, limits[3])
    pylab.axis(limits)

##testRoll(100000)
##pylab.show()

def flip(numFlips):
    heads = 0
    for i in range(numFlips):
        if random.random() < 0.5:
            heads += 1
    return heads/float(numFlips)

##def flipSim(numFlipsPerTrial, numTrials):
##    fracHeads = []
##    for i in range(numTrials):
##        fracHeads.append(flip(numFlipsPerTrial))
##    mean = sum(fracHeads)/float(len(fracHeads))
##    return (mean)

def flipPlot(minExp, maxExp):
    ratios = []
    diffs = []
    xAxis = []
    for exp in range(minExp, maxExp + 1):
        xAxis.append(2**exp)
    for numFlips in xAxis:
        numHeads = 0
        for n in range(numFlips):
            if random.random() < 0.5:
                numHeads += 1
        numTails = numFlips - numHeads
        ratios.append(numHeads/float(numTails))
        diffs.append(abs(numHeads - numTails))
    pylab.title('Difference Between Heads and Tails')
    pylab.xlabel('Number of Flips')
    pylab.ylabel('Abs(#Heads - #Tails')
    pylab.plot(xAxis, diffs)
    pylab.figure()
    pylab.plot(xAxis, ratios)
    pylab.title('Heads/Tails Ratios')
    pylab.xlabel('Number of Flips')
    pylab.ylabel('Heads/Tails')
    pylab.figure()
    pylab.title('Difference Between Heads and Tails')
    pylab.xlabel('Number of Flips')
    pylab.ylabel('Abs(#Heads - #Tails')
    pylab.plot(xAxis, diffs, 'bo')
    pylab.semilogx()
    pylab.semilogy()
    pylab.figure()
    pylab.plot(xAxis, ratios, 'bo')
    pylab.title('Heads/Tails Ratios')
    pylab.xlabel('Number of Flips')
    pylab.ylabel('Heads/Tails')
    pylab.semilogx()

flipPlot(4, 20)
pylab.show()

def stdDev(X):
    mean = sum(X)/float(len(X))
    tot = 0.0
    for x in X:
        tot += (x - mean)**2
    return math.sqrt(tot/len(X))


