from .initiatorAbs import *

class DnsInitiator(InitiatorAbs):

    def __init__(self, DNS_BASE, DNS, origin=True):
        self.origin='$ORIGIN {}.\n'.format(DNS_BASE) if origin else ''
        self.dns=f"""{self.origin}$TTL 1D
@       IN      SOA     {DNS}. root.{DNS_BASE}. (
        2006031201      ; serial
        28800           ; refresh
        14400           ; retry
        3600000         ; expire
        86400 )         ; minimum
        NS              {DNS}."""

    def append(self, name, ip, type="A"):
        self.dns=str(self.dns)+ f"\n{name}\t{type} {ip}"


#DNS_BASE='tobelucky.fr'
#DNS='www.{}'.format(DNS_BASE)
#init=DnsInitiator(DNS_BASE, DNS)
#init.append('www', '172.17.0.3')
#init.append('front', '172.17.20.1', 'CNAME')
#print(init.dns)