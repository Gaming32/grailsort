# import grailsort

# print(dir(grailsort))

# l = list(range(100))
# print(l)

# all(l[i] < l[i+1] for i in range(99))

# import random

# random.shuffle(l)
# print(l)

# all(l[i] < l[i+1] for i in range(99))

# grailsort.grailsort(l)

# all(l[i] < l[i+1] for i in range(99))

# print(l)
# print(all(v in l for v in range(100)))

import cGrailSort
import random
import array

def print_out_of_order_index():
    index = next((i for i in range(len(l) - 1) if l[i] > l[i + 1]), None)
    print('Out of order index:', index)

l = array.array('d', range(16777216))
print_out_of_order_index()

random.shuffle(l)
print_out_of_order_index()

cGrailSort.grailsort(l)
print_out_of_order_index()
