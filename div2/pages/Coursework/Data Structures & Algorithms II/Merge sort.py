from random import randint

def makeRandList (x):
    l = [0]*x
    for n in range (x):
        l[n] = randint (0, 10000)
    return l

def mergeSort (lo, hi):
    global a
    if not hi <= lo:
        mid = (lo + hi) // 2
        mergeSort(lo, mid)
        mergeSort(mid + 1, hi)
        merge(lo, mid, mid + 1, hi)

def merge (lo1, hi1, lo2, hi2):
    global a
    b = [None]*(hi2 - lo1 + 1)
    p1 = lo1
    p2 = lo2
    k = 0
    while p1 <= hi1 and p2 <= hi2:
        if a[p1] < a[p2]:
            b[k] = a[p1]
            p1 += 1
        else:
            b[k] = a[p2]
            p2 += 1
        k += 1
    while p1 <= hi1:
        b[k] = a[p1]
        k += 1
        p1 += 1
    while p2 <= hi2:
        b[k] = a[p2]
        k += 1
        p2 += 1
    for i in range (k):
        a[lo1 + i] = b[i]

a = makeRandList(10000)
print (a)
mergeSort (0, len(a)-1)
print (a)
