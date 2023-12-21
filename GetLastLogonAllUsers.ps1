# Get the list of user profiles on the workstation
$userProfiles = Get-WmiObject Win32_UserProfile | Where-Object { $_.Special -eq $false -and $_.LocalPath -like "C:\Users\*" }

# Iterate through each user profile and retrieve last logon time
foreach ($profile in $userProfiles) {
    $sid = $profile.SID
    $user = New-Object System.Security.Principal.SecurityIdentifier($sid)
    $username = $user.Translate([System.Security.Principal.NTAccount]).Value

    # Get the last logon time for the user
    $lastLogon = Get-WmiObject Win32_NetworkLoginProfile -Property Name,LastLogon | Where-Object { $_.Name -eq $username }

    # Display the results
    if ($lastLogon) {
        $lastLogonTime = [datetime]::ParseExact(($lastLogon.LastLogon -replace "\..*$"),"yyyyMMddHHmmss",$Null)
        $formattedDate = $lastLogonTime.ToString("dd/MM/yyyy HH:mm:ss")
        Write-Output "$username last logged on at $formattedDate"
    }
}