para cargar powershell y que se puedan ejecutar script, cargar: 
powershell -ep bypass

para obtener el nombre distintivo (distinguished name)
([adsi]'').distinguishedName 


uso de funcion.ps1
primero importar la funcion

Import-Module .\function.ps1

enumerar grupos
LDAPSearch -LDAPQuery "(objectclass=group)"

enumerar usuarios
LDAPSearch -LDAPQuery "(samAccountType=805306368)"

imprimir las propiedades de los grupos

foreach ($group in $(LDAPSearch -LDAPQuery "(objectCategory=group)")) {
 $group.properties | select {$_.cn}, {$_.member}
 }


tomar un grupo y asignarlo a una variable: en este ejemplo el grupo "Sales Departament"
$sales = LDAPSearch -LDAPQuery "(&(objectCategory=group)(cn=Sales Department))"

para mostrar un valor del objeto:
$sales.properties.member

se agrega una funcion para mostrar el arbol de grupos, explicitando grupos anidados
# ejemplo de uso del árbol de grupos
$groups = LDAPSearch -LDAPQuery "(objectclass=group)"
Get-GroupTree -Groups $groups
