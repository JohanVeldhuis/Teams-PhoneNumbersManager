# Use this script if you need to generate a new ZIP package
$rootfolder = "$PSScriptRoot\..\..\"

# Make sure you update and save the MicrosofttTeams module as Azure Function custom modules

Write-Host "Check if Microsoft Teams PowerShell module is installed and up-to-date"
$TeamsPSModuleVersion = $(Find-Module -Name MicrosoftTeams).Version
$TeamsPSModuleInstalled = $(Get-ChildItem -Path $($rootfolder + "FunctionApp\Modules\MicrosoftTeams"))

If($TeamsPSModuleInstalled.Name -ne $TeamsPSModuleVersion -And $TeamsPSModuleInstalled -ne $null)
{
    Write-Host "New Microsoft Teams PowerShell module found, download started"
    Remove-Item $TeamsPSModuleInstalled -Force -Con
    Save-Module -Path $($rootfolder + "FunctionApp\Modules") -Name MicrosoftTeams -Repository PSGallery -MinimumVersion 4.0.0
}
ElseIf($TeamsPSModuleInstalled -eq $null)
{
    Write-Host "Downloading Microsoft Teams PowerShell module"
    Save-Module -Path $($rootfolder + "FunctionApp\Modules") -Name MicrosoftTeams -Repository PSGallery -MinimumVersion 4.0.0
}

# List in the ZIP package all the function app you need to deploy
$packageFiles = @(
    ".\FunctionApp\Get-CSOnlineDialOutPolicy"
    ".\FunctionApp\Get-CsOnlineLisLocation"
    ".\FunctionApp\Get-CsOnlineTelephoneNumber",
    ".\FunctionApp\Get-CsOnlineTelNumLocDetails",
    ".\FunctionApp\Get-CsTeamsCallingPolicy",
    ".\FunctionApp\Get-UserInfos",
    ".\FunctionApp\Grant-CsDialoutPolicy", 
    ".\FunctionApp\Grant-CsTeamsCallingPolicy",
    ".\FunctionApp\keep-alive",
    ".\FunctionApp\Modules",
    ".\FunctionApp\Set-CsOnlineVoiceUser",
    ".\FunctionApp\host.json",
    ".\FunctionApp\profile.ps1",
    ".\FunctionApp\requirements.psd1"
)
$destinationPath = ".\Packages\Azure\artifact.zip"

Compress-Archive -Path $packageFiles -DestinationPath $destinationPath -CompressionLevel optimal -Force
