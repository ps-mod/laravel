function Get-ServerName {
    $hash = Import-Env ".env"
    return $hash.APP_URL -replace 'https?://', ''
}

function Add-Vhosts {
    $dir = $pwd -replace '\\', '/'
    $content = "`n`n" +
            '<VirtualHost *:80>
        ServerName '+ (Get-ServerName) + '
        DocumentRoot "' + $dir + '/public"
        SetEnv APPLICATION_ENV "development"
        <Directory "' + $dir + '">
            DirectoryIndex index.php
            AllowOverride All
            Order allow,deny
            Allow from all
        </Directory>
    </VirtualHost>'
    $globalEnv = Import-Env "$Global:rootFolder\Laravel\lumen.env"
    Add-Content -Path $globalEnv.VHOSTS -Value $content
}

function Add-Hosts {
    $content = "`n" +
            '127.0.0.1 '+ (Get-ServerName)
    $globalEnv = Import-Env "$Global:rootFolder\Laravel\lumen.env"
    Add-Content -Path $globalEnv.HOSTS -Value $content
}

Export-ModuleMember -Function Get-ServerName, Add-Vhosts, Add-Hosts