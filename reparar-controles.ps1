param(
 [string]$EmulatorFolder=(Join-Path $PSScriptRoot '../Snes9x-Lua-1.63/snes9x-lua-1.63-win32-x64'),
 [switch]$Apply
)
$ErrorActionPreference='Stop'
$folder=(Resolve-Path -LiteralPath $EmulatorFolder).Path
$allowed=@(
 [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../Snes9x-Lua-1.63/snes9x-lua-1.63-win32-x64')),
 [IO.Path]::GetFullPath((Join-Path $PSScriptRoot 'test/emulator')))
if($folder -notin $allowed){throw 'Carpeta fuera de los dos emuladores conocidos'}
$exe=Join-Path $folder 'snes9x.exe'
$processes=@(Get-Process -Name snes9x -ErrorAction SilentlyContinue|Where-Object {$_.Path -eq $exe})
if($processes.Count -ne 1){throw 'Debe haber una sola instancia en esa carpeta; no se cambia otro proceso'}
. (Join-Path $PSScriptRoot 'input-ui.ps1')
$windows=[InputUI]::Windows($processes[0].Id)
$main=@($windows|Where-Object {[InputUI]::GetMenu($_) -ne [IntPtr]::Zero})
if($main.Count -ne 1){throw 'No se encontro una sola ventana principal'}
$main=$main[0]
function Menu-Rows {
 # Enter/exit only the native menu loop so Snes9x refreshes its checked device.
 # The pause reason is PAUSE_MENU, not the user's Pause setting.
 [void][InputUI]::SendMessage($main,0x211,[IntPtr]::Zero,[IntPtr]::Zero)
 try{return @([InputUI]::Menus([InputUI]::GetMenu($main)))}
 finally{[void][InputUI]::SendMessage($main,0x212,[IntPtr]::Zero,[IntPtr]::Zero)}
}
function Command-Id($rows,$pattern){
 $matches=@($rows|Where-Object {$_.Replace('&','') -match $pattern})
 if($matches.Count -ne 1){throw "No se encontro una sola orden: $pattern"}
 return [int]($matches[0].Split('|')[0])
}
$rows=Menu-Rows
$hotkeys=Command-Id $rows ' > Customize Hotkeys'
$joypad=Command-Id $rows ' > Use SNES Joypad\(s\)$'
$before=@($rows|Where-Object {$_ -match 'Use (SNES|Mouse|Super|Konami|Dual|Multitap|M\.A\.C)'})
if(-not $Apply){$before;return}
foreach($window in $windows){if([InputUI]::Text($window) -match 'Hotkey Configuration'){throw 'Ya hay un dialogo de atajos abierto; no se modifica'} }
$config=Join-Path $folder 'snes9x.conf'
$original=[IO.File]::ReadAllBytes($config)
$tag=if($folder -eq $allowed[0]){'usuario'}else{'prueba'}
$stamp=Get-Date -Format 'yyyyMMdd-HHmmss-fff'
$backup=Join-Path $PSScriptRoot "diagnosticos/controles-$tag-$stamp"
New-Item -ItemType Directory -Path $backup | Out-Null
[IO.File]::WriteAllBytes((Join-Path $backup 'snes9x-antes.conf'),$original)
if($tag -eq 'usuario' -and (Test-Path -LiteralPath (Join-Path $PSScriptRoot 'caminar.log'))){
 Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'caminar.log') -Destination (Join-Path $backup 'caminar-antes.log')
}
$dialog=[IntPtr]::Zero
$accepted=$false
try{
 [void][InputUI]::PostMessage($main,0x111,[IntPtr]$hotkeys,[IntPtr]::Zero)
 for($n=0;$n -lt 100;$n++){
  $found=@([InputUI]::Windows($processes[0].Id)|Where-Object {[InputUI]::Text($_) -match 'Hotkey Configuration'})
  if($found.Count -eq 1){$dialog=$found[0];break}
  Start-Sleep -Milliseconds 50
 }
 if($dialog -eq [IntPtr]::Zero){throw 'No se abrio el dialogo de atajos'}
 $children=[InputUI]::Children($dialog)
 $combo=@($children|Where-Object {[InputUI]::Class($_) -eq 'ComboBox'})
 if($combo.Count -ne 1){throw 'Selector de pagina ambiguo'}
 $combo=$combo[0]
 [void][InputUI]::SendMessage($combo,0x14E,[IntPtr]1,[IntPtr]::Zero)
 $notification=([InputUI]::GetDlgCtrlID($combo) -bor (1 -shl 16))
 [void][InputUI]::SendMessage($dialog,0x111,[IntPtr]$notification,$combo)
 $changed=@()
 foreach($child in $children){
  $id=[InputUI]::GetDlgCtrlID($child)
  if([InputUI]::Class($child) -eq 'InputCustomHot' -and $id -ge 2000 -and $id -le 2013){
   $text=[InputUI]::Text($child).Trim()
   if($text -in @('Up','Down','Left','Right','V','C','D','X','A','S','Space','Enter')){
    $changed+=@{control=$id;before=$text}
    # Native dialog notification for a disabled key (0), not a game key.
    [void][InputUI]::SendMessage($dialog,(0x400+43),[IntPtr]::Zero,$child)
    if([InputUI]::Text($child) -ne 'Disabled'){throw "No se desactivo el atajo $id"}
   }
  }
 }
 [void][InputUI]::SendMessage($dialog,0x111,[IntPtr]1,[IntPtr]::Zero)
 $accepted=$true
 [void][InputUI]::SendMessage($main,0x111,[IntPtr]$joypad,[IntPtr]::Zero)
 $after=Menu-Rows
 $normal=@($after|Where-Object {$_.Replace('&','') -match ' > Use SNES Joypad\(s\)$'})
 if($normal.Count -ne 1 -or (([int]($normal[0].Split('|')[1])) -band 8) -eq 0){throw 'El mando normal no quedo seleccionado'}
 $saved=[IO.File]::ReadAllText($config)
 # This fork locks its config after startup and writes queued settings on exit.
 # Validate the live controls here; persistence is tested after closing the test.
 # Do not change any Joypad1 binding, including A=V and B=C.
 $old=[Text.Encoding]::UTF8.GetString($original)
 foreach($name in @('Up','Down','Left','Right','A','B','X','Y','L','R','Start','Select')){
  $pattern='(?m)^\s*Joypad1:'+ $name +'\s*=\s*([^\r\n#]+)'
  $oldValue=[regex]::Match($old,$pattern).Groups[1].Value.Trim()
  $newValue=[regex]::Match($saved,$pattern).Groups[1].Value.Trim()
  if($oldValue -ne $newValue){throw "Cambio inesperado en Joypad1:$name"}
 }
 Copy-Item -LiteralPath $config -Destination (Join-Path $backup 'snes9x-archivo-durante-sesion.conf')
 $receipt=@{process=$processes[0].Id;path=$exe;changed=$changed;before=$before;after=@($after|Where-Object {$_ -match 'Use (SNES|Mouse|Super|Konami|Dual|Multitap|M\.A\.C)'});joypadVerified=$true;gameKeysPreserved=$true;configSavePendingUntilExit=$true}
 [IO.File]::WriteAllText((Join-Path $backup 'resultado.json'),($receipt|ConvertTo-Json -Depth 6),[Text.UTF8Encoding]::new($false))
 "Corregidos $($changed.Count) atajos. Mando SNES seleccionado. Teclas del juego conservadas. Evidencia: $backup"
}finally{
 if($dialog -ne [IntPtr]::Zero -and -not $accepted){[void][InputUI]::SendMessage($dialog,0x111,[IntPtr]2,[IntPtr]::Zero)}
}
