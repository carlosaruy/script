function LDAPSearch {
    param (
        [string]$LDAPQuery
    )

    $PDC = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().PdcRoleOwner.Name
    $DistinguishedName = ([adsi]'').distinguishedName

    $DirectoryEntry = New-Object System.DirectoryServices.DirectoryEntry("LDAP://$PDC/$DistinguishedName")

    $DirectorySearcher = New-Object System.DirectoryServices.DirectorySearcher($DirectoryEntry, $LDAPQuery)

    return $DirectorySearcher.FindAll()

}

function Get-GroupTree {
    param (
        [Parameter(Mandatory)]
        [object]$Groups,
        [int]$IndentLevel = 0
    )

    foreach ($group in $Groups) {
        # Mostrar el grupo principal
        $groupName = $group.Properties.cn
        Write-Output (" " * $IndentLevel + "GRUPO: " + $groupName)

        # Obtener los miembros del grupo
        $members = $group.Properties.member

        if ($members) {
            foreach ($member in $members) {
                # Buscar el objeto del miembro
                try {
                    $memberObject = [ADSI]"LDAP://$member"
                } catch {
                    Write-Output (" " * ($IndentLevel + 2) + "(Error resolving member: $member)")
                    continue
                }

                # Determinar el tipo del miembro
                $objectClass = $memberObject.Properties["objectClass"]

                if ($objectClass -contains "group") {
                    # Mostrar el grupo anidado
                    Write-Output (" " * ($IndentLevel + 2) + ".+" + $($memberObject.Properties["cn"][0]))
                    # Procesar recursivamente el grupo anidado
                    Get-GroupTree -Groups @($memberObject) -IndentLevel ($IndentLevel + 4)
                } elseif ($objectClass -contains "user") {
                    # Mostrar el usuario
                    Write-Output (" " * ($IndentLevel + 2) + ".-" + $($memberObject.Properties["cn"][0]))
                } else {
                    # Miembro no identificado
                    Write-Output (" " * ($IndentLevel + 2) + "(Unknown member type: $member)")
                }
            }
        } else {
            Write-Output (" " * ($IndentLevel + 4) + "(No members found)")
        }
    }
}

