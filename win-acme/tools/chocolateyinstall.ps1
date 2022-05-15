﻿$ErrorActionPreference = 'Stop'
$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)" 

$packageArgs = @{
    packageName    = "$env:chocolateyPackageName"
    destination    = $toolsDir
    FileFullPath   = Join-Path $toolsDir 'win-acme.v2.1.22.1267.x86.pluggable.zip'
    FileFullPath64 = Join-Path $toolsDir 'win-acme.v2.1.22.1267.x64.pluggable.zip'
}

Get-ChocolateyUnzip @packageArgs

Remove-Item -ea 0 -force -path $toolsDir\*.zip
