#requires -version 3
Set-StrictMode -Version Latest

# Hard-coded URI bases
$script:CitySearchFore='http://api.openweathermap.org/data/2.5/forecast?q='
$script:IDSearchFore='http://api.openweathermap.org/data/2.5/forecast?id='
$script:CitySearchUri = 'http://api.openweathermap.org/data/2.5/weather?q=' #"http://api.openweathermap.org/data/2.1/find/name?q="
$script:CityInfoUriBase = 'http://api.openweathermap.org/data/2.5/weather?id='

function Write-MyError {
    
    param(
        [Parameter(Mandatory)][string] $Output,
        [switch] $Object
    )

    if ($Object) {
        New-Object PSObject -Property @{ Error = $Output }
    }
    else {
        $Output
    }

}


function Get-OWMWeather {
    
    [CmdletBinding()]
    param(
        #[Parameter(Mandatory)][string] 
        $City,
        #[Parameter(Mandatory)][string] 
        $ID,
        [string][ValidateSet("imperial","metric","kelvin")]$Units = 'imperial',
        [switch] $Object,
        [switch] $NoAPIKey
    )
      
    Add-Type -AssemblyName System.Web # added to manifest file

      if($City){
      $Uri = $script:CitySearchUri + [Web.HttpUtility]::UrlEncode($City) + "&units=$Units" +  "&APPID=$global:OWMAPIKey"      
      $UriFore = $script:CitySearchFore + [Web.HttpUtility]::UrlEncode($City) + "&units=metric&cnt=10" + "&APPID=$key" 
    }
      if($ID){
      $Uri = $script:CityInfoUriBase + [Web.HttpUtility]::UrlEncode($ID) + "&units=$Units" + "&APPID=$key"
      $UriFore = $script:IDSearchFore + [Web.HttpUtility]::UrlEncode($ID) + "&units=metric&cnt=10" + "&APPID=$key"
    }
   
        try {
            $t = Invoke-RestMethod -Uri $Uri
            $Forecast = Invoke-RestMethod -Uri $UriFore
        }
        catch {
            Write-MyError -Output "Unable to execute Invoke-RestMethod to retrieve ID(s) for ${City}: $_" -Object:$Object
            return
        }
        
        if (($t | Get-Member -Name Message -EA 0) -and $t.Message -ilike '*Not found*') {
            Write-MyError -output "Did not find $City." -Object:$Object
            return
        }  
              
        $m = $Forecast.list | Where-Object {$_.dt_txt -eq "2019-10-14 12:00:00"}
        
        if($Units -eq 'imperial') {$temp = "C"}
        elseif($Units -eq 'metric') {$temp = "F"}
        elseif($Units -eq 'kelvin') {$temp = "K"}
   
        $IterCityData = @(
            $t.name,  
            $t.id,          
            $t.main.humidity,
            $t.main.pressure,
            (Get-Date -Date '1970-01-01T00:00:00').AddSeconds($t.dt).ToString('yyyy-MM-dd'),
            $t.sys.country,
            $t.wind.speed,
            $t.weather.description,
            (Get-Date -Date '1970-01-01T00:00:00').AddSeconds($t.sys.sunrise).ToString('yyyy-MM-dd HH:mm:ss'),
            (Get-Date -Date '1970-01-01T00:00:00').AddSeconds($t.sys.sunset).ToString('yyyy-MM-dd HH:mm:ss'),
            $m.weather.description,
            $t.main.temp,
            $m.main.temp,
            $temp
        )
        if ($Object) {
            $t
        }
        else {
            "
             Name: {0}. 
             ID: {1}.
             Temperature {11} {13}.  
             Forecast Temperature {12} {13}.
             Humidity: {2} %. 
             Pressure: {3} hpa. 
             Date: {4}. 
             Country: {5}. 
             Wind speed: {6} m/s. 
             Weather: {7}. 
             Forecast Weather: {10}. 
             Sunrise: {8}. 
             Sunset: {9}.
            
             " -f $IterCityData
        }
       
        #Start-Sleep -Seconds 3

   # } # end of foreach $IterCity

}
$Global:OWMAPIKey = '9c3104e4cc56aa2967d9bc28d2fddf79'
$key= 'ce7a767b4cf665eaeb6757f334f4dac5'
$keyfore = 'd84f62b80bba810b594cf67510d036ca'