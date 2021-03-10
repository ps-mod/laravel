function New-LumenModel([string[]] $params){

    $continue = $true
    $model = @{}

    while ($continue)
    {
        Clear-Host
        Write-Host ("Creating new Model " + $params[0]) -ForegroundColor Green
        Write-Host "Add properties by typing their names. Type dot ('.') to complete and dash ('-') variable name"
        Write-Host ""
        Write-Host "Current Structure:"
        Write-Host $params[0] ":"
        $model.Keys | Sort-Object | ForEach-Object {
            Write-Host "+ $_ :" $model.Item($_)
        }

        $input = Read-Host -Prompt ('$' + $params[0] + '->')
        $input = $input.ToString().Trim()
        if($input.Length -eq 0){
            continue
        }
        if($input -eq '.'){
            $continue = $false
        } elseif($input.ToString().StartsWith('-')) {
            #TODO: Prop remove
        } elseif($input -match '^[a-zA-Z_\x7f-\xff][a-zA-Z0-9_\x7f-\xff]*$'){
            $model.Add($input, '')
            #TODO: Rules
        }else{
            Write-Host $input 'is not a valid variable name'
        }

        #TODO: Complete
    }

    Write-Host "OUT: "
    Write-Host $model
}

Export-ModuleMember -Function New-LumenModel