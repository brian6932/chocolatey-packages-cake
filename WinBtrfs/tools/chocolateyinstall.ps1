﻿$ErrorActionPreference = 'Stop';
$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$fileLocation          = (Get-ChildItem $toolsDir -Filter "*.zip").FullName
$driverFile            = Join-Path $toolsDir 'btrfs.cat'
$outputFile            = Join-Path $toolsDir 'MarkHarmstone.cer'
$exportType            = [System.Security.Cryptography.X509Certificates.X509ContentType]::Cert

Get-ChocolateyUnzip $fileLocation $toolsDir

Write-Host -ForegroundColor green "Extracting cert from driver"
$cert = (Get-AuthenticodeSignature $driverFile).SignerCertificate;
[System.IO.File]::WriteAllBytes($outputFile, $cert.Export($exportType));

Write-Host -ForegroundColor green "Adding cert to trusted store"
certutil -addstore -f "TrustedPublisher" $toolsDir\MarkHarmstone.cer

Write-Host -ForegroundColor green "Adding btrfs driver"
pnputil -i -a $toolsDir\btrfs.inf 

Write-Host -ForegroundColor green "Removing ARM files"
Remove-Item -Recurse -Path $toolsDir\aarch64
Remove-Item -Recurse -Path $toolsDir\arm

if (Get-OSArchitectureWidth 64) {
	Write-Host -ForegroundColor green "Removing x32 files"
	Remove-Item -Recurse -Path $toolsDir\x86
} else {
	Write-Host -ForegroundColor green "Removing x64 files"
	Remove-Item -Recurse -Path $toolsDir\x64
}
