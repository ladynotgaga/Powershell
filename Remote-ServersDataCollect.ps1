function Collect-RemoteServers {
 [CmdletBinding()]
    param(
        [int] 
        $limit = 3,
        [string] 
        $PathComputer = 'computer.txt',
        [string]
        $PathJson = 'result.json'
    )

$session = New-PSSession -ComputerName localhost

    $script={
        Write-Host "Check"
        $paragraphsArray = @()  
       
        $data = Get-WmiObject win32_logicaldisk

        $data3 = Get-Process | Sort CPU -Descending | Select-Object -First 5 
        for($i=0; $i -lt 5; $i++) {
            
            $itable = @{'Name'=$data3.Name[$i]; 'ID'=$data3.Id[$i]}
            $paragraphsArray += @{"Process $($i+1)"=$itable}

        }
        $data2 = Get-WmiObject win32_processor

        $free = [Math]::Round($data.Freespace[0] / 1Gb, 2)
        $result = @{"Value" = @{"CPU Process"=$paragraphsArray; "LoadPercentage"=$data2.LoadPercentage; "Freespace"=$free}}
        $result 

    }

$res = Invoke-Command -Session $session -ScriptBlock $script -ThrottleLimit $limit
$res  | Select-Object -Property * -ExcludeProperty RunspaceId, PSShowComputerName, IsReadOnly, IsFixedSize, IsSynchronized, Keys, SyncRoot, Count | ConvertTo-Json -Depth 5 | Out-File $PathJson


Remove-PSSession -ComputerName localhost
}


Collect-RemoteServers


 

