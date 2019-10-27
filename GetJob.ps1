function Display-FileName {
[CmdletBinding()]
    param(
        [int] 
        $Jobs = 5,
        [string] 
        $path = 'C:\Users\Antanina_Uhlianets\Documents'
    )
 
    foreach ($file in Get-ChildItem -Path $path -Recurse -File){
          Do {
             $Job = (Get-Job -State Running | measure).count
          } Until ($Job -le $Jobs)
          $waitTime = Get-Random -Minimum 3 -Maximum 8
          Start-Sleep -Seconds $waitTime
          Start-Job -ScriptBlock {if ($LASTEXITCODE -ne 0)
                   {
                      Throw "the job has failed"
                   } } | Select-Object Id, Name
        #  Get-ChildItem -Path $path -File $file | Select-Object Name
          $file | Select-Object Name
          Get-Job -State Completed | Remove-Job
    }

    Wait-Job -State Running
    Get-Job -State Completed | Remove-Job
    Get-Job

}
#Display-FileName -Jobs 3 -path C:\Users\Antanina_Uhlianets\AppData
Display-FileName