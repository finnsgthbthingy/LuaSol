try {
    $ErrorActionPreference = "Stop"
    Set-Location $PSScriptRoot

    $love = "C:\Program Files\LOVE"
    $name = "LuaSol"

    if (-not (Test-Path "$love\love.exe")) { throw "love.exe not found in $love" }
    if (-not (Test-Path .\icon.ico))       { throw "icon.ico missing in $PSScriptRoot" }

    if (-not (Test-Path .\rcedit-x64.exe)) {
        Write-Host "Downloading rcedit ..." -ForegroundColor Yellow
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -UseBasicParsing `
            "https://github.com/electron/rcedit/releases/download/v2.0.0/rcedit-x64.exe" `
            -OutFile .\rcedit-x64.exe
    }

    Write-Host "[0/3] Cleaning build and dist ..." -ForegroundColor Cyan
    Get-Process $name -ErrorAction SilentlyContinue | Stop-Process -Force
    Start-Sleep -Milliseconds 500
    foreach ($d in "build", "dist") {
        if (Test-Path $d) { Remove-Item $d -Recurse -Force }   # errors now show
        New-Item -ItemType Directory $d -Force | Out-Null
    }

    Write-Host "[1/3] Packing .love ..." -ForegroundColor Cyan
    $lua = (Get-ChildItem *.lua).Name
    tar --format zip -cf build\game.love --exclude="*.dll" --exclude="*.exe" $lua assets socket mime ssl
    if ($LASTEXITCODE -ne 0) { throw "tar failed" }

    Write-Host "[2/3] Setting icon and fusing exe ..." -ForegroundColor Cyan
    Copy-Item "$love\love.exe" build\base.exe
    .\rcedit-x64.exe build\base.exe --set-icon icon.ico `
      --set-version-string "ProductName" "$name" `
      --set-version-string "FileDescription" "$name" `
      --set-version-string "CompanyName" "finnashleyy"
    if ($LASTEXITCODE -ne 0) { throw "rcedit failed" }
    cmd /c copy /b build\base.exe+build\game.love "dist\$name.exe" | Out-Null

    Write-Host "[3/3] Copying DLLs and licenses ..." -ForegroundColor Cyan
    Copy-Item "$love\*.dll" dist
    Copy-Item libcrypto-4-x64.dll, libssl-4-x64.dll, ssl.dll dist
    Copy-Item socket, mime -Destination dist -Recurse
    Copy-Item "$love\license.txt" dist\love-license.txt
    Copy-Item LICENSE, "GNU GENERAL PUBLIC LICENSE.txt" dist

    Write-Host "Done: dist\$name.exe" -ForegroundColor Green
}
catch {
    Write-Host ""
    Write-Host "BUILD FAILED: $($_.Exception.Message)" -ForegroundColor Red
}
finally {
    Read-Host "Press Enter to close"
}