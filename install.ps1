# ============================================================
#  KUTTHROAT TOOL — One-Command Installer
#  Run as Administrator in PowerShell:
#  irm https://eugoo.github.io/kutthroat-tool/install.ps1 | iex
# ============================================================

$ErrorActionPreference = 'SilentlyContinue'

# ── BANNER ──────────────────────────────────────────────────
Clear-Host
Write-Host ""
Write-Host "  ██╗  ██╗██╗   ██╗████████╗████████╗██╗  ██╗██████╗  ██████╗  █████╗ ████████╗" -ForegroundColor Red
Write-Host "  ██║ ██╔╝██║   ██║╚══██╔══╝╚══██╔══╝██║  ██║██╔══██╗██╔═══██╗██╔══██╗╚══██╔══╝" -ForegroundColor Red
Write-Host "  █████╔╝ ██║   ██║   ██║      ██║   ███████║██████╔╝██║   ██║███████║   ██║   " -ForegroundColor DarkRed
Write-Host "  ██╔═██╗ ██║   ██║   ██║      ██║   ██╔══██║██╔══██╗██║   ██║██╔══██║   ██║   " -ForegroundColor DarkRed
Write-Host "  ██║  ██╗╚██████╔╝   ██║      ██║   ██║  ██║██║  ██║╚██████╔╝██║  ██║   ██║   " -ForegroundColor Red
Write-Host "  ╚═╝  ╚═╝ ╚═════╝    ╚═╝      ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝   " -ForegroundColor Red
Write-Host ""
Write-Host "  WINTOOL v2.0 — Windows Optimization Suite" -ForegroundColor Yellow
Write-Host "  ─────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host ""

# ── ADMIN CHECK ─────────────────────────────────────────────
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "  [!] ERROR: Please run PowerShell as Administrator" -ForegroundColor Red
    Write-Host "  Right-click PowerShell → Run as Administrator" -ForegroundColor Yellow
    Write-Host ""
    pause
    exit 1
}

Write-Host "  [✓] Running as Administrator" -ForegroundColor Green

# ── CHECK WINGET ────────────────────────────────────────────
Write-Host "  [~] Checking winget..." -ForegroundColor Cyan
$winget = Get-Command winget -ErrorAction SilentlyContinue

if (-not $winget) {
    Write-Host "  [!] Winget not found. Installing..." -ForegroundColor Yellow
    # Install winget via Microsoft Store
    Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
    Start-Sleep -Seconds 3
    Write-Host "  [✓] Winget installed" -ForegroundColor Green
} else {
    Write-Host "  [✓] Winget detected: $(winget --version)" -ForegroundColor Green
}

# ── LAUNCH METHOD ────────────────────────────────────────────
Write-Host ""
Write-Host "  Choose launch method:" -ForegroundColor White
Write-Host ""
Write-Host "  [1] Open in Browser (Full GUI)" -ForegroundColor Cyan
Write-Host "  [2] Quick Install — Preset (Essential Apps)" -ForegroundColor Cyan
Write-Host "  [3] Quick Install — Developer Pack" -ForegroundColor Cyan
Write-Host "  [4] Quick Install — Gaming Pack" -ForegroundColor Cyan
Write-Host "  [5] Apply Performance Tweaks Only" -ForegroundColor Cyan
Write-Host "  [6] Privacy Lockdown" -ForegroundColor Cyan
Write-Host ""

$choice = Read-Host "  Enter choice [1-6]"

switch ($choice) {

  "1" {
    Write-Host ""
    Write-Host "  [~] Opening KutthroatTool in your browser..." -ForegroundColor Cyan
    Start-Process "https://yourusername.github.io/kutthroat-tool"
    Write-Host "  [✓] Browser launched!" -ForegroundColor Green
  }

  "2" {
    Write-Host ""
    Write-Host "  [~] Installing Essential Apps Pack..." -ForegroundColor Yellow
    $essentials = @(
      @{ Name="Google Chrome";   ID="Google.Chrome" },
      @{ Name="7-Zip";           ID="7zip.7zip" },
      @{ Name="VLC";             ID="VideoLAN.VLC" },
      @{ Name="Notepad++";       ID="Notepad++.Notepad++" },
      @{ Name="Everything";      ID="voidtools.Everything" },
      @{ Name="Malwarebytes";    ID="Malwarebytes.Malwarebytes" },
      @{ Name="Bitwarden";       ID="Bitwarden.Bitwarden" }
    )
    Install-Apps $essentials
  }

  "3" {
    Write-Host ""
    Write-Host "  [~] Installing Developer Pack..." -ForegroundColor Yellow
    $devpack = @(
      @{ Name="VS Code";          ID="Microsoft.VisualStudioCode" },
      @{ Name="Git";              ID="Git.Git" },
      @{ Name="Node.js";          ID="OpenJS.NodeJS" },
      @{ Name="Python 3";         ID="Python.Python.3" },
      @{ Name="Windows Terminal"; ID="Microsoft.WindowsTerminal" },
      @{ Name="GitHub Desktop";   ID="GitHub.GitHubDesktop" },
      @{ Name="Postman";          ID="Postman.Postman" },
      @{ Name="Docker Desktop";   ID="Docker.DockerDesktop" }
    )
    Install-Apps $devpack
  }

  "4" {
    Write-Host ""
    Write-Host "  [~] Installing Gaming Pack..." -ForegroundColor Yellow
    $gaming = @(
      @{ Name="Steam";       ID="Valve.Steam" },
      @{ Name="Discord";     ID="Discord.Discord" },
      @{ Name="Epic Games";  ID="EpicGames.EpicGamesLauncher" },
      @{ Name="OBS Studio";  ID="OBSProject.OBSStudio" }
    )
    Install-Apps $gaming
  }

  "5" {
    Write-Host ""
    Write-Host "  [~] Applying Performance Tweaks..." -ForegroundColor Yellow
    Apply-PerformanceTweaks
  }

  "6" {
    Write-Host ""
    Write-Host "  [~] Applying Privacy Lockdown..." -ForegroundColor Yellow
    Apply-PrivacyTweaks
  }

  default {
    Write-Host "  [!] Invalid choice" -ForegroundColor Red
    exit 1
  }
}

# ── FUNCTIONS ────────────────────────────────────────────────

function Install-Apps($apps) {
    $total = $apps.Count
    $i = 0
    foreach ($app in $apps) {
        $i++
        $pct = [math]::Round(($i / $total) * 100)
        Write-Host ""
        Write-Host "  [$i/$total] Installing $($app.Name)... ($pct%)" -ForegroundColor Cyan
        Write-Progress -Activity "Installing Apps" -Status $app.Name -PercentComplete $pct
        winget install -e --id $app.ID --silent --accept-package-agreements --accept-source-agreements 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  [✓] $($app.Name) installed" -ForegroundColor Green
        } else {
            Write-Host "  [!] $($app.Name) may already be installed or failed" -ForegroundColor Yellow
        }
    }
    Write-Progress -Completed -Activity "Done"
    Write-Host ""
    Write-Host "  ══════════════════════════════" -ForegroundColor DarkGray
    Write-Host "  [✓] All $total apps processed!" -ForegroundColor Green
    Write-Host "  ══════════════════════════════" -ForegroundColor DarkGray
}

function Apply-PerformanceTweaks() {
    Write-Host "  [~] Setting High Performance power plan..." -ForegroundColor Cyan
    powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
    Write-Host "  [✓] Done" -ForegroundColor Green

    Write-Host "  [~] Disabling Xbox Game Bar..." -ForegroundColor Cyan
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "AppCaptureEnabled" -Value 0 -Force
    Write-Host "  [✓] Done" -ForegroundColor Green

    Write-Host "  [~] Showing file extensions..." -ForegroundColor Cyan
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0 -Force
    Write-Host "  [✓] Done" -ForegroundColor Green

    Write-Host "  [~] Disabling search indexing..." -ForegroundColor Cyan
    Stop-Service -Name WSearch -Force
    Set-Service -Name WSearch -StartupType Disabled
    Write-Host "  [✓] Done" -ForegroundColor Green

    Write-Host ""
    Write-Host "  [✓] Performance tweaks applied!" -ForegroundColor Green
    Write-Host "  Restart recommended for full effect." -ForegroundColor Yellow
}

function Apply-PrivacyTweaks() {
    Write-Host "  [~] Disabling telemetry..." -ForegroundColor Cyan
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -Force -ErrorAction SilentlyContinue
    Write-Host "  [✓] Done" -ForegroundColor Green

    Write-Host "  [~] Disabling advertising ID..." -ForegroundColor Cyan
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Value 0 -Force
    Write-Host "  [✓] Done" -ForegroundColor Green

    Write-Host "  [~] Disabling activity history..." -ForegroundColor Cyan
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableActivityFeed" -Value 0 -Force -ErrorAction SilentlyContinue
    Write-Host "  [✓] Done" -ForegroundColor Green

    Write-Host "  [~] Disabling location tracking..." -ForegroundColor Cyan
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Value "Deny" -Force -ErrorAction SilentlyContinue
    Write-Host "  [✓] Done" -ForegroundColor Green

    Write-Host ""
    Write-Host "  [✓] Privacy lockdown applied!" -ForegroundColor Green
}

# ── DONE ─────────────────────────────────────────────────────
Write-Host ""
Write-Host "  ─────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host "  KutthroatTool by Eugene — eugeneeipa73@gmail.com" -ForegroundColor DarkGray
Write-Host "  Full GUI: https://yourusername.github.io/kutthroat-tool" -ForegroundColor DarkGray
Write-Host "  ─────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host ""
pause
