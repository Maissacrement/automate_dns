from .initiatorAbs import *

class DnsInitiator(InitiatorAbs):

    def __init__(self, DNS_BASE, DNS, origin=True):
        self.acl="""acl "interneGSB" { 172.17.0.0/24; };"""