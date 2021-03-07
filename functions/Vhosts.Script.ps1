if($args.Length -gt 0){
    if(($args[0] -eq 'reg') -or $args[0] -eq 'register'){
        Import-Module "$global:rootFolder/Laravel/functions/VirtualHosting.psm1"
        Add-Vhosts
        Remove-Module VirtualHosting
    }else{
        $globalEnv = Import-Env "$Global:rootFolder\Laravel\lumen.env"
        code $globalEnv.VHOSTS
    }
}else{
    $globalEnv = Import-Env "$Global:rootFolder\Laravel\lumen.env"
    code $globalEnv.VHOSTS
}