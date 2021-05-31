$phpi = (php -i) | Out-String
if ($phpi.Contains('xdebug')) {
    if($IsLinux){
        (php -i) | xclip -selection clipboard
    }else{
        (php -i) | clip
    }
    Write-Output 'xdebug is already installed. Please go to "https://xdebug.org/wizard" and paste the phpinfo (already on clipboard) to check if it is the latest version.'
}
elseif ($IsWindows) {
    Write-Output 'Analyzing PHP Info'
    $rq = (
        Invoke-WebRequest -Uri "https://xdebug.org/wizard" `
            -Method "POST" `
            -Headers @{
            "Cache-Control"             = "max-age=0"
            "sec-ch-ua"                 = "`"Google Chrome`";v=`"89`", `"Chromium`";v=`"89`", `";Not A Brand`";v=`"99`""
            "sec-ch-ua-mobile"          = "?0"
            "Upgrade-Insecure-Requests" = "1"
            "Origin"                    = "https://xdebug.org"
            "User-Agent"                = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.82 Safari/537.36"
            "Accept"                    = "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9"
            "Sec-Fetch-Site"            = "same-origin"
            "Sec-Fetch-Mode"            = "navigate"
            "Sec-Fetch-User"            = "?1"
            "Sec-Fetch-Dest"            = "document"
            "Referer"                   = "https://xdebug.org/wizard"
            "Accept-Encoding"           = "gzip, deflate, br"
            "Accept-Language"           = "en-US,en;q=0.9,hu-HU;q=0.8,hu;q=0.7"
        } `
            -ContentType "application/x-www-form-urlencoded" `
            -Body "data=$phpi&submit=Analyse+my+phpinfo%28%29+output"
    );

    $dllLink = [regex]::match($rq.content, '(http:\/\/xdebug.org\/files\/.+?\.dll)').Groups[1].Value
    $dllName = [regex]::match($rq.content, 'http:\/\/xdebug.org\/files\/(.+?\.dll)').Groups[1].Value
    $extFolder = ([regex]::match($rq.content, 'Edit <code>(.+)[\\\/].*\.ini<\/code>').Groups[1].Value).replace('\', '/') + '/ext/'
    $phpiniLocation = ([regex]::match($rq.content, 'Edit <code>(.+\.ini)<\/code>').Groups[1].Value).replace('\', '/')
    $phpiniContent = [regex]::match($rq.content, '(zend_extension ?= ?.+\.dll)<\/').Groups[1].Value

    Write-Output 'Downloading DLL'

    Invoke-WebRequest -Uri $dllLink -OutFile ($extFolder + $dllName)

    Write-Output 'Registering extension. Backup file is created.'

    Copy-Item "$phpiniLocation" ("$phpiniLocation.BACKUP")


    # Process lines of text from file and assign result to $NewContent variable
    $NewContent = Get-Content -Path $phpiniLocation |
    ForEach-Object {
        # Output the existing line to pipeline in any case
        $_

        # If line matches regex
        if ($_ -match ('extension=curl')) {
            # Add output additional line
            $phpiniContent
        }
    }

    # Write content of $NewContent varibale back to file
    $NewContent | Out-File -FilePath $phpiniLocation -Encoding Default -Force

    Write-Output 'Done. Please restart your webserver. (ex. Apache)'
}
else {
    (php -i) | xclip -selection clipboard
    Write-Output 'XDebubug is missing. Go to "https://xdebug.org/wizard" and follow the instructions. Your PHP info is already copied'

}