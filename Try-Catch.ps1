<# $key = 'trnsl.1.1.20191009T073247Z.a7caab90b20cb300.074ab5d0767aeb7a647af56ccb8f50be100d1ae4' #API-ключ
$bin = "$([Environment]::GetFolderPath('UserProfile'))\yatrans.bin"
Add-Type -AssemblyName System.Security
[IO.File]::WriteAllBytes(
$bin,
[Security.Cryptography.ProtectedData]::Protect(
[Text.Encoding]::Unicode.GetBytes($key),
$null,
[Security.Cryptography.DataProtectionScope]::CurrentUser
))
attrib +h $bin
#>

function Get-Translation {
  param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$Data, 
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$Language,
    [int]$attempts=3, 
    [int]$sleepInSeconds=5
  )
  
  begin {
    Add-Type -AssemblyName System.Security
    # декодирование ключа
    if (Test-Path ($key = "$([Environment]::GetFolderPath('UserProfile'))\yatrans.bin")) {
      $key = [Text.Encoding]::Unicode.GetString(
          [Security.Cryptography.ProtectedData]::Unprotect(
          [IO.File]::ReadAllBytes($key),
          $null,
          [Security.Cryptography.DataProtectionScope]::CurrentUser
        )
      )
    }
    else {
      throw 'API-ключ Яндекс.Перевод не найден.'
    }
    # url-root
    $url = 'https://translate.yandex.net/api/v1.5/tr/'
    # определение языка оригинала
    $detect = "$($url)detect?key=$key&text="
    # перевод
    $transl = "$($url)translate?key=$key&text=%t&lang=%l-$Language&format=plain"
    # user agent
    $usr = 'Mozilla/5.0 (Windows NT 6.3; rv:37.0.1) Gecko/20100101 Firefox/37.0.1'

    $foregroundcolor = "Yellow", "Red", "Black","White", "Green", "Cyan", "Blue"
  }
   process {
    # для перевода текстовых файлов
   
    $res = [xml](wget "$detect$Data" -DisableKeepAlive -UseBasicParsing -UserAgent $usr).Content
        
    $transl = $transl -replace '%t', $Data
    $transl = $transl -replace '%l', $res.DetectedLang.lang
    
    do
    {
        try{
             $res = [xml](wget $transl -DisableKeepAlive -UseBasicParsing -UserAgent $usr).Content
         
        }
    catch {Write-host "Sorry.... Something wrong with proccess :(          
                                                            \\\\\\\\ //|''''|
                                                            |   -   -  | \  / 
                                                           (   a   a  ) /  \ 
                                                            |    L     ||   |
                                                             \  ==   / |   |
                                                            _.\____/._\   |
                                                            ||         ||   / 


                                                                  © Tonya Uhlianets
" -foregroundcolor $(get-random $foregroundcolor)}
   
    $attempts--
        if ($attempts -gt 0) { sleep $sleepInSeconds }
    } while ($attempts -gt 0) 
     $res.Translation.text
   
  }
}


Get-Translation 

