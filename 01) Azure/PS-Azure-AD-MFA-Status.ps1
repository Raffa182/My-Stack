# Importar el módulo de MSOnline
Import-Module MSOnline

# Conectar a Azure AD
Connect-MsolService

# Obtener usuarios y su estado MFA
$usuarios = Get-MsolUser -All | Select-Object DisplayName, UserPrincipalName, @{Name="MFAStatus";Expression={(Get-MsolUser -UserPrincipalName $_.UserPrincipalName).StrongAuthenticationRequirements.State}}

# Exportar a CSV
$usuarios | Export-Csv -Path "D:\UsuariosMFA.csv" -NoTypeInformation -Encoding utf8

Write-Host "La información sobre los usuarios y su estado MFA ha sido exportada a UsuariosMFA.csv"
