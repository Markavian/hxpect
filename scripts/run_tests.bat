@echo off
haxe  -cp src -neko bin/HxpectTests.n -main hxpect.tests.Main

cd bin
set errorlevel=
neko HxpectTests.n
exit /b %errorlevel%
