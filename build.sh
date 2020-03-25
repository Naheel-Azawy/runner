#!/bin/sh

mkdir -p build
v -o ./build/tmprn runner.v || exit
[ -f ./build/runners.v ] ||
    ./build/tmprn  --outlangs > ./build/runners.v

#sed -E '
#1d;$d;
#s/"\.(.+)": \{/langs.m["\1"] = Lang{/g;
#s/    \},/    }/g;
#s/"outFile": /out_file: /g;
#s/"(.+)": /\1: /g;
#s/install: /install: LangInstall/g;
#s/'"'"'/\\'"'"'/g;
#s/: "(.+)"/: r'"'"'\1'"'"'/g' \
#    runners.json > ./build/runners.v

sed -e '/\/\/ ### FILL FROM ITSELF ###/ {' \
    -e 'r ./build/runners.v' -e 'd' -e '}' \
    runner.v > ./build/rn.v
v -o ./build/rn ./build/rn.v

mv ./build/rn .
