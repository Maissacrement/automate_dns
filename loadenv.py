import os

def targetStartswithEnv(envName, listOfRemovedElement=[]):
    return [env for env in os.environ if env.startswith(envName) and env not in listOfRemovedElement and env]

def truncDomainAndIPV4(envList):
    return [os.environ[envName].split(':') for envName in envList]

def getEnviron(name):
    return os.environ[name] if name in os.environ else None