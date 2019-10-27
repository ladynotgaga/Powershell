$key = 'trnsl.1.1.20191009T073247Z.a7caab90b20cb300.074ab5d0767aeb7a647af56ccb8f50be100d1ae4' #API-ключ
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

function Get-Translation {
  param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$Data 
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
    $transl = "$($url)translate?key=$key&text=%t&lang=%l-en&format=plain"
    # user agent
    $usr = 'Mozilla/5.0 (Windows NT 6.3; rv:37.0.1) Gecko/20100101 Firefox/37.0.1'
  }
   process {
    # для перевода текстовых файлов
  
    $Data = if (Test-Path $Data) { gc $Data } else { $Data }
    $res = [xml](wget "$detect$Data" -DisableKeepAlive -UseBasicParsing -UserAgent $usr).Content
    if ($res.DetectedLang.code -ne 200) {
      throw 'Невозможно определить язык.'
    }
    
    $transl = $transl -replace '%t', $Data
    $transl = $transl -replace '%l', $res.DetectedLang.lang
    $res = [xml](wget $transl -DisableKeepAlive -UseBasicParsing -UserAgent $usr).Content
    if ($res.Translation.code -ne 200) {
      throw 'Невозможно перевести текст.'
    }
    $res.Translation.text
  }
}


$trans_text_path = 'module1-task-translate.txt'
$text = Get-Content module1-task3.txt -Encoding UTF8
for($i=0; $i -lt $text.Length; $i++){
   
        if ($text[$i] -cmatch "[A-Z]" -or $text[$i] -cmatch "[a-z]") {
           $text[$i] | Out-File $trans_text_path -Append
             }
         else { Get-Translation $text[$i] | Out-File $trans_text_path -Append }
    
}



$translated = Get-Content $trans_text_path -Encoding UTF8

$paragraphsArray = @()      # Assign empty array

for($i=0; $i -lt $translated.Length; $i++){
    $itable = @{'original'=$text[$i]; 'translated'=$translated[$i]}
     $paragraphsArray += @{"$($i+1)"=$itable}
}

$result = @{"text"=@{"paragraphs"=$paragraphsArray}} 

$path = Read-Host "Enter name o path to file with extension"

if ($path -match ".json"){
    $result | ConvertTo-Json -Depth 5 | Out-File $path
}
if ($path -match ".xml") {
 $result | ConvertTo-Xml -Depth 5 | Out-File $path
    #ConvertTo-Xml -As "Document" -InputObject ($result) -Depth 10 | Out-File $path
}

Remove-Item $trans_text_path