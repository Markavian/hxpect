haxe build.hxml

set errorlevel=
neko src/run.n -excludeHxpectLib -regen
exit /b %errorlevel%
