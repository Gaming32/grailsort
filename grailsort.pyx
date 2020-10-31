# distutils: language = c++

"""This grailsort module works with any Python sequence
which contain any comparable Python objects

grailsort(array: Sequence)
grailsort_buffer(array: Sequence)
grailsort_dynbuffer(array: Sequence)
rotate_merge_sort(array: Sequence)

This module operates by copying all the Python objects in
the sequence into a C array. It then sorts the C array and
copies the C array back into the Python sequence. This is
slower than cGrailSort, especially in multithreaded situations
because it cannot release the GIL as it deal with Python objects."""


cimport cython
from cpython cimport PyObject
from libc.stdlib cimport malloc, free


cdef extern from *:
    """
    #define GRAIL_SORT_TYPE PyObject*

    int comparePython(PyObject **x, PyObject **y) {
        if (PyObject_RichCompareBool(*x, *y, Py_LT))
            return -1;
        else if (PyObject_RichCompareBool(*x, *y, Py_GT))
            return 1;
        return 0;
    }

    #define GRAIL_SORT_COMPARE(x, y) comparePython(x, y)
    """

cdef extern from "GrailSort/GrailSort.h":
    cdef void grail_sort(PyObject **arr, int Len)
    cdef void grail_sort_with_static_buffer(PyObject **arr, int Len)
    cdef void grail_sort_with_dynamic_buffer(PyObject **arr, int Len)
    cdef void rec_stable_sort(PyObject **arr, int Len)


def grailsort(object array):
    "grailsort(array: Sequence)"
    cdef int length = len(array)
    cdef PyObject **grail_arr

    grail_arr = <PyObject **>malloc(length*cython.sizeof(PyObject))
    if grail_arr is NULL:
        raise MemoryError()

    for i in range(length):
        grail_arr[i] = <PyObject *>array[i]

    grail_sort(grail_arr, length)

    for i in range(length):
        array[i] = <object>grail_arr[i]


def grailsort_buffer(object array):
    "grailsort_buffer(array: Sequence)"
    cdef int length = len(array)
    cdef PyObject **grail_arr

    grail_arr = <PyObject **>malloc(length*cython.sizeof(PyObject))
    if grail_arr is NULL:
        raise MemoryError()

    for i in range(length):
        grail_arr[i] = <PyObject *>array[i]

    grail_sort_with_static_buffer(grail_arr, length)

    for i in range(length):
        array[i] = <object>grail_arr[i]


def grailsort_dynbuffer(object array):
    "grailsort(array: Sequence)"
    cdef int length = len(array)
    cdef PyObject **grail_arr

    grail_arr = <PyObject **>malloc(length*cython.sizeof(PyObject))
    if grail_arr is NULL:
        raise MemoryError()

    for i in range(length):
        grail_arr[i] = <PyObject *>array[i]

    grail_sort_with_dynamic_buffer(grail_arr, length)

    for i in range(length):
        array[i] = <object>grail_arr[i]


def rotate_merge_sort(object array):
    "rotate_merge_sort(array: Sequence)"
    cdef int length = len(array)
    cdef PyObject **grail_arr

    grail_arr = <PyObject **>malloc(length*cython.sizeof(PyObject))
    if grail_arr is NULL:
        raise MemoryError()

    for i in range(length):
        grail_arr[i] = <PyObject *>array[i]

    rec_stable_sort(grail_arr, length)

    for i in range(length):
        array[i] = <object>grail_arr[i]
