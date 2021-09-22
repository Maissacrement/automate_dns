from .initiatorAbs import *

class LocalconfInitiator(InitiatorAbs):

    def __init__(self):
        self.resolver=''

    def zone(self, DNS_BASE, DNS, typeDNS='master', defaultPathDNS='/etc/bind'):
        self.resolver= str(self.resolver) + f"zone \"{DNS}\" {{ \n\ttype {typeDNS};\
          \n\tfile \"{defaultPathDNS}/{DNS_BASE}\";\
        \n}};\n"

    def append(self, DNS, IP, typeDNS='master', defaultPathDNS='/etc/bind'):
        # DEFINE ZONE
        DNS_BASE='.'.join(DNS.split('.')[1:])
        self.zone(DNS, DNS_BASE, typeDNS, defaultPathDNS)

        # DEFINE REVERSE ZONE
        REVERSED_IP='.'.join([str(rip) for rip in (IP.split('.')[-2::-1]) ])
        self.zone(f"www.{REVERSED_IP}", f"{REVERSED_IP}.in-addr.arpa", typeDNS, defaultPathDNS)


#p=LocalconfInitiator()
#p.append("www.tobelucky.fr", "172.10.0.0")
#print(p.resolver)