#!/bin/bash
echo "=== Start building dart applicaiton === "
cd ./editor; pub get; cd ..
dart2js ./editor/web/main.dart -m -o ./editor/main.js
rm ./go/woe.js.go
echo "package woe" >> ./go/woe.js.go
echo "const woeJS = \`" >> ./go/woe.js.go
sed 's/`/`+"`"+`/g' ./editor/main.js >> ./go/woe.js.go # fix bug in golang with long strings
echo "\`" >> ./go/woe.js.go
echo "=== Start building go applicaiton === "
go build ./go/