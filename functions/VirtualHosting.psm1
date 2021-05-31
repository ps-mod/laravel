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
    $globalEnv = Import-Env "$Global:rootFolder/Laravel/lumen.env"

    try {
        Add-Content -Path (Resolve-Path -Path $globalEnv.VHOSTS) -Value $content -ErrorAction Stop
    }
    catch {
        if($IsLinux){
            $vh = $globalEnv.VHOSTS
            sudo pwsh -Command "Add-Content -Path (Resolve-Path -Path '$vh') -Value '$content'"
        }
    }
}

function Add-Hosts {
    $content = "`n" + '127.0.0.1 '+ (Get-ServerName)
    $globalEnv = Import-Env "$Global:rootFolder\Laravel\lumen.env"
    $content | clip
    Write-Host "Please add this to your hosts file: ``$content``. Copied to clipboard"
    $command = ($globalEnv.CODE + " " + $globalEnv.HOSTS)
    Invoke-Expression $command
}

Export-ModuleMember -Function Get-ServerName, Add-Vhosts, Add-Hosts