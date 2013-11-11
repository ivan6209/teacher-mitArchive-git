import random, pylab

def anscombe(plotPoints):
    dataFile = open('anscombe.txt', 'r')
    X1,X2,X3,X4,Y1,Y2,Y3,Y4 = [],[],[],[],[],[],[],[]
    for line in dataFile:
        x1,y1,x2,y2,x3,y3,x4,y4 = line.split()
        X1.append(float(x1))
        X2.append(float(x2))
        X3.append(float(x3))
        X4.append(float(x4))
        Y1.append(float(y1))
        Y2.append(float(y2))
        Y3.append(float(y3))
        Y4.append(float(y4))
    dataFile.close()
    xVals = pylab.array(range(21))
    if plotPoints: pylab.plot(X1, Y1, 'o')
    a, b = pylab.polyfit(X1, Y1, 1)
    yVals = a*xVals + b
    pylab.plot(xVals, yVals)
    pylab.xlim(0, 20)
    mean = sum(Y1)/float(len(Y1))
    median = Y1[len(Y1)/2 + 1]
    pylab.title('Mean = ' + str(mean) + ', Median = ' + str(median))
    pylab.figure()
    if plotPoints: pylab.plot(X2, Y2, 'o')
    a, b = pylab.polyfit(X2, Y2, 1)
    yVals = a*xVals + b
    pylab.plot(xVals, yVals)
    pylab.xlim(0, 20)
    mean = sum(Y1)/float(len(Y1))
    median = Y1[len(Y1)/2 + 1]
    pylab.title('Mean = ' + str(mean) + ', Median = ' + str(median))
    pylab.figure()
    if plotPoints: pylab.plot(X3, Y3, 'o')
    a, b = pylab.polyfit(X3, Y3, 1)
    yVals = a*xVals + b
    pylab.plot(xVals, yVals)
    pylab.xlim(0, 20)
    mean = sum(Y1)/float(len(Y1))
    median = Y1[len(Y1)/2 + 1]
    pylab.title('Mean = ' + str(mean) + ', Median = ' + str(median))
    pylab.figure()
    if plotPoints: pylab.plot(X4, Y4, 'o')
    a, b = pylab.polyfit(X4, Y4, 1)
    yVals = a*xVals + b
    pylab.plot(xVals, yVals)
    pylab.xlim(0, 20)
    mean = sum(Y1)/float(len(Y1))
    median = Y1[len(Y1)/2 + 1]
    pylab.title('Mean = ' + str(mean) + ', Median = ' + str(median))
    pylab.show()

##anscombe(True)

def internet(points):
    years = pylab.array(range(1994, 2001))
    percent = [4.9,9.4,16.7,22,30.7, 36.6, 43.9]
    pylab.plot(years,percent)
    a, b = pylab.polyfit(years, percent, 1)
    yvals = a*pylab.array(years) + b
    pylab.plot(years, yvals)
    pylab.title('Internet Usage in the United States')
    pylab.xlabel('Year')
    pylab.ylabel('% of Population')
    if points:
        pylab.figure()
        pylab.plot(years, percent, 'o')
        xvals = pylab.array(range(1994, 2011))
        yvals = a*xvals + b
        pylab.plot(xvals, yvals)
        pylab.title('Projected Internet Usage in the United States')
        pylab.xlabel('Year')
        pylab.ylabel('% of Population')
    pylab.show()

##internet(True)

def juneProb(numTrials):
    june48 = 0.0
    for trial in range(numTrials):
        june = 0.0
        for i in range(446):
            if random.choice(range(1,13)) == 6:
                june += 1.0
        if june >= 48:
            june48 += 1
    juneProb = str(june48/numTrials)
    print 'Probability of at least 48 births in June = ' + juneProb

#juneProb(1000)

def anyProb(numTrials):
    anyMonth = 0.0
    for trial in range(numTrials):
        months = [0.0]*13
        for i in range(446):
            months[random.choice(range(1,13))] += 1
        if max(months) >= 48:
            anyMonth += 1
    aProb = str(anyMonth/numTrials)
    print 'Probability of at least 48 births in some Month = ' + aProb

anyProb(1000)

