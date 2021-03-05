function test  {
    param(
        # Function
        [Parameter(Mandatory=$false)]
        $innerFunc,

        # Function
        [Parameter(Mandatory=$false)]
        $param
    )
    if(!$innerFunc){
        vendor/bin/phpunit
    }
    elseif (($innerFunc -eq 'cover') -or ($innerFunc -eq 'c')) {
        vendor/bin/phpunit --coverage-html tests/Coverage
        Start-Process './tests/Coverage/index.html'
    }
    elseif($innerFunc -eq 'ignore'){
        $file = 'phpunit.xml'
        $regex = '( *)<!-- Excluded directories -->'
        $tag = 'file'
        if((Get-Item $param) -is [System.IO.DirectoryInfo]){
            $tag = 'directory'
        }
        $param = $param.TrimEnd('\').TrimEnd('/') -replace '\\', '/'
        $result = (Get-Content $file) -replace $regex, "`$1<!-- Excluded directories -->`n`$1<$tag>$param</$tag>" # | Write-Host #Set-Content $file
        Set-Content $file $result
        Write-Output "Coverage test will ignore $tag '$param'"
    }
    elseif($innerFunc -eq 'include'){
        $file = 'phpunit.xml'
        $regex = '( *)<!-- Included directories -->'
        $tag = 'file'
        if((Get-Item $param) -is [System.IO.DirectoryInfo]){
            $tag = 'directory'
        }
        $param = $param.TrimEnd('\').TrimEnd('/') -replace '\\', '/'
        $result = (Get-Content $file) -replace $regex, "`$1<!-- Included directories -->`n`r`$1<$tag>$param</$tag>" # | Write-Host #Set-Content $file
        Set-Content $file $result
        Write-Output "Coverage test will include $tag '$param'"
    }
    else {
        Write-Error 'Unknown command'
    }
}

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
    Add-Content -Path $Global:LumenAPI_ENV.VHOSTS -Value $content
}

function Add-Hosts {
    $content = "`n" + 
    '127.0.0.1 '+ (Get-ServerName)
    Add-Content -Path $Global:LumenAPI_ENV.HOSTS -Value $content
}

function lumen {
    param (
        # Function
        [Parameter(Mandatory=$True, Position = 0)]
        [string]
        $func,

        [Parameter(
            Mandatory=$false,
            ValueFromRemainingArguments=$true,
            Position = 1
        )][string[]]
        $params
    )
    $ErrorActionPreference = "Inquire"
    $Global:LumenAPI_ENV = Import-Env "$PSScriptRoot\lumen.env"
    if(!$func){
        php artisan
    }
    elseif ($func -eq 'admin') {
        Start-Process -FilePath $Global:LumenAPI_ENV.SQL_ADMIN
    }
	elseif ($func -eq 'conf'){
		code "$PSScriptRoot\lumen.env"
	}
    elseif (($func -eq 'compose')) {
        composer install
        yarn
        php artisan migrate:fresh --seed
        yarn run development
    }
    elseif (($func -eq 'db:refresh') -or ($func -eq 'db')) {
        php artisan migrate:fresh --seed
    }
	elseif ($func -eq 'db:fresh') {
        php artisan migrate:fresh
    }
    elseif(($func -eq 'compile') -or ($func -eq 'c')){
        yarn run development
    }
    elseif($func -eq 'coverage'){
        Start-Process ".\tests\Coverage\index.html"
    }
    elseif($func -eq 'test'){
        if($params.Length -eq 1){
            test($params[0])
        }
        elseif($params.Length -eq 2){
            test $params[0] $params[1]
        }
        else {
            test
        }
    }
    elseif ($func -eq 'vhosts'){
        if($params.Length -gt 0){
            if(($params[0] -eq 'reg') -or $params[0] -eq 'register'){
                Add-Vhosts
            }
        }
        else{
            code $Global:LumenAPI_ENV.VHOSTS
        }
    }elseif ($func -eq 'hosts') {
        if($params.Length -gt 0){
            if(($params[0] -eq 'reg') -or $params[0] -eq 'register'){
                Add-Hosts
            }
        }
        else{
            code $Global:LumenAPI_ENV.HOSTS
        }  
    }
    elseif ($func -eq 'sql') {
        $hash = Import-Env ".env"
        $arguments = ("-u "+ $hash.DB_USERNAME, "--database " + $hash.DB_DATABASE)
        if($hash.DB_PASSWORD){
            $arguments = ("-u "+ $hash.DB_USERNAME, "-p " + $hash.DB_PASSWORD ,"--database " + $hash.DB_DATABASE)
        }
        Start-Process $Global:LumenAPI_ENV.SQL -ArgumentList ("-u "+ $hash.DB_USERNAME, "--database " + $hash.DB_DATABASE) -NoNewWindow -Wait
    }
    else {
        $a = $PsBoundParameters.Values + $args
        php artisan $a
    }
    
}

Export-ModuleMember -Function New-Laravel, New-Lumen, lumen