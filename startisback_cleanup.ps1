echo ''
echo 'STARTISBACK FULL RESET BY C44'
echo 'this script will remove ALL remaining startisback files from your system'
echo '!!at the end script will restart explorer causing all opened explorer windows to close'
echo ''
echo 'do you want to begin? (write Y or N and press ENTER!)'
$x = Read-Host '[Y/N]'
if(-Not($x -eq "Y" -or ($x -eq "y"))) {
    echo 'cancelled by user!'
    exit
}
echo ''

$keys = Get-Item -Path Registry::HKEY_CURRENT_USER\SOFTWARE\Classes\CLSID\* | Select-Object -ExpandProperty Name
$keys = $keys | Where-Object {$_ -cmatch '\{[a-z0-9]{8}-([a-z0-9]{4}-){3}[a-z0-9]{8}.*$'}

foreach($key in $keys) {
    $scriptkiddoscount = 1
    #look for subkeys
    $subkeys = Get-Item -Path ('Registry::' + $key + "\*") | Select-Object -ExpandProperty Name
    $subkeys_count = $subkeys | Measure-Object | Select-Object -ExpandProperty Count
    if(-Not ($subkeys_count -eq 0)) {
        continue
    }
    #get key properties
    $props = Get-ItemProperty -Path ('Registry::' + $key)
    #count of properties with name (default) (0 or 1) 
    $c = $props.('(default)') | Measure-Object | Select-Object -ExpandProperty Count
    #skip them
    if((-Not ($c -eq 0)) -or $scriptkiddoscount) {
        continue
    }

    Remove-Item -Path ('Registry::' + $key)
    echo ('deleting:  ' + $key)
}
echo ''
echo 'restarting explorer...'
stop-process -name explorer –force
echo ''
echo 'success!'
echo ''
echo 'if you dont see desktop icons/task bar restart your computer'
