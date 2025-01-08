@echo ======================
@echo STARTING CLEANUP
@echo CLEANING %TEMP% FOLDER
@echo ======================
TIMEOUT 1 /nobreak
del "%tmp%\*.*" /s /q /f
FOR /d %%p IN ("%tmp%\*.*") DO rmdir "%%p" /s /q
@echo ======================
@echo DONE CLEANING %TEMP% FOLDER
@echo CLEANING WINDOWS TEMP FILES
@echo ======================
set folder="C:\Windows\Temp"
cd /d %folder%
for /F "delims=" %%i in ('dir /b') do (rmdir "%%i" /s/q || del "%%i" /s/q)
@echo ======================
@echo DONE CLEANING WINDOWS TEMP FILES
@echo CLEANING TARKOV CACHE
@echo ======================
set folder="C:\Battlestate Games\EscapeFromTarkov\cache"
cd /d %folder%
for /F "delims=" %%i in ('dir /b') do (rmdir "%%i" /s/q || del "%%i" /s/q)
set folder="C:\Battlestate Games\EFT\Logs"
cd /d %folder%
for /F "delims=" %%i in ('dir /b') do (rmdir "%%i" /s/q || del "%%i" /s/q)
@echo ======================
@echi DONE CLEARNING TARKOV CACHE
@echo CLEANING RECYCLE BIN
@echo ======================
TIMEOUT 1 /nobreak
PowerShell Clear-RecycleBin -force -ErrorAction:Ignore
@echo =========================
@echo DONE CLEANING RECYCLE BIN  
@echo DOING OTHER CLEANUP
@echo IF THIS TAKES MORE THAN 30 SECONDS, PRESS ANY KEY TO CONTINUE   
@echo =========================
@RD /S /Q "C:\Users\Therkesen\AppData\Roaming\Code\User\workspaceStorage"
del "C:\Users\Therkesen\AppData\Local\IconCache.db" /s /f /q
@echo -
@echo -
@echo -
@echo -
@echo -
@echo -
@echo -
@echo -
@echo -
@echo -
@echo -
@echo =========================
@echo CLEANUP FINISHED  
@echo BATCH FILE DONE            
@echo =========================

TIMEOUT 5 /nobreak
@exit