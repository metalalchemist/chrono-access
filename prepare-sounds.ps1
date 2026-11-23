$ErrorActionPreference='Stop'
$ffmpeg=(Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..\bin\ffmpeg.exe')).Path
$output=Join-Path $PSScriptRoot 'runtime\sounds'
New-Item -ItemType Directory -Path $output -Force | Out-Null
$clips=@{
 wall_left='izquierda';wall_right='derecha';wall_up='adelante';wall_down='atras'
 wall_hit='pared colision';object_hit='chocar con objeto o persona'
 bed='cama';clock='reloj';stairs='escaleras';connection='interconexiones'
 person='persona';door='puerta';item='objeto que se puede agarrar';sign='letrero'
 furniture='objeto colision';games='juegos';bell_timing='bell-timing'
 save_point='punto de guardado'
}
$available=Get-ChildItem -LiteralPath (Join-Path $PSScriptRoot 'sounds') -File | Where-Object { $_.Extension -in '.mp3','.wav' }
foreach($name in $clips.Keys){
 $matches=@($available | Where-Object {
  [regex]::Replace($_.BaseName.Normalize([Text.NormalizationForm]::FormD),'\p{Mn}','') -eq $clips[$name]
 })
 if($matches.Count -ne 1){throw "No se encontro un unico sonido para $name"}
 $source=$matches[0].FullName
 $target=Join-Path $output ($name+'.wav')
 & $ffmpeg -hide_banner -loglevel error -y -i $source -map_metadata -1 -fflags +bitexact -flags:a +bitexact -vn -ac 1 -ar 22050 -c:a pcm_s16le -af 'afade=t=in:d=0.01' $target
 if($LASTEXITCODE -ne 0){throw "No se pudo convertir $source"}
}
# Two whole tones = four semitones. Preserve duration with atempo.
$enemyFilter='asetrate=22050*0.7937005259841,aresample=22050,atempo=1.259921049895'
& $ffmpeg -hide_banner -loglevel error -y -i (Join-Path $output 'person.wav') -map_metadata -1 -af $enemyFilter -ac 1 -ar 22050 -c:a pcm_s16le (Join-Path $output 'enemy.wav')
if($LASTEXITCODE -ne 0){throw 'No se pudo preparar enemy.wav'}
& $ffmpeg -hide_banner -loglevel error -y -i (Join-Path $output 'enemy.wav') -map_metadata -1 -c:a libmp3lame -q:a 2 (Join-Path $output 'enemy.mp3')
if($LASTEXITCODE -ne 0){throw 'No se pudo preparar enemy.mp3'}
Write-Host 'Sonidos preparados. Los originales se conservaron.'
