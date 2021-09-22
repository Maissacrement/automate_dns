from .initiatorAbs import *

class ResolverInitiator(InitiatorAbs):

    def __init__(self):
        self.resolver=''

    def append(self, DNS_BASE, IP):
        self.resolver= str(self.resolver) + f"""search {DNS_BASE}\nnameserver {IP}\n"""


#p=ResolverInitiator()
#p.append("tobelucky.fr", '172.17.0.3')
#
#print(p.resolver)