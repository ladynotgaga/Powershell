function Sort-ErrorLog {
[CmdletBinding()]
    param(
        [string] 
        $pathLogFile = 'C:\Users\Antanina_Uhlianets\Documents\module4\module4-task1-dism.log',
        [string] 
        $pathErrorFile = 'C:\Users\Antanina_Uhlianets\Documents\module4\module4-error.log'  
    )

$file = Get-Content -Path $pathLogFile
foreach($line in $file){
   
        if ($line -cmatch ", Error") {
       
            foreach ($token in $line.Split("=",":",":","[","]", "(",")")){
         
                if ($token -cmatch "0x" -and $token.Length -eq 10){
                    $string = $token.Clone()
                    $line.Replace("Error","Error ErrorNumber: $string") | Out-File $pathErrorFile  -Append     
                }
            }        
        }
    }
}

Sort-ErrorLog