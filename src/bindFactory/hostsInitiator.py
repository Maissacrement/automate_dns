from .initiatorAbs import *

class HostsInitiator(InitiatorAbs):

    def __init__(self, webHost):
        self.payload=''
        self.webHost=webHost

    def append(self, name, ip):
        self.payload+=f"\n{ip}\t{name} {name}.{self.webHost}"


#host=HostsInitiator('tobelucky.fr')
#host.append('backend', '172.100.20.70')
#host.append('backend', '172.100.20.70')
#print(host.payload)

#DNS_BASE='tobelucky.fr'
#DNS='www.{}'.format(DNS_BASE)
#init=DnsInitiator(DNS_BASE, DNS)
#init.append('www', '172.17.0.3')
#init.append('front', '172.17.20.1', 'CNAME')
#print(init.dns)