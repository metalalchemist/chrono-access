param(
    [string]$EmulatorFolder = (Join-Path $PSScriptRoot '..\Snes9x-Lua-1.63\snes9x-lua-1.63-win32-x64'),
    [switch]$Inspect
)
$ErrorActionPreference = 'Stop'
Add-Type -TypeDefinition @'
using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Text;
public static class ChronoLuaWindows {
    private delegate bool EnumProc(IntPtr hwnd, IntPtr param);
    [DllImport("user32.dll")] private static extern bool EnumWindows(EnumProc proc, IntPtr param);
    [DllImport("user32.dll")] private static extern bool EnumChildWindows(IntPtr parent, EnumProc proc, IntPtr param);
    [DllImport("user32.dll")] private static extern uint GetWindowThreadProcessId(IntPtr hwnd, out uint pid);
    [DllImport("user32.dll", CharSet=CharSet.Unicode)] private static extern int GetWindowText(IntPtr hwnd, StringBuilder text, int count);
    [DllImport("user32.dll", CharSet=CharSet.Unicode)] private static extern int GetClassName(IntPtr hwnd, StringBuilder text, int count);
    [DllImport("user32.dll", SetLastError=true)] private static extern IntPtr SendMessageTimeout(IntPtr hwnd, uint msg, IntPtr wp, IntPtr lp, uint flags, uint timeout, out IntPtr result);
    [DllImport("user32.dll", EntryPoint="SendMessageTimeoutW", CharSet=CharSet.Unicode, SetLastError=true)] private static extern IntPtr ReadControlText(IntPtr hwnd, uint msg, IntPtr wp, StringBuilder text, uint flags, uint timeout, out IntPtr result);
    public static IntPtr[] Windows(uint pid) {
        var windows = new List<IntPtr>();
        EnumWindows(delegate(IntPtr hwnd, IntPtr ignored) {
            uint found; GetWindowThreadProcessId(hwnd, out found);
            if (found == pid) windows.Add(hwnd);
            return true;
        }, IntPtr.Zero);
        return windows.ToArray();
    }
    public static IntPtr[] Children(IntPtr parent) {
        var windows = new List<IntPtr>();
        EnumChildWindows(parent, delegate(IntPtr hwnd, IntPtr ignored) { windows.Add(hwnd); return true; }, IntPtr.Zero);
        return windows.ToArray();
    }
    public static string Text(IntPtr hwnd) {
        var text = new StringBuilder(4096); GetWindowText(hwnd, text, text.Capacity);
        if (text.Length == 0 && Class(hwnd) == "Edit") {
            IntPtr result; ReadControlText(hwnd, 0xD, new IntPtr(text.Capacity), text, 2, 1000, out result);
        }
        return text.ToString();
    }
    public static string Class(IntPtr hwnd) {
        var text = new StringBuilder(256); GetClassName(hwnd, text, text.Capacity); return text.ToString();
    }
    public static void Click(IntPtr hwnd) {
        IntPtr result;
        if (SendMessageTimeout(hwnd, 0xF5, IntPtr.Zero, IntPtr.Zero, 2, 10000, out result) == IntPtr.Zero)
            throw new InvalidOperationException("La consola Lua no respondio. No se reinicio el juego.");
    }
}
'@
$taskEmulator = Join-Path (Resolve-Path -LiteralPath $EmulatorFolder).Path 'snes9x.exe'
$taskProcesses = @(Get-Process -Name snes9x -ErrorAction SilentlyContinue | Where-Object { $_.Path -eq $taskEmulator })
if ($taskProcesses.Count -ne 1) { throw 'Debe haber una sola instancia del Snes9x del lector abierta. Usa iniciar-lector.cmd para abrirla.' }
$taskAllowed = @(
    (Join-Path $PSScriptRoot 'lector-snes9x.lua'),
    (Join-Path (Split-Path -Parent $taskEmulator) 'Chrono Trigger (U) [T+Spa101%_Magno].lua')
)
$taskButtons = @()
foreach ($taskWindow in [ChronoLuaWindows]::Windows($taskProcesses[0].Id)) {
    $taskChildren = [ChronoLuaWindows]::Children($taskWindow)
    $taskMatches = @($taskChildren | Where-Object {
        [ChronoLuaWindows]::Class($_) -eq 'Edit' -and [ChronoLuaWindows]::Text($_) -in $taskAllowed
    })
    if ($Inspect) {
        foreach ($taskChild in $taskChildren) {
            if ([ChronoLuaWindows]::Class($taskChild) -eq 'Button' -or [ChronoLuaWindows]::Class($taskChild) -eq 'Edit') {
                Write-Output ([ChronoLuaWindows]::Class($taskChild) + ': ' + [ChronoLuaWindows]::Text($taskChild))
            }
        }
    }
    if ($taskMatches.Count -gt 0) {
        $taskButtons += @($taskChildren | Where-Object {
            [ChronoLuaWindows]::Class($_) -eq 'Button' -and
            [ChronoLuaWindows]::Text($_).Replace('&','').Trim() -match '^(Re.?start|Re.?run|Run|Reload)( Script)?$'
        })
    }
}
if ($Inspect) { return }
if ($taskButtons.Count -ne 1) { throw 'No se encontro una sola consola Lua del lector con boton de recarga. No se modifico la partida.' }
[ChronoLuaWindows]::Click($taskButtons[0])
Write-Host 'Lector recargado. La partida sigue abierta en su posicion actual.'
