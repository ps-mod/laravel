$localEnv = Import-Env ".env"
$globalEnv = Import-Env "$Global:rootFolder\Laravel\lumen.env"
$arguments = ("-u "+ $localEnv.DB_USERNAME, "--database " + $localEnv.DB_DATABASE)
if($localEnv.DB_PASSWORD){
    $arguments = ("-u "+ $localEnv.DB_USERNAME, "-p " + $localEnv.DB_PASSWORD ,"--database " + $localEnv.DB_DATABASE)
}
Start-Process $globalEnv.SQL -ArgumentList ("-u "+ $localEnv.DB_USERNAME, $arguments) -NoNewWindow -Wait