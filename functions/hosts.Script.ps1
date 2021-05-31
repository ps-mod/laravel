if($args.Length -gt 0){
    if(($args[0] -eq 'reg') -or $args[0] -eq 'register'){
        Import-Module "$global:rootFolder/Laravel/functions/VirtualHosting.psm1"
        Add-Hosts
        Remove-Module VirtualHosting
    }else{
        $globalEnv = Import-Env "$Global:rootFolder\Laravel\lumen.env"
        $command = ($globalEnv.CODE + " " + $globalEnv.HOSTS)
        Invoke-Expression $command
    }
}else{
    $globalEnv = Import-Env "$Global:rootFolder\Laravel\lumen.env"
    $command = ($globalEnv.CODE + " " + $globalEnv.HOSTS)
    Invoke-Expression $command
}