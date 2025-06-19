# get process and stop it
Get-Process | Where-Object -Property Name -Like "*shell*" | stop-process

# output folder size
Get-ChildItem -Directory -Path . | ForEach-Object {
  $folder = $_.FullName
  $size = (Get-ChildItem -Path $folder -Recurse -File | Measure-Object -Property Length -Sum).Sum
  # hashTable
  @{
    FolderName = $folder
    Size = $zie / 1024/1024
  }

} | Format-Table -AutoSize

## folder size
Get-ChildItem -Directory -Path . | ForEach-Object {
  $folder = $_.FullName
  $size = (Get-ChildItem -Path $folder -Recurse -File | Measure-Object -Property Length -Sum).Sum

  [PSCustomObject]@{
    FolderName = $folder
    Size = $zie / 1024/1024
  }

} | Format-Table -AutoSize


## folder size 2
Get-ChildItem -Directory -Path . | ForEach-Object {
  $folder = $_.FullName
  $size = (Get-ChildItem -Path $folder -Recurse -File | Measure-Object -Property Length -Sum).Sum

  [PSCustomObject]@{
    FolderName = $folder
    Size = [math]::Round($size/1MB, 2)
  }

} | Format-Table -AutoSize






