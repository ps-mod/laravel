function envReplace {
    param(
        [Parameter(Mandatory=$True, Position = 0)]
        [string]
        $promt,
        [Parameter(Mandatory=$True, Position = 1)]
        [string]
        $default,
        [Parameter(Mandatory=$True, Position = 2)]
        [string]
        $needle
    )
    #$envExample = (Join-Path -Path (Join-Path -Path $PWD -ChildPath $args[0]) -ChildPath '.env.example')
    $envExample = './.env.example'
    $replacement = ($v = Read-Host "$promt (default: $default)") ? $v : $default
    $hayStack = $needle.Replace($default, $replacement)
    ((Get-Content -path $envExample -Raw) -replace $needle,$hayStack) | Set-Content -Path $envExample
    
}

function doInit{
    param(
        [Parameter(Mandatory=$True, Position = 0)]
        [string]
        $target
    )
    $envExample = (Join-Path -Path (Join-Path -Path $PWD -ChildPath $target) -ChildPath '.env.example')
    $repo = ($v = Read-Host "Template (default: dombidav/lara-demo)") ? $v : 'dombidav/lara-demo'
    if(!$repo.StartsWith('http')){
        $repo = "https://github.com/$repo"
    }
    git clone $repo $target
    Set-Location $target
    Remove-Item './.git' -Recurse -Force
    # rm -r --Force ./.git
    $appName = Read-Host "What will be the name of your app?"
    ((Get-Content -path $envExample -Raw) -replace 'My App',$appName) | Set-Content -Path $envExample
    envReplace "App url" 'myapp' 'APP_URL=http://myapp.test'
    envReplace "Database Name" 'myapp' 'DB_DATABASE=myapp'
    envReplace "Database User" 'root' 'DB_USERNAME=root'
    $password = ($v = Read-Host "Database Password (default: empty)") ? $v : ''
    if($password.Length -gt 0){
        ((Get-Content -path $envExample -Raw) -replace 'DB_PASSWORD=',"DB_PASSWORD=$password") | Set-Content -Path $envExample
    }
    envReplace "Database Driver" 'mysql' 'DB_CONNECTION=mysql'
    envReplace "Database Host" '127.0.0.1' 'DB_HOST=127.0.0.1'
    envReplace "Database Port" '3306' 'DB_PORT=3306'
    $confirm = (($v = Read-Host "Init Git repository? y/n (default: Y)") ? $v : 'y').Substring(0,1).ToLower()
    if($confirm.Equals('y')){
        git init
        git add ./README.md
        git commit -m "Initial Commit"
    }
    lumen compose
}

doInit($args[0])