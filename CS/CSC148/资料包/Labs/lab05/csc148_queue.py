class Queue:
    ''' Represent a FIFO queue.
    '''

    def __init__(self):
        ''' (Queue) -> NoneType

        Create and initialize new queue self.
        '''
        self._data = []

    def enqueue(self, o):
        ''' (Queue, object) -> NoneType

        Add o at the back of this queue.
        '''
        self._data.append(o)

    def dequeue(self):
        ''' (Queue) -> object

        Remove and return front object from self.

        >>> q = Queue()
        >>> q.enqueue(3)
        >>> q.enqueue(5)
        >>> q.dequeue()
        3
        '''
        return self._data.pop(0)

    def is_empty(self):
        ''' (Queue) -> bool

        Return True queue self is empty, False otherwise.

        >>> q = Queue()
        >>> q.enqueue(5)
        >>> q.is_empty()
        False
        >>> q.dequeue()
        5
        >>> q.is_empty()
        True
        '''
        return self._data == []


if __name__ == '__main__':
    import doctest
    doctest.testmod()