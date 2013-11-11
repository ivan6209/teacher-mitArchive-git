def bSearch(L, e, low, high):
    if high - low < 2:
        return L[low] == e or L[high] == e
    mid = low + int((high - low)/2)
    if L[mid] == e:
        return True
    if L[mid] > e:
        return bSearch(L, e, low, mid - 1)
    else:
        return bSearch(L, e, mid + 1, high)

def selSort(L):
    """Assumes that L is a list of elements that can be compared
       using >.  Sorts L in ascending order"""
    for i in range(len(L) - 1):
        #Invariant: the list L[:i] is sorted
        minIndx = i
        minVal= L[i]
        j = i + 1
        while j < len(L):
            if minVal > L[j]:
                minIndx = j
                minVal= L[j]
            j += 1
        temp = L[i]
        L[i] = L[minIndx]
        L[minIndx] = temp
        print 'Partially sorted list =', L

##L = [35, 4, 5, 29, 17, 58, 0]
##selSort(L)
##print 'Sorted list =', L

def merge(left, right, lt):
    """Assumes left and right are sorted lists.
     lt defines an ordering on the elements of the lists.
     Returns a new sorted(by lt) list containing the same elements
     as (left + right) would contain."""
    result = []
    i,j = 0, 0
    while i < len(left) and j < len(right):
        if lt(left[i], right[j]):
            result.append(left[i])
            i += 1
        else:
            result.append(right[j])
            j += 1
    while (i < len(left)):
        result.append(left[i])
        i += 1
    while (j < len(right)):
        result.append(right[j])
        j += 1
    return result
            
def sort(L, lt = lambda x,y: x < y):
    """Returns a new sorted list containing the same elements as L"""
    if len(L) < 2:
        return L[:]
    else:
        middle = int(len(L)/2)
        left = sort(L[:middle], lt)
        right = sort(L[middle:], lt)
        print 'About to merge', left, 'and', right
        return merge(left, right, lt)

##L = [35, 4, 5, 29, 17, 58, 0]
##newL = sort(L)
##print 'Sorted list =', newL
##L = [1.0, 2.25, 24.5, 12.0, 2.0, 23.0, 19.125, 1.0]
##newL = sort(L, float.__lt__)
##print 'Sorted list =', newL

def lastNameFirstName(name1, name2):
    import string
    name1 = string.split(name1, ' ')
    name2 = string.split(name2, ' ')
    if name1[1] != name2[1]:
        return name1[1] < name2[1]
    else:
        return name1[0] < name2[0]

def firstNameLastName(name1, name2):
    import string
    name1 = string.split(name1, ' ')
    name2 = string.split(name2, ' ')
    if name1[0] != name2[0]:
        return name1[0] < name2[0]
    else:
        return name1[1] < name2[1]

##L = ['John Guttag', 'Tom Brady', 'Chancellor Grimson', 'Gisele Brady',
##     'Big Julie']
##newL = sort(L, lastNameFirstName)
##print 'Sorted list =', newL
##newL = sort(L, firstNameLastName)
##print 'Sorted list =', newL
