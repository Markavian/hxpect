haxe  -cp src -neko bin/HxpectTests.n -main hxpect.Main

set errorlevel=
neko bin/HxpectTests.n
exit /b %errorlevel%
