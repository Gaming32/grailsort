# distutils: language = c++

"""This grailsort module works with any Python sequence
which contain any comparable Python objects

grailsort(array: Sequence)
grailsort_buffer(array: Sequence)
grailsort_dynbuffer(array: Sequence)
grailsort(array: Sequence, buff: Sequence)
rotate_merge_sort(array: Sequence)

This module operates by copying all the Python objects in
the sequence into a C array. It then sorts the C array and
copies the C array back into the Python sequence. This is
slower than cGrailSort, especially in multithreaded situations
because it cannot release the GIL as it deal with Python objects."""


cimport cython
from cpython cimport PyObject
from cpython.mem cimport PyMem_Malloc, PyMem_Free
from cpython.ref cimport Py_INCREF, Py_DECREF


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
    cdef void GrailSort(PyObject **arr, int Len)
    cdef void GrailSortWithBuffer(PyObject **arr, int Len)
    cdef void GrailSortWithDynBuffer(PyObject **arr, int Len)
    cdef void grail_commonSort(PyObject **arr, int Len, PyObject **extbuf, int LExtBuf)
    cdef void RecStableSort(PyObject **arr, int Len)


cdef PyObject** create_c_array(object array, int length):
    cdef PyObject **carr

    carr = <PyObject **>PyMem_Malloc(length*cython.sizeof(&carr))
    if carr is NULL:
        raise MemoryError()

    cdef int i
    for i in range(length):
        carr[i] = <PyObject *>array[i]
        Py_INCREF(array[i])
    
    return carr


cdef void dealloc_c_array(object array, PyObject **carr, int length):
    cdef int i
    for i in range(length):
        array[i] = <object>carr[i]
        Py_DECREF(array[i])
    PyMem_Free(carr)


def grailsort(object array):
    "grailsort(array: Sequence)"
    cdef int length = len(array)
    if length <= 1: # Already sorted
        return
    cdef PyObject **grail_arr = create_c_array(array, length)

    GrailSort(grail_arr, length)

    dealloc_c_array(array, grail_arr, length)


def grailsort_buffer(object array):
    "grailsort_buffer(array: Sequence)"
    cdef int length = len(array)
    if length <= 1: # Already sorted
        return
    cdef PyObject **grail_arr = create_c_array(array, length)

    GrailSortWithBuffer(grail_arr, length)

    dealloc_c_array(array, grail_arr, length)


def grailsort_dynbuffer(object array):
    "grailsort(array: Sequence)"
    cdef int length = len(array)
    if length <= 1: # Already sorted
        return
    cdef PyObject **grail_arr = create_c_array(array, length)

    GrailSortWithDynBuffer(grail_arr, length)

    dealloc_c_array(array, grail_arr, length)


def grailsort_common(object array, object buff):
    "grailsort(array: Sequence, buff: Sequence)"
    cdef int length = len(array)
    if length <= 1: # Already sorted
        return
    cdef PyObject **grail_arr = create_c_array(array, length)

    cdef int buflen = len(buff) if buff is not None else 0
    cdef PyObject **grail_buff
    if not buflen:
        grail_buff = NULL
    else:
        grail_buff = create_c_array(buff, buflen)

    grail_commonSort(grail_arr, length, grail_buff, buflen)

    dealloc_c_array(array, grail_arr, length)


def rotate_merge_sort(object array):
    "rotate_merge_sort(array: Sequence)"
    cdef int length = len(array)
    if length <= 1: # Already sorted
        return
    cdef PyObject **grail_arr = create_c_array(array, length)

    RecStableSort(grail_arr, length)

    dealloc_c_array(array, grail_arr, length)
