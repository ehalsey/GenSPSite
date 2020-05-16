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

#New-PnPTenantSite -Connection $actoconn -Title "ThreeWill Challenge Project Site Template" -Url "/sites/threewill-challenge-proj-template" -Owner $UserName -TimeZone 13 -Template STS#0

$actoconn = Connect-PnPOnline -Url "https://actodev2.sharepoint.com/sites/twc-test-02" -Credentials $actocred -ReturnConnection 
$RootSiteUrl
Get-PnPProvisioningTemplate -Out "templates\threewill-challenge-proj-template.pnp"

$actoconnRoot = Connect-PnPOnline -Url "https://actodev2.sharepoint.com" -Credentials $actocred -ReturnConnection 
#adds a group
New-PnPSite -Type TeamSite -Title "twc-test-03" -alias twc-test-03 -Connection $actoconnRoot

$actoconnTeam = Connect-PnPOnline -Url "https://actodev2.sharepoint.com/sites/twc-test-03" -Credentials $actocred -ReturnConnection 

Apply-PnPProvisioningTemplate -Connection $actoconnTeam -Path ".\templates\threewill-challenge-proj-template.pnp"

$actoconn = Connect-PnPOnline -Url "https://actodev2.sharepoint.com/sites/twc-test-02" -Credentials $actocred -ReturnConnection 
Get-PnPProvisioningTemplate -ListsToExtract "Risks" -ContentTypeGroups "ThreeWill" -Connection $actoconn -Out "templates\threewill-challenge-risks-template.pnp"

$actoconnRoot = Connect-PnPOnline -Url "https://actodev2.sharepoint.com" -Credentials $actocred -ReturnConnection 
#adds a group
New-PnPSite -Type TeamSite -Title "twc-test-04" -alias twc-test-04 -Connection $actoconnRoot
$actoconn = Connect-PnPOnline -Url "https://actodev2.sharepoint.com/sites/twc-test-04" -Credentials $actocred -ReturnConnection 
Apply-PnPProvisioningTemplate -Connection $actoconn -Path ".\templates\threewill-challenge-risks-template.pnp"

Get-PnPProvisioningTemplate -ListsToExtract "Risks" -ContentTypeGroups "ThreeWill" -Connection $actoconn -Out "templates\threewill-challenge-risks-template.pnp"

$actoconnRoot = Connect-PnPOnline -Url "https://actodev2.sharepoint.com" -Credentials $actocred -ReturnConnection 
#adds a group
New-PnPSite -Type TeamSite -Title "twc-test-05" -alias twc-test-05 -Connection $actoconnRoot
$actoconn = Connect-PnPOnline -Url "https://actodev2.sharepoint.com/sites/twc-test-05" -Credentials $actocred -ReturnConnection 
Apply-PnPProvisioningTemplate -Connection $actoconn -Path ".\templates\threewill-challenge-risks-template.pnp"
