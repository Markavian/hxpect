#!/bin/bash
mkdir -p bin
haxe build.hxml
neko bin/HxpectTests.n
