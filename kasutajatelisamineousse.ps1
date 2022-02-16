#Martin Pettai
#hkhk
#07.02.22
#it21
#ad
cls


$dir = "C:\POWERSHELL"

$kasutajad = Import-Csv $dir\oigedkasutajad.csv
#$domeen="@pettai.local"
$parool="Par00lA"

$logheader = @("Kuupäev ja kellaaeg      info")
$logheader | set-content $dir\kasutajalog.log


foreach($kasutaja in $kasutajad){
    
    $enimi = $kasutaja.eesnimi
    $pnimi = $kasutaja.perekonnanimi
    $osakond = $kasutaja.osakond
    $OU="OU=$osakond,OU=KASUTAJAD,DC=PETTAI,DC=LOCAL"
    $teekond="OU=KASUTAJAD,DC=PETTAI,DC=LOCAL"

    $knimi = $enimi.ToLower()+"."+$pnimi.toLower()
    
    if (Get-ADOrganizationalUnit -filter "distinguishedname -eq '$OU'"){
        Write-Warning "$OU on juba olemas"
        $detailid = (Get-Date -UFormat "%d/%m/%y %T%t")  + "Kontrolliti kas OU on olemas: JAH"
        add-content $dir\kasutajalog.log $detailid       
    }
    else
    {
        New-ADOrganizationalUnit -Name $osakond -Path $teekond 
        Write-Host "loodi uus ou $OU"
        $detailid = (Get-Date -UFormat "%d/%m/%y %T%t")  + "Loodi uus OU"
        add-content $dir\kasutajalog.log $detailid 
    }

    if(Get-ADUser -F { SamAccountname -eq $knimi }){
    Write-Warning "kasutaja nimega $knimi on juba olemas" 
    $detailid = (Get-Date -UFormat "%d/%m/%y %T%t")  + "Kasutaja nimi $knimi oli olemas"
    add-content $dir\kasutajalog.log $detailid        
            
        }
        else
        {
           
            New-ADUser `
                -SamAccountName $knimi `
                -name "$enimi $pnimi" `
                -GivenName $enimi `
                -Surname $pnimi `
                -Enabled $true `
                -Path $OU `
                -Department $osakond `
                -AccountPassword (ConvertTo-SecureString $parool -AsPlainText -Force) -ChangePasswordAtLogon $true
                
            Write-Output "luua uus kasutaja nimega $knimi"
            $detailid = (Get-Date -UFormat "%d/%m/%y %T%t")  + "Loodi kasutaja $knimi"
            add-content $dir\kasutajalog.log $detailid     

        }
         
    Write-Output "$enimi $pnimi kasutaja nimi on $knimi ja osakonnaks $osakond"


    
    
    


}

import-csv $dir\kasutajalog.log
