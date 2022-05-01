@echo off
set "CurDir="
for %%a in ("%cd%") do set "CurDir=%%~nxa"
if NOT "%CurDir%" == "QLKCL_Mobile_Flutter" exit

echo.
echo ==============================================
@REM echo Push this code to QLKCL_Mobile_Flutter in Github...
set /P commit_content=Commit message: 
@REM git add .
@REM git commit -m "%commit_content%"
@REM git push

echo.
echo ==============================================
echo Flutter clean
call flutter clean

@REM echo.
@REM echo ==============================================
@REM echo Flutter build apk
@REM call flutter build apk --release --no-sound-null-safety

echo.
echo ==============================================
echo Flutter build web
call flutter build web --release --base-href "/" --no-sound-null-safety

cd ..
if exist %CD%\QLKCL_Mobile_Flutter\build\web\ (
    robocopy %CD%\QLKCL_Mobile_Flutter\build\web\ %CD%\QLKCL_Web\ /E
    @REM  /move /NFL /NDL /NJH /NJS /nc /ns /np
    cd QLKCL_Web
    echo.
    echo ==============================================
    echo Push this code to QLKCL_Web in Github...
    git pull
    git add .
    git commit -m "%commit_content%"
    git push
)

echo.
echo ==============================================
echo Run successfully!!!
echo Press Any Key To Exit...
pause >nul

@REM Script deploy web to github from codemagic
@REM "#!/usr/bin/env bash

@REM set -e # exit on first failed command
@REM set -x # print all executed commands to the log

@REM new_version=v1.0.$PROJECT_BUILD_NUMBER

@REM git clone https://$APP_PASSWORD_ENV_VARIABLE@github.com/lesonlhld/QLKCL_Web.git

@REM rsync -arv build/web/ QLKCL_Web/

@REM cd QLKCL_Web

@REM git add .
@REM git commit -m ""Published new version $new_version""
@REM git push -u origin master"