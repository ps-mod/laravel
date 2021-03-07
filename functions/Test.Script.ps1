if(!$args[0]){
    vendor/bin/phpunit
}
elseif (($args[0] -eq 'cover') -or ($args[0] -eq 'c')) {
    vendor/bin/phpunit --coverage-html tests/Coverage
    Start-Process './tests/Coverage/index.html'
}
elseif($args[0] -eq 'ignore'){
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
elseif($args[0] -eq 'include'){
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