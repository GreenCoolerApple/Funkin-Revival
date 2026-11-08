@echo off
setlocal EnableExtensions EnableDelayedExpansion
chcp 65001 >nul
cd /d "%~dp0.."
set "ROOT=%CD%"
set "LOGDIR=%ROOT%\build\logs"
if not exist "%LOGDIR%" mkdir "%LOGDIR%"
where haxe >nul 2>&1 || (echo [ERRO] Haxe nao encontrado no PATH.& pause & exit /b 1)
where haxelib >nul 2>&1 || (echo [ERRO] Haxelib nao encontrado no PATH.& pause & exit /b 1)
haxelib run lime --help >nul 2>&1
if errorlevel 1 (echo [ERRO] Lime nao encontrado. Instale/configure as dependencias do projeto.& pause & exit /b 1)
:menu
cls
echo ======================================
echo          FUNKIN REVIVAL BUILD
 echo ======================================
echo [1] Windows Release
echo [2] Windows Debug
echo [3] Windows Release 64-bit
echo [4] Executar Windows
echo [5] Limpar build Windows
echo [6] Versoes instaladas
echo [0] Sair
set /p "choice=Escolha: "
if "%choice%"=="1" (set "ARGS=build windows -release" & goto build)
if "%choice%"=="2" (set "ARGS=build windows -debug" & goto build)
if "%choice%"=="3" (set "ARGS=build windows -release -D HXCPP_M64" & goto build)
if "%choice%"=="4" goto run
if "%choice%"=="5" goto clean
if "%choice%"=="6" goto versions
if "%choice%"=="0" exit /b 0
goto menu
:build
set "LOG=%LOGDIR%\last-build.log"
echo Executando: haxelib run lime !ARGS!
echo Log: !LOG!
set "START=%TIME%"
call haxelib run lime !ARGS! >"!LOG!" 2>&1
set "RESULT=!ERRORLEVEL!"
type "!LOG!"
echo Inicio: !START!  Fim: !TIME!
if not "!RESULT!"=="0" (echo [ERRO] Build falhou. Codigo !RESULT!.) else (echo [OK] Build concluida.)
pause
goto menu
:run
call haxelib run lime run windows
if errorlevel 1 echo [ERRO] Nao foi possivel executar.
pause
goto menu
:clean
call haxelib run lime clean windows
if errorlevel 1 echo [ERRO] Falha ao limpar.
pause
goto menu
:versions
haxe --version
haxelib list
pause
goto menu
