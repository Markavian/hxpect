@echo off
haxe  -cp src -neko bin/HxpectTests.n -main "hxpect.tests.Main"
cd bin
neko HxpectTests.n
pause
