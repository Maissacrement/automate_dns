from abc import ABCMeta, abstractstaticmethod

class InitiatorAbs(metaclass=ABCMeta):

    @abstractstaticmethod
    def __init__(self, **kargs):
        pass
    
    @abstractstaticmethod
    def append(self, **kargs):
        pass