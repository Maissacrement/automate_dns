#!/usr/bin/python3.8
from src.bindFactory.dnsInitiator import DnsInitiator
from src.bindFactory.hostsInitiator import HostsInitiator
from src.bindFactory.localconfInitiator import LocalconfInitiator
from src.bindFactory.resolverInitiator import ResolverInitiator
from loadenv import targetStartswithEnv, truncDomainAndIPV4, getEnviron

# Load environment variables
from dotenv import load_dotenv
load_dotenv()

def write(name, content, mode="w"):
    f = open(name, mode)
    f.write(content)
    f.close()

if __name__ == "__main__":
    IP=getEnviron('IP') or '172.17.0.3'
    CIDR=getEnviron('CIDR') or '172.17.0.0/24'
    DNS_BASE=getEnviron('DNS_BASE') or 'tobelucky.fr'
    DNS=getEnviron('DNS') or 'www.{}'.format(DNS_BASE)
    ETC=getEnviron('ETC') or '/etc'
    BIND_DIR=getEnviron('BIND_DIR') or '/{}/bind'.format(ETC)
    HOSTS_DIR="/etc/hosts"

    dnsName = sorted(targetStartswithEnv('DNS', ['DNS_BASE']))
    subdomainAndIPV4 = truncDomainAndIPV4(dnsName)

    dnsToStr=lambda name: '{}.{}'.format(subdomainAndIPV4[dnsName.index(name)][0], getEnviron('DNS_BASE'))

    if getEnviron('DNS1') and DNS_BASE:

        # DNS 0
        # Master
        base=DnsInitiator(DNS_BASE, dnsToStr('DNS1'))
        host=HostsInitiator(DNS_BASE)
        def append(subdomain, ipv4):
            host.append(subdomain, ipv4) 
            base.append(subdomain, ipv4)


        [append(subdomain, ipv4) for (subdomain, ipv4) in subdomainAndIPV4]
        write('{}/{}'.format(BIND_DIR, 'www.{}'.format(getEnviron('DNS_BASE'))), base.dns)
        write('{}'.format(HOSTS_DIR), host.payload, 'a')

        # Reverse
        base=DnsInitiator(DNS_BASE, DNS, origin=False)
        base.append('www', 'www.{}'.format(getEnviron('DNS_BASE')), 'PTR')
        write('{}/www.{}'.format(BIND_DIR, '.'.join(IP.split('.')[-2::-1])), base.dns)

        localconf=LocalconfInitiator()
        localconf.append(DNS, CIDR.split('/')[:1][0])
        write('{}/{}'.format(BIND_DIR, 'named.conf.local'), localconf.resolver)

        resolve=ResolverInitiator()
        resolve.append("tobelucky.fr", IP)
        write('{}/{}'.format(ETC, 'resolv.conf'), resolve.resolver)




