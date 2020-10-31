# distutils: language = c++

"""This grailsort module only works with double array.array objects
(array.array('d'))

grailsort(arr: array.array)
grailsort_buffer(arr: array.array)
grailsort_dynbuffer(arr: array.array)
rotate_merge_sort(arr: array.array)

This module uses array.array objects which are represented as C arrays
in memory. This means that the array can be passed directly to the C
functions. Although we can (and do) release the GIL, that does not mean
that this module is thread-safe. Quite the opposite. You must be very careful
to use a threading lock to lock the array while it is being sorted in
order to avoid C-level race conditions that can cause terrible corruption
of the array."""


cimport cython
from cpython cimport array
import array
from libc.stdlib cimport malloc, free


cdef extern from *:
    """
    #define GRAIL_SORT_TYPE double

    int compareDoubles(const double *x, const double *y) {
        if (*x < *y)
            return -1;
        else if (*x > *y)
            return 1;
        return 0;
    }

    #define GRAIL_SORT_COMPARE(x, y) compareDoubles(x, y)
    """

cdef extern from "GrailSort/GrailSort.h":
    cdef void grail_sort(double *arr, int Len) nogil
    cdef void grail_sort_with_static_buffer(double *arr, int Len) nogil
    cdef void grail_sort_with_dynamic_buffer(double *arr, int Len) nogil
    cdef void rec_stable_sort(double *arr, int Len) nogil


def grailsort(double[::1] arr):
    "grailsort(arr: array.array)"
    cdef int length = len(arr)
    cdef double *grail_arr = &arr[0]

    with nogil:
        grail_sort(grail_arr, length)


def grailsort_buffer(double[::1] arr):
    "grailsort_buffer(arr: array.array)"
    cdef int length = len(arr)
    cdef double *grail_arr = &arr[0]

    with nogil:
        grail_sort_with_static_buffer(grail_arr, length)


def grailsort_dynbuffer(double[::1] arr):
    "grailsort_dynbuffer(arr: array.array)"
    cdef int length = len(arr)
    cdef double *grail_arr = &arr[0]

    with nogil:
        grail_sort_with_dynamic_buffer(grail_arr, length)


def rotate_merge_sort(double[::1] arr):
    "rotate_merge_sort(arr: array.array)"
    cdef int length = len(arr)
    cdef double *grail_arr = &arr[0]

    with nogil:
        rec_stable_sort(grail_arr, length)
