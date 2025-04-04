@echo off
set arg1=%1
set arg2=%arg1:~0,-4%
ffmpeg -y -i %arg1% -vf fps=10,scale=-1:-1:flags=lanczos,palettegen %TEMP%\palette.png
ffmpeg -i %arg1% -i %TEMP%\palette.png -filter_complex "fps=10,scale=-1:-1:flags=lanczos[x];[x][1:v]paletteuse" %arg2%.gif
del /f %TEMP%\palette.png