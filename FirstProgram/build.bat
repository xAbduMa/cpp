@echo off
setlocal enabledelayedexpansion

:: ==========================================
:: Project Configuration
:: ==========================================
set APP_NAME=FirstProgram.exe
set SRC_DIR=src
set INC_DIR=include
set LIB_DIR=lib
set OBJ_BASE=obj
set BIN_BASE=bin

set CXX=g++
set BASE_FLAGS=-std=c++14 -Wall -Wextra -MMD -MP

:: List library names here (e.g., -lmingw32 -lSDL2main -lSDL2)
set LIBS=

:: ==========================================
:: Parse Arguments (debug, release, run, clean, rebuild)
:: ==========================================
set MODE=debug
set DO_RUN=0
set FORCE_REBUILD=0

for %%a in (%*) do (
    if /i "%%a"=="release" set MODE=release
    if /i "%%a"=="debug"   set MODE=debug
    if /i "%%a"=="run"     set DO_RUN=1
    if /i "%%a"=="rebuild" set FORCE_REBUILD=1
    if /i "%%a"=="clean"   goto :clean
)

if "%MODE%"=="debug" (
    set CXX_FLAGS=%BASE_FLAGS% -g -O0 -DDEBUG
) else (
    set CXX_FLAGS=%BASE_FLAGS% -O2 -DNDEBUG
)

set OBJ_DIR=%OBJ_BASE%\%MODE%
set BIN_DIR=%BIN_BASE%\%MODE%

if not exist "%OBJ_DIR%" mkdir "%OBJ_DIR%"
if not exist "%BIN_DIR%" mkdir "%BIN_DIR%"

:: ==========================================
:: Step 1: Check & Compile Modified .cpp Files
:: ==========================================
echo [BUILD] Mode: %MODE%
set OBJECTS=
set DID_COMPILE=0

for /r "%SRC_DIR%" %%f in (*.cpp) do (
    set "SRC_FILE=%%f"
    set "OBJ_FILE=%OBJ_DIR%\%%~nf.o"
    set "DEP_FILE=%OBJ_DIR%\%%~nf.d"
    set OBJECTS=!OBJECTS! "!OBJ_FILE!"

    call :check_needs_build "!SRC_FILE!" "!OBJ_FILE!" "!DEP_FILE!" NEEDS_BUILD

    if "!NEEDS_BUILD!"=="1" (
        echo   [CC] Compiling %%~nxf...
        %CXX% %CXX_FLAGS% -I"%INC_DIR%" -c "!SRC_FILE!" -o "!OBJ_FILE!"
        if !ERRORLEVEL! neq 0 (
            echo [ERROR] Failed compiling %%~nxf
            exit /b !ERRORLEVEL!
        )
        set DID_COMPILE=1
    )
)

:: ==========================================
:: Step 2: Link Only If Needed
:: ==========================================
if not defined OBJECTS (
    echo [ERROR] No .cpp files found in %SRC_DIR%\
    exit /b 1
)

set NEED_LINK=0
if %DID_COMPILE%==1 set NEED_LINK=1
if not exist "%BIN_DIR%\%APP_NAME%" set NEED_LINK=1

if %NEED_LINK%==1 (
    echo [LINK] Linking %BIN_DIR%\%APP_NAME%...
    %CXX% %OBJECTS% -L"%LIB_DIR%" %LIBS% -o "%BIN_DIR%\%APP_NAME%"
    if !ERRORLEVEL! neq 0 (
        echo [ERROR] Linking failed.
        exit /b !ERRORLEVEL!
    )
    if exist "%LIB_DIR%\*.dll" (
        copy /Y "%LIB_DIR%\*.dll" "%BIN_DIR%\" >nul
    )
    echo [SUCCESS] Build updated: %BIN_DIR%\%APP_NAME%
) else (
    echo [UP-TO-DATE] No changes detected.
)

if %DO_RUN%==1 (
    echo [RUN] Launching %APP_NAME%...
    echo ------------------------------------------
    "%BIN_DIR%\%APP_NAME%"
)
exit /b 0

:: ==========================================
:: Subroutine: Timestamp & Header Dependency Check
:: ==========================================
:check_needs_build
set "C_SRC=%~1"
set "C_OBJ=%~2"
set "C_DEP=%~3"
set "OUT_VAR=%~4"

if %FORCE_REBUILD%==1 (
    set "%OUT_VAR%=1"
    exit /b 0
)

if not exist "%C_OBJ%" (
    set "%OUT_VAR%=1"
    exit /b 0
)

call :is_newer "%C_SRC%" "%C_OBJ%" IS_NEW
if "%IS_NEW%"=="1" (
    set "%OUT_VAR%=1"
    exit /b 0
)

if exist "%C_DEP%" (
    for /f "usebackq delims=" %%L in ("%C_DEP%") do (
        set "LINE=%%L"
        set "LINE=!LINE:\=!"
        for %%H in (!LINE!) do (
            set "HDR=%%~H"
            if not "!HDR:~-1!"==":" (
                if exist "!HDR!" (
                    call :is_newer "!HDR!" "%C_OBJ%" HDR_NEW
                    if "!HDR_NEW!"=="1" (
                        set "%OUT_VAR%=1"
                        exit /b 0
                    )
                )
            )
        )
    )
)

set "%OUT_VAR%=0"
exit /b 0

:: ==========================================
:: Subroutine: Compare Two File Timestamps
:: ==========================================
:is_newer
set "%~3=0"
for /f %%i in ('xcopy /L /D /Y "%~1" "%~2" 2^>nul ^| findstr /B /C:"1 "') do (
    set "%~3=1"
)
exit /b 0

:: ==========================================
:: Clean Target
:: ==========================================
:clean
echo [CLEAN] Removing %OBJ_BASE% and %BIN_BASE% folders...
if exist "%OBJ_BASE%" rmdir /s /q "%OBJ_BASE%"
if exist "%BIN_BASE%" rmdir /s /q "%BIN_BASE%"
echo [CLEAN] Done.
exit /b 0
