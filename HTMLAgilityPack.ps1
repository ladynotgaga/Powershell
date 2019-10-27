function Get-GitHubTrend {
 [CmdletBinding()]
    param(
        [string]
        $PathJson = 'result.json'
    )


$path = "C:\Users\Antanina_Uhlianets\Documents\HtmlAgilityPack\HtmlAgilityPack.dll"
[System.Reflection.Assembly]::LoadFile($path)
[HtmlAgilityPack.HtmlWeb]$web = @{}
[HtmlAgilityPack.HtmlDocument]$doc = $web.Load("https://github.com/trending")

 $paragraphsArray = @()  
       

    foreach ($i in 1..25){

            [HtmlAgilityPack.HtmlNodeCollection]$name = $doc.DocumentNode.SelectNodes("/html[1]/body[1]/div[4]/main[1]/div[3]/div[1]/div[2]/article[$i]/h1[1]/a[1]")
            $shortName = $name.Attributes.Value -replace "[/].*[/]", ""
            [HtmlAgilityPack.HtmlNodeCollection]$starsToday = $doc.DocumentNode.SelectNodes("/html[1]/body[1]/div[4]/main[1]/div[3]/div[1]/div[2]/article[$i]/div[2]/span[3]")     
            [HtmlAgilityPack.HtmlNodeCollection]$Language = $doc.DocumentNode.SelectNodes("/html[1]/body[1]/div[4]/main[1]/div[3]/div[1]/div[2]/article[$i]/div[2]/span[1]/span[2]") 
            [HtmlAgilityPack.HtmlNodeCollection]$Stars = $doc.DocumentNode.SelectNodes("/html[1]/body[1]/div[4]/main[1]/div[3]/div[1]/div[2]/article[$i]/div[2]/a[1]") #stars      

            $flagL =0
            $flagAS =0
            $flagTS = 0
            try{$Language.InnerText.Trim()} catch {$flagL=1}
            try{$Stars.InnerText.Trim()} catch {$flagAS =1} 
            try{$starsToday.InnerText.Trim()} catch{$flagTS =1}

            if ($flagL -eq 1){$LanguageE = "null"}
            else {$LanguageE = $Language.InnerText.Trim()}

            if ($flagAS -eq 1){$AS = "0"}
            else {$AS = $Stars.InnerText.Trim()}

            if ($flagTS -eq 1){$TS = 0}
            else {$TS = $starsToday.InnerText.Trim() -match "\d+"|%{$Matches[0]} }

            $address = "https://github.com" + $name.Attributes.Value       
        
            
            $itable = @{'Name'=$shortName; 'Address'=$address; 'Language'=$LanguageE; 'Stars Total'=$AS; 'Star Today'=$TS}
            $paragraphsArray += @{"Process $i"=$itable}

        

    }

    $result = @{"Trending GitHub Repositories"=$paragraphsArray}
    $result | ConvertTo-Json -Depth 5 | Out-File $PathJson

}

Get-GitHubTrend | Out-Null

