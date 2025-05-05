@echo off
setlocal enabledelayedexpansion

rem Define the root directory
set "root_dir=C:\Users\jh\OneDrive - Scanpan\Scanpan (7.1.2015)\Development\SCANPAN Internal CodeBase - BC_DRIFT"

rem Define the output file
set "output_file=combined.txt"


rem Create or clear the output file
> "%output_file%" echo.

rem Traverse all directories and subdirectories
for /r "%root_dir%" %%f in (*.al) do (
    rem Read each file and append its content to the output file
    type "%%f" >> "%output_file%"
    echo. >> "%output_file%"
)

echo All text files have been combined into %output_file%.
pause
