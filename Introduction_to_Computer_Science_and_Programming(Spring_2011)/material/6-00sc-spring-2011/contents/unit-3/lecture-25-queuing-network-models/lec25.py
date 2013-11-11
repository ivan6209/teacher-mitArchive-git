import random, pylab

meanArrival = 60
arrivals = []
for i in range(2000):
    interArrivalTime = random.expovariate(1.0/meanArrival)
    arrivals.append(interArrivalTime)
ave = sum(arrivals)/len(arrivals)
print 'Distance from intended mean:', meanArrival - ave
xAxis = pylab.arange(0, len(arrivals), 1)
pylab.scatter(xAxis, arrivals)
pylab.axhline(meanArrival, linewidth = 4)
pylab.title('Exponential Inter-arrival Times')
pylab.ylabel('Inter-arrival Time (secs)')
pylab.xlabel('Job Number')
pylab.figure()
pylab.hist(arrivals)
pylab.title('Exponential Inter-arrival Times')
pylab.xlabel('Inter-arrival Time (secs)')
pylab.ylabel('Number of Jobs')
pylab.show()
