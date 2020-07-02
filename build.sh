#!/bin/sh

#V_GIT=https://github.com/Naheel-Azawy/v-bak
V_GIT=https://github.com/vlang/v

info() {
    printf "\e[1;34m%s\e[0m\n" "$*"
}

if command -v v >/dev/null; then
    V=v
    info 'USING SYSTEM V'
else
    V=./build/v/v
fi

build_v() {
    [ $V = v ] && return
    [ ! -f ./build/v/v ] &&
        info BUILDING V... &&
        cd build &&
        git clone "$V_GIT" v &&
        cd v &&
        make &&
        cd ../..
}

mkdir -p build
build_v
$V -o ./build/tmprn runner.v || exit
[ -f ./build/runners.v ] ||
    info BUILDING LANGS... &&
    ./build/tmprn  --outlangs > ./build/runners.v

info BUILDING "'rn'"...
sed -e '/\/\/ ### FILL FROM ITSELF ###/ {' \
    -e 'r ./build/runners.v' -e 'd' -e '}' \
    runner.v > ./build/rn.v
$V -o ./build/rn ./build/rn.v

mv ./build/rn .

info DONE
