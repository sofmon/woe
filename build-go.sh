#!/bin/bash
echo "=== Start building dart applicaiton === "
cd ./editor; pub get; cd ..
dart2js ./editor/web/main.dart -m -o ./editor/main.js
rm ./go/owe.js.go
echo "package owe" >> ./go/owe.js.go
echo "const oweJS = \`" >> ./go/owe.js.go
sed 's/`/`+"`"+`/g' ./editor/main.js >> ./go/owe.js.go # fix bug in golang with long strings
echo "\`" >> ./go/owe.js.go
echo "=== Start building go applicaiton === "
go build ./go/