function Func1 {
    param(
    [Parameter(Mandatory=$true)]
    $name
    )

    Write-Output "hello $name!"
}

#Func1 -name "123"

function GetVariable {
    param (
    [Parameter(Mandatory=$true)]
    $name
    )

    return [Environment]::GetEnvironmentVariable($name)
}

Get-ExecutionPolicy
Set-ExecutionPolicy remotesigned
GetVariable -name JAVA_HOME


Set-ExecutionPolicy restricted


