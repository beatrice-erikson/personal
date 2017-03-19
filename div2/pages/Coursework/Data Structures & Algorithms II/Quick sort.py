from random import randint

def quickSort (a, lo, hi): #picks a random element in section of list, partitions over it, and recurs on each half
    if hi > lo:
        p = randint (lo, hi) #random number between lo and hi
        p = partition (a, lo, hi, p) #p gets partitioned location of p.
        quickSort (a, lo, p - 1)
        quickSort (a, p + 1, hi)
        

def partition (a, lo, j, p): #sorts list into [<x, x, >= x] and returns position of x
    i = lo + 1
    x = a[p]
    a[p] = a[lo]
    while j >= i:
        if a[i] < x:
            i += 1
        elif a[j] >= x:
            j -= 1
        else:
            t = a[j]
            a[j] = a[i]
            a[i] = t
            j -= 1
            i += 1
    a[lo] = a[j]
    a[j] = x
    return j

a = [None]*10000
for x in range (10000):
    a[x] = randint (1, 9999)

print (a)
quickSort (a, 0, len(a)-1)
print (a)
