# Instalador del Planeador: lo copia a Documentos\Planeador, le pone su ícono en el escritorio y en el menú Inicio y lo abre.
# Se corre con Instalar.bat. Para actualizar, se vuelve a correr con la versión nueva: las planeaciones y «Mis datos» se quedan.
param(
  [string]$Destino = (Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'Planeador'),
  [switch]$Prueba           # para probarlo: sin íconos, sin abrirlo y sin esperar Enter
)
$ErrorActionPreference = 'Stop'
$origen = $PSScriptRoot

function Di($texto, $color = 'Gray') { Write-Host "  $texto" -ForegroundColor $color }
function Termina($codigo) {
  if (-not $Prueba) { Write-Host ''; Read-Host '  Presiona Enter para cerrar esta ventana' | Out-Null }
  exit $codigo
}

Write-Host ''
Di 'PLANEADOR · instalación' 'Cyan'
Write-Host ''

if (-not (Test-Path (Join-Path $origen 'servidor.py')) -or -not (Test-Path (Join-Path $origen 'motor\scripts\generar.py'))) {
  Di 'Faltan archivos junto al instalador.' 'Yellow'
  Di 'Primero descomprime el .zip: clic derecho en Planeador.zip → «Extraer todo…», y abre Instalar en la carpeta que sale.'
  Termina 1
}

# Lo que se bajó de internet trae la marca «de otro equipo»: se quita para que Windows no pregunte cada vez
Get-ChildItem -LiteralPath $origen -Recurse -File | Unblock-File -ErrorAction SilentlyContinue

# 1. Python: el portátil que viene en la carpeta «python» o el que ya tenga la computadora (3.8 o más nuevo)
function Python-Del-Sistema {
  foreach ($p in @(@{ exe = 'py'; pre = @('-3') }, @{ exe = 'python'; pre = @() })) {
    try {
      $pre = $p.pre
      $salida = @(& $p.exe @pre -c 'import sys; print(sys.executable); print(sys.version_info >= (3, 8))' 2>$null)
      if ($LASTEXITCODE -eq 0 -and $salida.Count -ge 2 -and $salida[1] -eq 'True' -and (Test-Path $salida[0])) {
        $w = Join-Path (Split-Path $salida[0]) 'pythonw.exe'
        if (Test-Path $w) { return $w }
      }
    } catch { }
  }
  return $null
}
$portatil = Test-Path (Join-Path $origen 'python\pythonw.exe')
if ($portatil) {
  $pyw = Join-Path $Destino 'python\pythonw.exe'
} else {
  $pyw = Python-Del-Sistema
  if (-not $pyw) {
    Di 'Esta computadora no tiene Python, y el Planeador lo necesita (es gratis).' 'Yellow'
    Di 'Ahora se abre la Tienda de Microsoft en Python: pica «Obtener» o «Instalar».'
    Di 'Cuando termine, vuelve a abrir Instalar.'
    $alias = Join-Path $env:LOCALAPPDATA 'Microsoft\WindowsApps\python.exe'
    if (Test-Path $alias) { Start-Process $alias } else { Start-Process 'https://www.python.org/downloads/' }
    Termina 1
  }
}
Di "Python: listo$(if ($portatil) { ' (portátil, viene con el Planeador)' })" 'Green'

# 2. Copia a Documentos\Planeador (si se corre desde ahí mismo, no hay nada que copiar)
$mismo = (Resolve-Path $origen).Path.TrimEnd('\') -eq [IO.Path]::GetFullPath($Destino).TrimEnd('\')
if (-not $mismo) {
  New-Item -ItemType Directory -Force -Path $Destino | Out-Null
  foreach ($carpeta in @('web', 'motor', 'datos', 'python')) {           # el programa: se reemplaza entero
    $d = Join-Path $Destino $carpeta
    if (Test-Path $d) { Remove-Item -LiteralPath $d -Recurse -Force }
    if (Test-Path (Join-Path $origen $carpeta)) { Copy-Item -LiteralPath (Join-Path $origen $carpeta) -Destination $d -Recurse }
  }
  foreach ($archivo in @('servidor.py', 'planeador.ico', 'LEEME.txt', 'Instalar.bat', 'instalar.ps1')) {
    Copy-Item -LiteralPath (Join-Path $origen $archivo) -Destination $Destino -Force
  }
  $plan = Join-Path $Destino 'planeaciones'                               # lo suyo: nunca se reemplaza
  New-Item -ItemType Directory -Force -Path $plan | Out-Null
  Get-ChildItem -LiteralPath (Join-Path $origen 'planeaciones') -File | ForEach-Object {
    if (-not (Test-Path (Join-Path $plan $_.Name))) { Copy-Item -LiteralPath $_.FullName -Destination $plan }
  }
}
Di "Carpeta: $Destino" 'Green'

# 3. Íconos en el escritorio y en el menú Inicio
$servidor = Join-Path $Destino 'servidor.py'
if (-not $Prueba) {
  $sh = New-Object -ComObject WScript.Shell
  foreach ($dir in @([Environment]::GetFolderPath('Desktop'), [Environment]::GetFolderPath('Programs'))) {
    $lnk = $sh.CreateShortcut((Join-Path $dir 'Planeador.lnk'))
    $lnk.TargetPath = $pyw
    $lnk.Arguments = "`"$servidor`" --app"
    $lnk.WorkingDirectory = $Destino
    $lnk.IconLocation = (Join-Path $Destino 'planeador.ico') + ',0'
    $lnk.Description = 'Planeaciones didácticas en Word y PDF'
    $lnk.Save()
  }
  Di 'Ícono «Planeador»: en el escritorio y en el menú Inicio' 'Green'
}

# 4. Word hace el PDF; sin Word, el Planeador solo saca el .docx
if (Test-Path 'Registry::HKEY_CLASSES_ROOT\Word.Application') {
  Di 'Microsoft Word: listo (para el PDF)' 'Green'
} else {
  Di 'No encontré Microsoft Word: el Planeador hará el Word (.docx), pero no el PDF.' 'Yellow'
}

Write-Host ''
Di 'Todo listo. Para abrirlo: doble clic en «Planeador» en el escritorio.' 'Cyan'
Di 'Tus planeaciones se guardan en la carpeta «planeaciones» de Documentos\Planeador.'
if (-not $Prueba) {
  Start-Process -FilePath $pyw -ArgumentList "`"$servidor`" --app" -WorkingDirectory $Destino
  Di 'Abriendo el Planeador…'
}
Termina 0
