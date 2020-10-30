# distutils: language = c++

cimport cython
from libc.stdlib cimport malloc, free


cdef extern from *:
    """
    #define SORT_TYPE double

    int compareDoubles(const double *x, const double *y) {
        if (*x < *y)
            return -1;
        else if (*x > *y)
            return 1;
        return 0;
    }

    #define SORT_CMP(x, y) compareDoubles(x, y)
    """

cdef extern from "GrailSort.h":
    cdef void GrailSort(double *arr, int Len) nogil
    cdef void GrailSortWithBuffer(double *arr, int Len) nogil
    cdef void GrailSortWithDynBuffer(double *arr, int Len) nogil


def grailsort(list array):
    cdef int length = len(array)
    cdef double *grail_arr

    grail_arr = <double *>malloc(length*cython.sizeof(double))
    if grail_arr is NULL:
        raise MemoryError()

    for i in range(length):
        grail_arr[i] = array[i]

    with nogil:
        GrailSort(grail_arr, length)

    for i in range(length):
        array[i] = grail_arr[i]

    with nogil:
        free(grail_arr)


def grailsort_buffer(list array):
    cdef int length = len(array)
    cdef double *grail_arr

    grail_arr = <double *>malloc(length*cython.sizeof(double))
    if grail_arr is NULL:
        raise MemoryError()

    for i in range(length):
        grail_arr[i] = array[i]

    with nogil:
        GrailSortWithBuffer(grail_arr, length)

    for i in range(length):
        array[i] = grail_arr[i]

    with nogil:
        free(grail_arr)


def grailsort_dynbuffer(list array):
    cdef int length = len(array)
    cdef double *grail_arr

    grail_arr = <double *>malloc(length*cython.sizeof(double))
    if grail_arr is NULL:
        raise MemoryError()

    for i in range(length):
        grail_arr[i] = array[i]

    with nogil:
        GrailSortWithDynBuffer(grail_arr, length)

    for i in range(length):
        array[i] = grail_arr[i]

    with nogil:
        free(grail_arr)
