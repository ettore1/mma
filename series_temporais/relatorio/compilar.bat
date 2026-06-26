@echo off
cd /d "%~dp0"
echo Compilando main.tex (passagem 1/2)...
pdflatex -interaction=nonstopmode main.tex
echo Compilando main.tex (passagem 2/2 - referencias e cross-refs)...
pdflatex -interaction=nonstopmode main.tex
echo.
echo Concluido! Abra main.pdf para visualizar.
pause
