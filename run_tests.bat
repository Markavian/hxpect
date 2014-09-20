@echo off
rmdir bin
mkdir bin
haxe  -cp src -neko bin/HxpectTests.n -main "hxpect.tests.Main"
cd bin
neko HxpectTests.n
