#!/bin/sh

info() {
    printf "\e[1;34m$*\e[0m\n"
}

build_v() {
    [ ! -f ./build/v/v ] &&
        info BUILDING V... &&
        cd build &&
        git clone https://github.com/Naheel-Azawy/v &&
        cd v &&
        make &&
        cd ../..
}

mkdir -p build
build_v
./build/v/v -o ./build/tmprn runner.v || exit
[ -f ./build/runners.v ] ||
    info BUILDING LANGS... &&
    ./build/tmprn  --outlangs > ./build/runners.v

info BUILDING "'rn'"...
sed -e '/\/\/ ### FILL FROM ITSELF ###/ {' \
    -e 'r ./build/runners.v' -e 'd' -e '}' \
    runner.v > ./build/rn.v
./build/v/v -o ./build/rn ./build/rn.v

mv ./build/rn .

info DONE
