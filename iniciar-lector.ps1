$ErrorActionPreference = 'Stop'
$emulatorFolder = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\Snes9x-Lua-1.63\snes9x-lua-1.63-win32-x64')).Path
$rom = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\Chrono Trigger (U) [T+Spa101%_Magno].smc')).Path
if (Get-Process -Name snes9x -ErrorAction SilentlyContinue) {
    Write-Host 'Cierra Snes9x con Alt+F4 y vuelve a ejecutar este acceso.'
    Read-Host 'Pulsa Enter para salir'
    exit 1
}
$hash = (Get-FileHash -LiteralPath $rom -Algorithm SHA256).Hash
if ($hash -ne 'E8CBD564C0E37144BAE193A0C82DCD1C95AA25087911932FE01F1803DE519A50') {
    throw 'La ROM ha cambiado. Este prototipo solo se ha preparado para la copia de Magno identificada.'
}
# Remove only unmodified emulator hotkeys that collide with the game bindings.
$controlCheck=& (Join-Path $PSScriptRoot 'preparar-controles.ps1') -ConfigPath (Join-Path $emulatorFolder 'snes9x.conf')
if($controlCheck.changed -gt 0){Write-Host "Se retiraron $($controlCheck.changed) atajos que interferian con las teclas del juego."}
$autoScript = Join-Path $emulatorFolder ([IO.Path]::GetFileNameWithoutExtension($rom) + '.lua')
$readerPath = (Join-Path $PSScriptRoot 'lector-snes9x.lua').Replace('\', '/')
$autoContent = '-- CHRONO_ACCESS_AUTORUN' + "`r`n" + 'dofile([[' + $readerPath + ']])' + "`r`n"
if (Test-Path -LiteralPath $autoScript) {
    $existing = [IO.File]::ReadAllText($autoScript)
    if (-not $existing.StartsWith('-- CHRONO_ACCESS_AUTORUN')) { throw 'Ya existe otro script Lua del juego; no se sobrescribira.' }
}
[IO.File]::WriteAllText($autoScript, $autoContent, [Text.UTF8Encoding]::new($false))
Start-Process -FilePath (Join-Path $emulatorFolder 'snes9x.exe') -ArgumentList ('"' + $rom + '" -lua') -WorkingDirectory $emulatorFolder -WindowStyle Normal
