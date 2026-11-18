@echo off
setlocal

:: ==========================================
:: Validate Command Syntax
:: ==========================================
if /i not "%~1"=="project" (
    echo [USAGE] newCpp project "projectFolderName"
    exit /b 1
)

if "%~2"=="" (
    echo [ERROR] Please provide a project folder name.
    echo [USAGE] newCpp project "projectFolderName"
    exit /b 1
)

set "PROJ_NAME=%~2"

if exist "%PROJ_NAME%" (
    echo [ERROR] Folder "%PROJ_NAME%" already exists.
    exit /b 1
)

:: ==========================================
:: Create Directory Structure
:: ==========================================
echo [NEW] Creating C++ project "%PROJ_NAME%"...
mkdir "%PROJ_NAME%"
mkdir "%PROJ_NAME%\src"
mkdir "%PROJ_NAME%\include"
mkdir "%PROJ_NAME%\lib"
mkdir "%PROJ_NAME%\obj"
mkdir "%PROJ_NAME%\bin"

:: ==========================================
:: Create Starter src\main.cpp
:: ==========================================
(
echo #include ^<iostream^>
echo.
echo int main^(^) {
echo     std::cout ^<^< "Hello from %PROJ_NAME%!" ^<^< std::endl;
echo     return 0;
echo }
) > "%PROJ_NAME%\src\main.cpp"

:: ==========================================
:: Generate Incremental build.bat
:: ==========================================
(
echo @echo off
echo setlocal enabledelayedexpansion
echo.
echo :: ==========================================
echo :: Project Configuration
echo :: ==========================================
echo set APP_NAME=%PROJ_NAME%.exe
echo set SRC_DIR=src
echo set INC_DIR=include
echo set LIB_DIR=lib
echo set OBJ_BASE=obj
echo set BIN_BASE=bin
echo.
echo set CXX=g++
echo set BASE_FLAGS=-std=c++14 -Wall -Wextra -MMD -MP
echo.
echo :: List library names here ^(e.g., -lmingw32 -lSDL2main -lSDL2^)
echo set LIBS=
echo.
echo :: ==========================================
echo :: Parse Arguments ^(debug, release, run, clean, rebuild^)
echo :: ==========================================
echo set MODE=debug
echo set DO_RUN=0
echo set FORCE_REBUILD=0
echo.
echo for %%%%a in ^(%%*^) do ^(
echo     if /i "%%%%a"=="release" set MODE=release
echo     if /i "%%%%a"=="debug"   set MODE=debug
echo     if /i "%%%%a"=="run"     set DO_RUN=1
echo     if /i "%%%%a"=="rebuild" set FORCE_REBUILD=1
echo     if /i "%%%%a"=="clean"   goto :clean
echo ^)
echo.
echo if "%%MODE%%"=="debug" ^(
echo     set CXX_FLAGS=%%BASE_FLAGS%% -g -O0 -DDEBUG
echo ^) else ^(
echo     set CXX_FLAGS=%%BASE_FLAGS%% -O2 -DNDEBUG
echo ^)
echo.
echo set OBJ_DIR=%%OBJ_BASE%%\%%MODE%%
echo set BIN_DIR=%%BIN_BASE%%\%%MODE%%
echo.
echo if not exist "%%OBJ_DIR%%" mkdir "%%OBJ_DIR%%"
echo if not exist "%%BIN_DIR%%" mkdir "%%BIN_DIR%%"
echo.
echo :: ==========================================
echo :: Step 1: Check ^& Compile Modified .cpp Files
echo :: ==========================================
echo echo [BUILD] Mode: %%MODE%%
echo set OBJECTS=
echo set DID_COMPILE=0
echo.
echo for /r "%%SRC_DIR%%" %%%%f in ^(*.cpp^) do ^(
echo     set "SRC_FILE=%%%%f"
echo     set "OBJ_FILE=%%OBJ_DIR%%\%%%%~nf.o"
echo     set "DEP_FILE=%%OBJ_DIR%%\%%%%~nf.d"
echo     set OBJECTS=!OBJECTS! "!OBJ_FILE!"
echo.
echo     call :check_needs_build "!SRC_FILE!" "!OBJ_FILE!" "!DEP_FILE!" NEEDS_BUILD
echo.
echo     if "!NEEDS_BUILD!"=="1" ^(
echo         echo   [CC] Compiling %%%%~nxf...
echo         %%CXX%% %%CXX_FLAGS%% -I"%%INC_DIR%%" -c "!SRC_FILE!" -o "!OBJ_FILE!"
echo         if !ERRORLEVEL! neq 0 ^(
echo             echo [ERROR] Failed compiling %%%%~nxf
echo             exit /b !ERRORLEVEL!
echo         ^)
echo         set DID_COMPILE=1
echo     ^)
echo ^)
echo.
echo :: ==========================================
echo :: Step 2: Link Only If Needed
echo :: ==========================================
echo if not defined OBJECTS ^(
echo     echo [ERROR] No .cpp files found in %%SRC_DIR%%\
echo     exit /b 1
echo ^)
echo.
echo set NEED_LINK=0
echo if %%DID_COMPILE%%==1 set NEED_LINK=1
echo if not exist "%%BIN_DIR%%\%%APP_NAME%%" set NEED_LINK=1
echo.
echo if %%NEED_LINK%%==1 ^(
echo     echo [LINK] Linking %%BIN_DIR%%\%%APP_NAME%%...
echo     %%CXX%% %%OBJECTS%% -L"%%LIB_DIR%%" %%LIBS%% -o "%%BIN_DIR%%\%%APP_NAME%%"
echo     if !ERRORLEVEL! neq 0 ^(
echo         echo [ERROR] Linking failed.
echo         exit /b !ERRORLEVEL!
echo     ^)
echo     if exist "%%LIB_DIR%%\*.dll" ^(
echo         copy /Y "%%LIB_DIR%%\*.dll" "%%BIN_DIR%%\" ^>nul
echo     ^)
echo     echo [SUCCESS] Build updated: %%BIN_DIR%%\%%APP_NAME%%
echo ^) else ^(
echo     echo [UP-TO-DATE] No changes detected.
echo ^)
echo.
echo if %%DO_RUN%%==1 ^(
echo     echo [RUN] Launching %%APP_NAME%%...
echo     echo ------------------------------------------
echo     "%%BIN_DIR%%\%%APP_NAME%%"
echo ^)
echo exit /b 0
echo.
echo :: ==========================================
echo :: Subroutine: Timestamp ^& Header Dependency Check
echo :: ==========================================
echo :check_needs_build
echo set "C_SRC=%%~1"
echo set "C_OBJ=%%~2"
echo set "C_DEP=%%~3"
echo set "OUT_VAR=%%~4"
echo.
echo if %%FORCE_REBUILD%%==1 ^(
echo     set "%%OUT_VAR%%=1"
echo     exit /b 0
echo ^)
echo.
echo if not exist "%%C_OBJ%%" ^(
echo     set "%%OUT_VAR%%=1"
echo     exit /b 0
echo ^)
echo.
echo call :is_newer "%%C_SRC%%" "%%C_OBJ%%" IS_NEW
echo if "%%IS_NEW%%"=="1" ^(
echo     set "%%OUT_VAR%%=1"
echo     exit /b 0
echo ^)
echo.
echo if exist "%%C_DEP%%" ^(
echo     for /f "usebackq delims=" %%%%L in ^("%%C_DEP%%"^) do ^(
echo         set "LINE=%%%%L"
echo         set "LINE=!LINE:\=!"
echo         for %%%%H in ^(!LINE!^) do ^(
echo             set "HDR=%%%%~H"
echo             if not "!HDR:~-1!"==":" ^(
echo                 if exist "!HDR!" ^(
echo                     call :is_newer "!HDR!" "%%C_OBJ%%" HDR_NEW
echo                     if "!HDR_NEW!"=="1" ^(
echo                         set "%%OUT_VAR%%=1"
echo                         exit /b 0
echo                     ^)
echo                 ^)
echo             ^)
echo         ^)
echo     ^)
echo ^)
echo.
echo set "%%OUT_VAR%%=0"
echo exit /b 0
echo.
echo :: ==========================================
echo :: Subroutine: Compare Two File Timestamps
echo :: ==========================================
echo :is_newer
echo set "%%~3=0"
echo for /f %%%%i in ^('xcopy /L /D /Y "%%~1" "%%~2" 2^^^>nul ^^^| findstr /B /C:"1 "'^) do ^(
echo     set "%%~3=1"
echo ^)
echo exit /b 0
echo.
echo :: ==========================================
echo :: Clean Target
echo :: ==========================================
echo :clean
echo echo [CLEAN] Removing %%OBJ_BASE%% and %%BIN_BASE%% folders...
echo if exist "%%OBJ_BASE%%" rmdir /s /q "%%OBJ_BASE%%"
echo if exist "%%BIN_BASE%%" rmdir /s /q "%%BIN_BASE%%"
echo echo [CLEAN] Done.
echo exit /b 0
) > "%PROJ_NAME%\build.bat"

echo [DONE] Project "%PROJ_NAME%" created successfully!
echo        Run: cd "%PROJ_NAME%" ^&^& build run
exit /b 0
