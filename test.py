import grailsort

print(dir(grailsort))

l = list(range(100))
print(l)

all(l[i] < l[i+1] for i in range(99))

import random

random.shuffle(l)
print(l)

all(l[i] < l[i+1] for i in range(99))

grailsort.grailsort(l)

all(l[i] < l[i+1] for i in range(99))

print(l)
print(all(v in l for v in range(100)))