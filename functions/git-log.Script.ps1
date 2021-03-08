$n = 10
if($args[0]){
    $n = $args[0]
}

Write-Output ((git log --format="%ai`t%H`t%an`t%ae`t%s" -n $n) | ConvertFrom-Csv -Delimiter "`t" -Header ("Date","CommitId","Author","Email","Subject"))