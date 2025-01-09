# Store the domain object in the $domainObj variable
$domainObj = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()

# Print the variable
#$domainObj

# Store the PdcRoleOwner name to the $PDC variable
$PDC = $domainObj.PdcRoleOwner.Name

# Print the $PDC variable
#$PDC

# Store the Distinguished Name variable into the $DN variable
$DN = ([adsi]'').distinguishedName

# Print the $DN variable
#$DN

# Store the $PDC and $DN variables, prefixed with "LDAP://" to use the LDAP ADsPath in order to communicate with the AD service. 
# LDAP://HostName[:PortNumber][/DistinguishedName]
# if the port is not the default, the path must be changed 

$LDAP = "LDAP://$PDC/$DN"
#$LDAP

# creates a directoryEntry Object, referenciates to root, because $LDAP variable referenciates to root. 
$direntry = New-Object System.DirectoryServices.DirectoryEntry($LDAP)

#from that directory entry, creates a object DirectorySearcher, to find objects from this point.
# $direntry is the root, then, the next list will print all objects from this AD.

$dirsearcher = New-Object System.DirectoryServices.DirectorySearcher($direntry)

#add a filter samAccountType 0x30000000 (decimal 805306368) to enumerate only all users 

$dirsearcher.filter="samAccountType=805306368"

# now iterates in all object retrieved, and prints line by line the properties for each.
#$dirsearcher.FindAll()

$result = $dirsearcher.FindAll()

Foreach($obj in $result)
{
    Foreach($prop in $obj.Properties)
    {
        $prop
    }

    Write-Host "-------------------------------"
}
