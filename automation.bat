@echo off
set "CurDir="
for %%a in ("%cd%") do set "CurDir=%%~nxa"
if NOT "%CurDir%" == "QLKCL_Mobile_Flutter" exit

echo.
echo ==============================================
echo Push this code to QLKCL_Mobile_Flutter in Github...
set /P commit_content=Commit message: 
git add .
git commit -m "%commit_content%"
git push

echo.
echo ==============================================
echo Flutter clean
call flutter clean

echo.
echo ==============================================
echo Flutter build apk
call flutter build apk --release --no-sound-null-safety

echo.
echo ==============================================
echo Flutter build web
call flutter build web --release --base-href "/QLKCL_Web/" --no-sound-null-safety

cd ..
if exist %CD%\QLKCL_Mobile_Flutter\build\web\ (
    robocopy %CD%\QLKCL_Mobile_Flutter\build\web\ %CD%\QLKCL_Web\ /E
    @REM  /move /NFL /NDL /NJH /NJS /nc /ns /np
    cd QLKCL_Web
    echo.
    echo ==============================================
    echo Push this code to QLKCL_Web in Github...
    git add .
    git commit -m "%commit_content%"
    git push
)

echo.
echo ==============================================
echo Run successfully!!!
echo Press Any Key To Exit...
pause >nul