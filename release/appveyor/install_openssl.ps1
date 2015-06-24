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
    RunCommand $verified "/SILENT"
}

function RunCommand ($command, $command_args) {
    Write-Host $command $command_args
    Start-Process -FilePath $command -ArgumentList $command_args -Wait -Passthru
}

function main () {
    InstallPython $env:PYTHON_VERSION $env:PYTHON_ARCH $env:PYTHON
    DownloadOpenSSL $env:OPENSSL_URL $env:OPENSSL_HASH
    InstallOpenSSL
}

main