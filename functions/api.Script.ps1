if(!$args[0]){
    Write-Host "Name of the resource is missing" -ForegroundColor Red
    exit
}

$model = $args[0]

Get-ChildItem "$Global:rootFolder\Laravel\templates\ApiModel" -Recurse -Force | Where-Object {
    $_.Directory
} | Select-Object FullName | ForEach-Object {
    Write-Output (((($_.FullName -replace [Regex]::Escape("$Global:rootFolder\Laravel\templates\ApiModel"), "") -creplace "Dummy", $model) -creplace "dummy", $model.ToString().ToLower()) -replace )
}