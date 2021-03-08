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
            $globalEnv = Import-Env "$Global:rootFolder\Laravel\lumen.env"
            Start-Process -FilePath $globalEnv.SQL_ADMIN
            break
        }
        'conf'{
            code "$Global:rootFolder\Laravel\lumen.env"
            break
        }
        'compose' {
            composer install
            yarn
            php artisan migrate:fresh --seed
            yarn run development
            break
        }
        'db:fresh' {
            php artisan migrate:fresh
            break
        }
        'coverage'{
            Start-Process ".\tests\Coverage\index.html"
            break
        }
        {$_ -in ('test', 'vhosts', 'hosts', 'sql', 'git-log')} {
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