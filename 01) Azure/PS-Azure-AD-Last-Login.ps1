# Importar el módulo AzureAD o AzureADPreview según sea necesario
if (-not (Get-Module -Name AzureAD -ListAvailable)) {
    Install-Module -Name Az -AllowClobber -Force -Scope CurrentUser
}

# Importar el módulo Az o AzureADPreview según sea necesario
Import-Module Az

# Conectar a Azure AD (iniciar sesión)
Connect-AzAccount

# Obtener la información de todos los usuarios con paginación
$usuarios = Get-AzureADUser -All $true -Top 500 # Ajusta el valor de -Top según sea necesario

# Crear una lista para almacenar los resultados
$resultados = @()

# Recorrer todos los usuarios
foreach ($usuario in $usuarios) {
    $infoUsuario = [PSCustomObject]@{
        'Display Name' = $usuario.DisplayName
        'UserPrincipalName' = $usuario.UserPrincipalName
        'Last Logon' = $usuario.LastLogonTime
    }

    # Agregar información del usuario a la lista
    $resultados += $infoUsuario
}

# Exportar la lista a un archivo CSV
$resultados | Export-Csv -Path 'D:\Usuarios_LastLogon.csv' -NoTypeInformation

Write-Host "La información de inicio de sesión de todos los usuarios se ha exportado a Usuarios_LastLogon.csv"
