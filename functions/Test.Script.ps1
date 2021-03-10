if(!$args[0]){
    vendor/bin/phpunit
}else{
    $param = $args[1]
    switch ($args[0]) {
        'ignore'{
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
        'include'{
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
        'make'{
            $file = 'phpunit.xml'
            $regex = '( *)<!--TEST SUITES-->'
            $tag = 'file'
            $param = $param.TrimEnd('\').TrimEnd('/') -replace '\\', '/'
            $result = (Get-Content $file) -replace $regex, ("`$1<!--TEST SUITES-->`n`r`$1<testsuite name=`"$param`">`n`$1    <directory suffix=`".php`">./tests/$param/</directory>`n`$1</testsuite>")
            Set-Content $file $result
            Write-Output "Testsuite generated in 'Tests/$param'"
            New-Item -ItemType Directory -Force -Path "./tests/$param"
        }
        'cover' {
            vendor/bin/phpunit --coverage-html tests/Coverage
            Start-Process './tests/Coverage/index.html'
        }
        Default {
            $file = Get-Content 'phpunit.xml'
            $testSuite = $args[0].Trim('.').Trim('/').Trim('\\')
            $xmlFormat = '<testsuite name="' + $testSuite + '">'
            $containsWord = $file | %{$_ -match $xmlFormat}
            if($containsWord -contains $true){
                vendor/bin/phpunit --testsuite $testSuite
            }else{
                $regex = [regex]::new('<testsuite *name="(' + $testSuite + '.*)">')
                $found = @();
                $file |%{
                    $match = $regex.Matches($_)
                    if($match){
                        $found += @(,$match.Groups[1].Value)
                    }
                }
                if($found.Length -eq 1){
                    $confirmation = Read-Host "Did you mean '$($found[0])'? [y/n]"
                    if ($confirmation -eq 'y') {
                        vendor/bin/phpunit --testsuite $found[0]
                    }else{
                        Write-Host 'Aborting test...' -foreground red
                        Write-Host ''
                    }
                }elseif($found.length -gt 1){
                    Write-Host 'Test aborted.' -foreground red
                    Write-Host "Multiple test cases found matching the pattern '$($testSuite)*' please specify one of:" -foreground yellow
                    Write-Host ($found -join ", ")
                }
            }
        }
    }
}