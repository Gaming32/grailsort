# distutils: language = c++

cimport cython
from cpython cimport PyObject
from libc.stdlib cimport malloc, free


cdef extern from *:
    """
    #define SORT_TYPE PyObject*

    int comparePython(PyObject **x, PyObject **y) {
        if (PyObject_RichCompareBool(*x, *y, Py_LT))
            return -1;
        else if (PyObject_RichCompareBool(*x, *y, Py_GT))
            return 1;
        return 0;
    }

    #define SORT_CMP(x, y) comparePython(x, y)
    """

cdef extern from "GrailSort/GrailSort.h":
    cdef void GrailSort(PyObject **arr, int Len) nogil
    cdef void GrailSortWithBuffer(PyObject **arr, int Len) nogil
    cdef void GrailSortWithDynBuffer(PyObject **arr, int Len) nogil
    cdef void RecStableSort(PyObject **arr, int Len) nogil


def grailsort(list array):
    cdef int length = len(array)
    cdef PyObject **grail_arr

    grail_arr = <PyObject **>malloc(length*cython.sizeof(PyObject))
    if grail_arr is NULL:
        raise MemoryError()

    for i in range(length):
        grail_arr[i] = <PyObject *>array[i]

    GrailSort(grail_arr, length)

    for i in range(length):
        array[i] = <object>grail_arr[i]


def grailsort_buffer(list array):
    cdef int length = len(array)
    cdef PyObject **grail_arr

    grail_arr = <PyObject **>malloc(length*cython.sizeof(PyObject))
    if grail_arr is NULL:
        raise MemoryError()

    for i in range(length):
        grail_arr[i] = <PyObject *>array[i]

    GrailSortWithBuffer(grail_arr, length)

    for i in range(length):
        array[i] = <object>grail_arr[i]


def grailsort_dynbuffer(list array):
    cdef int length = len(array)
    cdef PyObject **grail_arr

    grail_arr = <PyObject **>malloc(length*cython.sizeof(PyObject))
    if grail_arr is NULL:
        raise MemoryError()

    for i in range(length):
        grail_arr[i] = <PyObject *>array[i]

    GrailSortWithDynBuffer(grail_arr, length)

    for i in range(length):
        array[i] = <object>grail_arr[i]
# 
# 
def rotate_merge_sort(list array):
    cdef int length = len(array)
    cdef PyObject **grail_arr

    grail_arr = <PyObject **>malloc(length*cython.sizeof(PyObject))
    if grail_arr is NULL:
        raise MemoryError()

    for i in range(length):
        grail_arr[i] = <PyObject *>array[i]

    RecStableSort(grail_arr, length)

    for i in range(length):
        array[i] = <object>grail_arr[i]
