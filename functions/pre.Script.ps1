$fixes = @()

Write-Output 'Testing prerequisites:'
Write-Output '----------------------'

if (Get-Command 'php' -errorAction SilentlyContinue)
{
    Write-Host "- PHP is installed" -ForegroundColor Green
    if([bool]((php -v) -match 'PHP (8\.[0-9]+\.[0-9]+)')){
        Write-Host "- PHP version is correct" -ForegroundColor Green
    }else{
        Write-Host "- You are using an older version of PHP. Some of the functions might not work as expected." -ForegroundColor Yellow
    }
}else{
    if($IsLinux -and (Test-Path '/opt/lampp/bin/php')){
        Write-Host "- PHP command is not available but found lampp installation in '/opt/lampp/bin/php'. You should create a symbolic link to it." -ForegroundColor Yellow
        $fixes += 'symbolic'
    }elseif(Test-Path 'C:\xampp\php'){
        Write-Host "- PHP command is not available but found xampp installation in 'C:\xampp\php'. You should add it to your PATH variable" -ForegroundColor Yellow
        $fixes += 'path'
    }
    Write-Host "- PHP is NOT installed or not in your PATH variable" -ForegroundColor Red
}

if (Get-Command 'composer' -errorAction SilentlyContinue)
{
    Write-Host "- Composer is installed" -ForegroundColor Green
}else{
    Write-Host "- Composer is NOT installed. Go to 'https://getcomposer.org/' and install it." -ForegroundColor Red
}

if (Get-Command 'node' -errorAction SilentlyContinue)
{
    Write-Host "- Node.js is installed" -ForegroundColor Green
}else{
    Write-Host "- Node.js is NOT installed. Go to 'https://nodejs.org/' and install it." -ForegroundColor Red
}

if (Get-Command 'yarn' -errorAction SilentlyContinue)
{
    Write-Host "- Yarn is installed" -ForegroundColor Green
}else{
    Write-Host "- Yarn is NOT installed. Go to 'https://nodejs.org/' and install it." -ForegroundColor Red
}

if($fixes){
    Write-Host ""
    Write-Host "Fixing PHP command problem:" -ForegroundColor Yellow

    if('symbolic' -in $fixes) {
        Write-Host "Creating symbolic link to '/opt/lampp/bin/php...'" -ForegroundColor Yellow
        sudo ln -s /opt/lampp/bin/php /usr/bin/php
    }
    elseif ('path' -in $fixes) {
        if(Test-Administrator){
            Write-Host "Adding php file to PATH variable" -ForegroundColor Yellow
            $oldpath = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).path
            $newpath = “$oldpath;C:\xampp\php”
            Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $newPath
            Write-Host ""
            Write-Host "Your PATH variable has changed. Please restart your computer" -ForegroundColor Green
        }else{
            Write-Host "Can not modify PATH variable without administartor permissions." -ForegroundColor Red
            Write-Host "Please restart this powershell in administartor mode with the command ``su``, than rerun this script with ``lumen pre``"
        }
    }
}