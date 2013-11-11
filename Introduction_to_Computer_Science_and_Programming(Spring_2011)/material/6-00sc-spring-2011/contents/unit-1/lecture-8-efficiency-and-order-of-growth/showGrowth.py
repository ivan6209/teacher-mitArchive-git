import pylab, math

def showGrowth(lower, upper):
    log = []
    linear = []
    quadratic = []
    logLinear = []
    exponential = []
    for n in range(lower, upper+1):
        log.append(math.log(n, 2))
        linear.append(n)
        logLinear.append(n*math.log(n, 2))
        quadratic.append(n**2)
        exponential.append(2**n)
    pylab.plot(log, label = 'log')
    pylab.plot(linear, label = 'linear')
    pylab.legend(loc = 'upper left')
    pylab.figure()
    pylab.plot(linear, label = 'linear')
    pylab.plot(logLinear, label = 'log linear')
    pylab.legend(loc = 'upper left')
    pylab.figure()
    pylab.plot(logLinear, label = 'log linear')
    pylab.plot(quadratic, label = 'quadratic')
    pylab.legend(loc = 'upper left')
    pylab.figure()
    pylab.plot(quadratic, label = 'quadratic')
    pylab.plot(exponential, label = 'exponential')
    pylab.legend(loc = 'upper left')
    pylab.figure()
    pylab.plot(quadratic, label = 'quadratic')
    pylab.plot(exponential, label = 'exponential')
    pylab.semilogy()
    pylab.legend(loc = 'upper left')
    return

showGrowth(1, 1000)
pylab.show()
    
    
