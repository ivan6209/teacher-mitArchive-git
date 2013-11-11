import pylab, random

class Stock(object):
    def __init__(self, price, distribution, vol):
        self.price = price
        self.history = [price]
        self.distribution = distribution
        self.vol = vol
        self.lastChangeInfluence = 0.0
    def setPrice(self, price):
        self.price = price
        self.history.append(price)
    def getPrice(self):
        return self.price
    def makeMove(self, bias, mo):
        oldPrice = self.price
        baseMove = self.distribution(self.vol) + bias
        self.price = self.price * (1.0 + baseMove)
        self.price += mo*random.choice([0.0, 1.0])*self.lastChangeInfluence
        self.history.append(self.price)
        change = self.price - oldPrice
        if change >= 0:
            self.lastChangeInfluence = min(change, oldPrice*0.01)
        else:
            self.lastChangeInfluence = max(change, -oldPrice*0.01)
    def showHistory(self, fig, test):
        pylab.figure(fig)
        pylab.plot(self.history)
        pylab.title('Closing Prices, Test ' + test)
        pylab.xlabel('Day')
        pylab.ylabel('Price')

class SimpleMarket(object):
    def __init__(self, numStks, volUB):
        self.stks = []
        self.bias = 0.0
        for n in range(numStks):
            volatility = random.uniform(0, volUB)
            distribution = lambda vol: random.gauss(0.0, vol)
            stk = Stock(100.0, distribution, volatility)
            self.addStock(stk)
    def addStock(self, stk):
        self.stks.append(stk)
    def setBias(self, bias):
        self.bias = bias
    def getBias(self):
        return self.bias
    def getStocks(self):
        return self.stks[:]
    def move(self, mo):
        prices = []
        for s in self.stks:
            s.makeMove(self.bias, mo)
            prices.append(s.getPrice())
        return prices

class Market(SimpleMarket):
    def __init__(self, numStks, volUB, dailyBiasRange):
        SimpleMarket.__init__(self, numStks, volUB)
        self.dailyBiasRange = dailyBiasRange
    def move(self, mo):
        prices = []
        dailyBias = random.gauss(self.dailyBiasRange[0], self.dailyBiasRange[1])
        for s in self.stks:
            s.makeMove(self.bias + dailyBias, mo)
            prices.append(s.getPrice())
        return prices

def simMkt(mkt, numDays, mo):
    endPrices = []
    for i in range(numDays):
        vals = mkt.move(mo)
        vals = pylab.array(vals)
        mean = vals.sum()/float(len(vals))
        endPrices.append(mean)
    return endPrices

def plotAverageOverTime(endPrices, title):
    pylab.plot(endPrices)
    pylab.title(title)
    pylab.xlabel('Days')
    pylab.ylabel('Price')

def plotDistributionAtEnd(mkt, title, color):
    prices = []
    sumSoFar = 0
    for s in mkt.getStocks():
        prices.append(s.getPrice())
        sumSoFar += s.getPrice()
    mean = sumSoFar/float(len(prices))
    prices.sort()
    pylab.plot(prices, color)
    pylab.axhline(mean, color = color)
    pylab.title(title)
    pylab.xlabel('Stock')
    pylab.ylabel('Last Sale')
    pylab.semilogy()

def runTrial(showHistory, test, p):
    colors = ['b','g','r','c','m','y','k']

    mkt = Market(p['numStocks'], p['volUB'], p['dailyBiasRange'])
    mkt.setBias(p['bias'])
    endPrices = simMkt(mkt, p['numDays'], p['mo'])
    pylab.figure(1)
    plotAverageOverTime(endPrices, 'Average Closing Prices')
    pylab.figure(2)
    plotDistributionAtEnd(mkt, 'Distribution of Prices', colors[test%len(colors)])
    if showHistory:
        for s in mkt.getStocks():
            s.showHistory(test+2, str(test))

def runTest(numTrials):
    #Constants used in testing
    numDaysPerYear = 200.0
    params = {}
    params['numDays'] = 200
    params['numStocks'] = 500
    params['bias'] = 0.1/numDaysPerYear #General market bias
    params['volUB'] = 12.0/numDaysPerYear #Upper bound on volatility for a stock
    params['mo'] = 1.1/numDaysPerYear #Momentum factor
    params['dailyBiasRange'] = (0.0, 4.0/200.0)

    for t in range(1, numTrials+1):
        runTrial(True, t, params)

runTest(3)
pylab.show()
