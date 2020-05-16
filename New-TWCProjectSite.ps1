Param(
   [Parameter(Mandatory=$true)]
   [string]$SharePointUrl="https://actodev2.sharepoint.com",

   [Parameter(Mandatory=$true)]
   [string]$ProjectTitle,

   [Parameter(Mandatory=$false)]
   [string]$Alias
)

if (-not (Get-Module -ListAvailable -Name SharePointPnPPowerShellOnline)) {
    Install-Module SharePointPnPPowerShellOnline
}
Import-Module SharePointPnPPowerShellOnline -DisableNameChecking

Connect-PnPOnline -Url $SharePointUrl
if(!$Alias) {
    $Alias = $ProjectTitle.Replace(" ","-").ToLower()
}
#includes O365 Group
$site = New-PnPSite -Type TeamSite -Title $ProjectTitle -Alias $Alias
$conn = Connect-PnPOnline -Url $site -Credentials $actocred -ReturnConnection 
Apply-PnPProvisioningTemplate -Connection $conn -Path ".\templates\threewill-challenge-risks-template.xml"
