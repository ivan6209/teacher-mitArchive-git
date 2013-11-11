##This code is similar to the code to be discussed in lecture 24.
##
##It simulates a shuttle service in which a single
##bus serves a loop.  It starts with some generally useful
##classes for modeling queueing networks, and then uses some
##of them to build the bus simulation.
##
##You should study this code in preparation for the final quiz,
##on which you will be asked questions related to it.
##
##Note that there may be Python mechanisms that you have not used
##in problem sets.  It is your responsibility to learn what
##they do.

import random, pylab, math

class Job(object):
    def __init__(self, meanArrival, meanWork):
        #arrival rate of jobs
        self.arrival = random.expovariate(1.0/meanArrival)
        #time required to perform job, other distributions worth considering
        self.wk = random.gauss(meanWork, meanWork/2.0)
        #Next attribute used to keep track of waiting time for job
        self.timeQueued = None
    def interArrival(self):
        return self.arrival
    def work(self):
        return self.wk
    def queue(self, time):
        self.timeQueued = time
    def queuedTime(self):
        return self.timeQueued
    
class Passenger(Job):
    #Arrival rate is for passenger to arrive at bus stop
    #Work is time for passenger to board bus
    pass

class JobQueue(object):
    def __init__(self):
        self.jobs = []
    def arrive(self, job):
        self.jobs.append(job)
    def length(self):
        return len(self.jobs)
    
class FIFO(JobQueue):
    def depart(self):
        try:
            return self.jobs.pop(0)
        except:
            print 'depart called with an empty queue'
            raise ValueError('EmptyQueue')

class SRPT(JobQueue):
    def depart(self):
        try:
            leastIndx = 0
            for i in range(len(self.jobs)):
                if self.jobs[i].work < self.jobs[leastIndx].work:
                    leastIndx = i
            return self.jobs.pop(leastIndx)
        except:
            print 'depart called with an empty queue'
            raise ValueError('EmptyQueue')

class BusStop(FIFO):
    pass
    
class Bus(object):
    def __init__(self, capacity, speed):
        self.cap = capacity
        self.speed = speed
        self.onBus = 0
    def getSpeed(self):
        return self.speed
    def getLoad(self):
        return self.onBus
    def enter(self):
        if self.onBus < self.cap:
            self.onBus +=1
        else:
            raise ValueError('full')
    def leave(self):
        if self.onBus > 0:
            self.onBus -= 1
    def unload(self, num):
        while num > 0:
            self.leave()
            num -= 1

def simBus(bus, numStops = 6, loopLen = 1200, meanArrival = 90,
           meanWork = 10, simTime = 50000):
    assert loopLen%numStops == 0
    stops = []
    for n in range(numStops):
        stops.append(BusStop())
    time, totWait, totPassengers, lastArrival = [0.0]*4
    aveWaitTimes = []
    nextStop, busLoc, time = [0]*3
    nextJob = Passenger(meanArrival, meanWork)
    while time < simTime:
        #advance time and move bus
        time += 1
        for i in range(bus.getSpeed()):
            busLoc += 1
            if (busLoc)%(loopLen/numStops) == 0:
                break
        #see if there is a passenger waiting to enter queue
        if lastArrival + nextJob.interArrival() <= time:
            #passengers arrive simultaneously at each stop
            for stop in stops:
                stop.arrive(nextJob)
            nextJob.queue(time)
            lastArrival = time
            nextJob = Passenger(meanArrival, meanWork)
        #see if bus is at a stop
        if (busLoc)%(loopLen/numStops) == 0:
            #some passengers get off bus
            bus.unload(math.ceil(bus.getLoad()/float(numStops)))
            #all passengers who arrived prior to the bus's arrival
            #attempt to enter bus
            while stops[nextStop%numStops].length() > 0:
                try:
                    bus.enter()
                except:
                    break
                p = stops[nextStop%numStops].depart()
                totWait += time - p.queuedTime()
                totPassengers += 1
                time += p.work() #advance time, but not bus
            try:
                aveWaitTimes.append(totWait/totPassengers)
            except ZeroDivisionError:
                aveWaitTimes.append(0.0)
            #passengers might have arrived at stops while bus is loading
            while lastArrival + nextJob.interArrival() <= time:
                for stop in stops:
                    stop.arrive(nextJob)
                nextJob.queue(time)
                lastArrival += nextJob.interArrival()
                nextJob = Passenger(meanArrival, meanWork)
            nextStop += 1
    leftWaiting = 0
    for stop in stops:
        leftWaiting += stop.length()
    return aveWaitTimes, leftWaiting
  
def test(capacities, speeds, numTrials):
    random.seed(0)
    for cap in capacities:
        for speed in speeds:
            totWaitTimes = pylab.array([0.0]*500) #keep track of 1st 500 stops
            totLeftWaiting = 0.0
            for t in range(numTrials):
                aveWaitTimes, leftWaiting = simBus(Bus(cap, speed))
                totWaitTimes += pylab.array(aveWaitTimes[:500])
                totLeftWaiting += leftWaiting
            aveWaitTimes = totWaitTimes/numTrials
            leftWaiting = int(totLeftWaiting/numTrials)
            lab = 'Spd = ' + str(speed) + ', Cap = ' + str(cap)\
                  + ', Left = ' + str(leftWaiting)
            pylab.plot(aveWaitTimes, label = lab)
    pylab.xlabel('Stop Number')
    pylab.ylabel('Aggregate Average Wait Time')
    pylab.title('Impact of Bus Speed and Capacity')
    ymin, ymax = pylab.ylim()
    if ymax - ymin > 200:
        pylab.semilogy()
    pylab.ylim(ymin = 1.0)
    pylab.legend(loc = 'best')
        
test([15, 30], [6, 10, 20], 20)
pylab.show()
