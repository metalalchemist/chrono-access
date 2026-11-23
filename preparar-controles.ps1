param([Parameter(Mandatory=$true)][string]$ConfigPath)
$ErrorActionPreference='Stop'
$config=(Resolve-Path -LiteralPath $ConfigPath).Path
$exe=Join-Path (Split-Path -Parent $config) 'snes9x.exe'
if(@(Get-Process -Name snes9x -ErrorAction SilentlyContinue|Where-Object {$_.Path -eq $exe}).Count -gt 0){
 throw 'El emulador de esa configuracion esta abierto; usa reparar-controles.ps1 -Apply para la sesion activa'
}
$original=[IO.File]::ReadAllBytes($config)
# One-to-one byte encoding preserves all original comments/non-ASCII bytes.
$encoding=[Text.Encoding]::GetEncoding(28591)
$text=$encoding.GetString($original)
$gameKeys=@([regex]::Matches($text,'(?m)^[ \t]*Joypad1:(?:Up|Down|Left|Right|A|B|X|Y|L|R|Start|Select)[ \t]*=[ \t]*(?<key>[^\r\n#]+)')|ForEach-Object {$_.Groups['key'].Value.Trim()}|Where-Object {$_ -ne 'Unassigned'})
if($gameKeys.Count -ne 12 -or $text -notmatch '\[Controls\\Win\\Hotkeys\]'){throw 'No se reconoce la configuracion esperada'}
$changes=@()
foreach($match in [regex]::Matches($text,'(?m)^[ \t]*Key:(?<name>\w+)[ \t]*=[ \t]*(?<value>[^ \t\r\n#]+)')){
 $name=$match.Groups['name'].Value;$value=$match.Groups['value']
 $mods=[regex]::Match($text,('(?m)^[ \t]*Mods:'+ [regex]::Escape($name) +'[ \t]*=[ \t]*(?<value>[^\r\n#]+)')).Groups['value'].Value.Trim()
 if($gameKeys -contains $value.Value -and $mods -eq 'none'){
  $changes+=@{name=$name;before=$value.Value;index=$value.Index;length=$value.Length}
 }
}
$backup=$null
if($changes.Count -gt 0){
 $backup=Join-Path $PSScriptRoot ('diagnosticos/controles-inicio-'+(Get-Date -Format 'yyyyMMdd-HHmmss-fff')+'-'+[guid]::NewGuid().ToString('N').Substring(0,6))
 New-Item -ItemType Directory -Path $backup | Out-Null
 [IO.File]::WriteAllBytes((Join-Path $backup 'snes9x-antes.conf'),$original)
 foreach($change in @($changes|Sort-Object {$_['index']} -Descending)){
  $text=$text.Remove($change.index,$change.length).Insert($change.index,'Unassigned')
 }
 [IO.File]::WriteAllBytes($config,$encoding.GetBytes($text))
 [IO.File]::WriteAllBytes((Join-Path $backup 'snes9x-despues.conf'),$encoding.GetBytes($text))
 [IO.File]::WriteAllText((Join-Path $backup 'resultado.json'),(@{config=$config;changed=$changes}|ConvertTo-Json -Depth 5),[Text.UTF8Encoding]::new($false))
}
[pscustomobject]@{changed=$changes.Count;config=$config;backup=$backup}
