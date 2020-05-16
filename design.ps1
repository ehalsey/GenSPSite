Param(

   [Parameter(Mandatory=$false)]
   [string]$UserName="ehalseyhb@actodev2.onmicrosoft.com",

   [Parameter(Mandatory=$false)]
   [string]$RootSiteUrl="https://actodev2.sharepoint.com"
)

if (-not (Get-Module -ListAvailable -Name SharePointPnPPowerShellOnline)) {
    Install-Module SharePointPnPPowerShellOnline
}
Import-Module SharePointPnPPowerShellOnline -DisableNameChecking

function Get-O365Cred([string]$user) {
    #get and save your O365 credentials
    [string]$PwdTXTPath = "e:\secrets\secret-$($user).txt"
    if (-not (Test-Path -path $PwdTXTPath)) {
        Write-Host "Password for $user :"
        read-host -assecurestring | convertfrom-securestring | out-file $PwdTXTPath
    }
    $secureStringPwd = ConvertTo-SecureString -string (Get-Content $PwdTXTPath)
    return New-Object System.Management.Automation.PSCredential -ArgumentList $user, $secureStringPwd    
}
$actocred = Get-O365Cred($UserName)
$actoconn = Connect-PnPOnline -Url $RootSiteUrl -Credentials $actocred -ReturnConnection 

New-PnPTenantSite -Connection $actoconn -Title "ThreeWill Challenge Project Site Template" -Url "/sites/threewill-challenge-proj-template" -Owner $UserName -TimeZone 13 -Template STS#0
