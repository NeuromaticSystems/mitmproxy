$unverified = "C:\OpenSSL-unverified"
$verified = "C:\OpenSSL.exe"

function DownloadOpenSSL ($url, $hash) {
    $webclient = New-Object System.Net.WebClient
    # Download and retry up to 3 times in case of network transient errors.
    Write-Host "Downloading" $url
    for($i=0; $i -lt 3; $i++){
        try {
            $webclient.DownloadFile($url, $unverified)
            break
        }
        Catch [Exception]{
            if($i -eq 2){
                throw
            }
            Start-Sleep 1
        }
    }
    $filehash = certutil.exe -hashfile $unverified sha256
    if($filehash -eq $hash){
        Rename-Item $unverified $verified
    } else {
        Throw "Invalid checksum"
    }
}

function InstallOpenSSL () {
    Write-Host "Installing OpenSSL"
    RunCommand $verified "/SILENT /LOG C:\openssl.log"
    Get-Content "C:\\openssl.log"
}

function RunCommand ($command, $command_args) {
    Write-Host $command $command_args
    Start-Process -FilePath $command -ArgumentList $command_args -Wait -Passthru
}

function main () {
    DownloadOpenSSL $env:OPENSSL_URL $env:OPENSSL_HASH
    ls "C:/"
    InstallOpenSSL
}

main