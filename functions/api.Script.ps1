if(!$args[0]){
    Write-Host "Name of the resource is missing" -ForegroundColor Red
    exit
}

$model = $args[0]
$template = "$Global:rootFolder\Laravel\templates\ApiModel\"
$time = (Get-Date -Format "yyyy_MM_dd_HHmmss").ToString()

Get-ChildItem $template -Recurse -Force | Where-Object {
    $_.Directory
} | Select-Object FullName | ForEach-Object {
    $out = ($pwd.ToString() + "\" + (((($_.FullName -replace [Regex]::Escape($template), "") -creplace "Dummy", $model) -creplace "dummy", $model.ToString().ToLower()) -replace "NOW", $time ).ToString())

    $content = (Get-Content $_.FullName) -join "`n"
    $content = (($content -creplace "Dummy", $model) -creplace "dummy", $model.ToString().ToLower())
    if(Test-Path $out){
        Write-Host ""
        Write-Host "The file '$out' already exists. Please chose your action:" -ForegroundColor Red
        Write-Host "- Skip this file and continue (s)" -ForegroundColor Red
        Write-Host "- Force-Overwrite this file and continue (f)" -ForegroundColor Red
        Write-Host "- Stop the execution of this script and exit (e)" -ForegroundColor Red
        $confirmation = Read-Host "Your action (default is exit): [s/f/e]"
        if ($confirmation -eq 's') {
        }
        elseif ($confirmation -eq 'f')
        {
            Write-Host ("Generated: $out") -ForegroundColor Yellow
            Set-Content -Path $out -Value $content -Force
        }
        else
        {
            exit
        }
    }else{
        Write-Host ("Generated: $out") -ForegroundColor Green
        Set-Content -Path $out -Value $content
    }
}
$globalEnv = Import-Env "$Global:rootFolder\Laravel\lumen.env"
Invoke-Expression ($globalEnv.IDE + ' .\database\seeders\DatabaseSeeder.php')
Invoke-Expression ($globalEnv.IDE + ' .\routes\api.php')