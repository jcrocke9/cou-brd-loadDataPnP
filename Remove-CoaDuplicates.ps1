function Add-CoaAppointee {
    Param
    (
        [parameter(Mandatory = $true)]
        [String]$FilePath
    )
    class Appointee {
        [string]$LastName
        [string]$FirstName
        [string]$FullName
        [string]$Archive
        [string]$Commission
        [string]$MemberType
        [string]$MemberType2
        [string]$StreetNumber
        [string]$StreetName
        [string]$City
        [string]$State
        [string]$Zip
        [string]$Email
        [string]$HomePh
        [string]$Businessph
        [string]$Fax
        [string]$Occupation
        [string]$Occupation2
        [string]$Occupation3
    }
    $appointeesArr = [System.Collections.Generic.List[System.Object]]::new();
    Import-Csv -Path $FilePath | ForEach-Object {
        $appointee = [Appointee]::new()
        $temLastName = $_.LastName
        $appointee.LastName = $temLastName.Trim()
        $temFirstName = $_.FirstName
        $appointee.FirstName = $temFirstName.Trim()
        $appointee.FullName = $temFirstName.Trim() + " " + $temLastName.Trim()
        Clear-Variable temFirstName
        Clear-Variable temLastName;
        $appointee.Archive = $_.Archive
        $appointee.Commission = $_.Commission
        $appointee.MemberType = $_.MemberType + " " + $_.MemberType2
        $appointee.StreetName = $_.StreetNumber + " " + $_.StreetName
        $appointee.City = $_.City
        $appointee.State = $_.State
        $appointee.Zip = $_.Zip
        $appointee.Email = $_."E-mail"
        $appointee.HomePh = $_."Home-Ph"
        $appointee.Businessph = $_."Business-ph"
        $appointee.Fax = $_.Fax
        $appointee.Occupation = $_.Occupation + " " + $_.Occupation2 + " " + $_.Occupation3
        $appointeesArr.Exists({param($a) $a.FullName -eq $appointee.FullName})
        if (!$appointeesArr.Exists({param($a) $a.FullName -eq $appointee.FullName})) {            
            $appointeesArr.Add($appointee);
        } else {
            Write-Output $appointee.FullName
        }
    }
    $appointeesArr.Count
}