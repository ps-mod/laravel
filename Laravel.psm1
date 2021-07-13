function lumen {
    param (
        [Parameter(Mandatory=$True, Position = 0)]
        [string]
        $innerFunction,

        [Parameter(Mandatory=$false, ValueFromRemainingArguments=$true, Position = 1)]
        [string[]]
        $params
    )
    $ErrorActionPreference = "Inquire"

    switch($innerFunction){
        'admin'{
            $globalEnv = Import-Env "$Global:rootFolder/Laravel/lumen.env"
            Start-Process -FilePath $globalEnv.SQL_ADMIN
            break
        }
        'conf'{
            code "$Global:rootFolder/Laravel/lumen.env"
            break
        }
        'compose' {
            $dusk = $false
            if(!(Test-Path '.env')){
                Copy-Item '.env.example' '.env'
                Write-Host 'Configuration not found (``.env`` file). Creating from ``.env.example``.'
                Write-Host "Please ensure you already have a database with the name configured in ``.env`` before continue."
                Read-Host "Press ENTER to continue"
                $dusk = $True
                
            }
            composer install
            if($IsLinux){
                sudo chmod -R 777 storage/
            }
            php artisan key:generate
            yarn
            php artisan migrate:fresh --seed
            yarn run development
            if($dusk){
                lumen vhosts reg
                lumen hosts reg
            }
            break
        }
        'repack' {
            Remove-Item -r -Force ./node_modules
            Remove-Item -r -Force ./vendor
            lumen compose
        }
        'db:fresh' {
            php artisan migrate:fresh
            break
        }
        'coverage'{
            Start-Process ".\tests\Coverage\index.html"
            break
        }
        'model'{
            $fixed = ([string]$params).substring(0,1).toupper()+([string]$params).substring(1).tolower()
            php artisan make:model $fixed -a -r
            php artisan make:request ${fixed}Request
        }
        'clear'{
            php artisan cache:clear
            php artisan config:clear
            php artisan route:clear
            Get-ChildItem -Path  './storage/framework/views' -Recurse -exclude '*.gitignore' |
            Select -ExpandProperty FullName |
            Where {$_ -notlike '*.gitignore'} |
            sort length -Descending |
            Remove-Item -force 
            Write-Host "View cache cleared!" -foreground green
        }
        {$_ -in ('test', 'vhosts', 'hosts', 'sql', 'git-log', 'xdebug', 'pre', 'api', 'init')} {
            Run-Script "Laravel/functions/$innerFunction" $params
            break
        }
        {$_ -in ('db:refresh', 'db')} {
            php artisan migrate:fresh --seed
            break
        }
        {$_ -in ('compile', 'c')}{
            yarn run development
            break
        }
        default {
            $a = $PsBoundParameters.Values + $args
            php artisan $a
            break
        }
    }
    
}

Export-ModuleMember -Function lumen