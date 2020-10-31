# distutils: language = c++

cimport cython
from cpython cimport array
import array
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

cdef extern from "GrailSort/GrailSort.h":
    cdef void GrailSort(double *arr, int Len) nogil
    cdef void GrailSortWithBuffer(double *arr, int Len) nogil
    cdef void GrailSortWithDynBuffer(double *arr, int Len) nogil
    cdef void RecStableSort(double *arr, int Len) nogil


def grailsort(double[::1] arr):
    cdef int length = len(arr)
    cdef double *grail_arr = &arr[0]

    with nogil:
        GrailSort(grail_arr, length)


def grailsort_buffer(double[::1] arr):
    cdef int length = len(arr)
    cdef double *grail_arr = &arr[0]

    with nogil:
        GrailSortWithBuffer(grail_arr, length)


def grailsort_dynbuffer(double[::1] arr):
    cdef int length = len(arr)
    cdef double *grail_arr = &arr[0]

    with nogil:
        GrailSortWithDynBuffer(grail_arr, length)


def rotate_merge_sort(double[::1] arr):
    cdef int length = len(arr)
    cdef double *grail_arr = &arr[0]

    with nogil:
        RecStableSort(grail_arr, length)
