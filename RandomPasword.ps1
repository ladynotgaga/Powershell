
function Generate-Password() {

$password_set = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
$password_number = "12"

$flag = Read-host "Do you want to change default password number? (y/n?)"
    if ($flag -eq "y"){
        $password_number = Read-Host "Enter password number"
  
        if ($password_number -is [int]) {Write-Host "Ok"}
        }

$flag = Read-host "Do you want to change default password number? (y/n?)"
    if ($flag -eq "y"){
        $password_set = Read-Host "Enter password set"
        }

$char = for ($i = 0; $i -lt $password_set.length; $i++) { $password_set[$i] }

    for ($i = 1; $i -le $password_number; $i++) {
        Write-host -nonewline $(get-random $char)
            if ($i -eq $password_number) { write-host `n }
    }

}


Generate-Password




