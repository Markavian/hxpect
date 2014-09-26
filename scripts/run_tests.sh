#!/bin/bash
mkdir -p bin
haxe build.hxml
neko src/run.n -excludeHxpectLib -regen