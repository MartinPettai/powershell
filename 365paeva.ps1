#martin pettai
#it21
#365 päeva
#16.02.22
cls

#kasutajate viimati sisselogimisajad

$OU="OU=KASUTAJAD,DC=PETTAI,DC=LOCAL"
$ADkasutajad=Get-ADUser -filter * -Properties distinguishedname, LastLogon | Select DistinguishedName, Samaccountname, @{name="lastlogon";expression={[datetime]::FromFileTime($_.'lastlogon')}}

#write-output $adkasutajad

foreach($kasutaja in $ADkasutajad){
    $knimi=$kasutaja.samaccountname
    $login=$kasutaja.lastlogon
    $path=$kasutaja.DistinguishedName
    
    

    $kuupaev=Get-Date 
    $vahe=(New-TimeSpan -Start $login -End $kuupaev).Days
    

    

    if ($vahe -gt 365){
        Move-ADObject -Identity $path -TargetPath "OU=EndisedTootajad,DC=PETTAI,DC=LOCAL"
        Disable-ADAccount -Identity $knimi
        }
            else
        {
            Write-Host "kasutaja $knimi autentis ennast viimati $vahe päeva tagasi"
        }
        
       

}