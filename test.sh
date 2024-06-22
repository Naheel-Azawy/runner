#!/bin/sh
cd "t e s t" || exit 1
chmod +x ./*
chmod +x ./G\ U\ I/*

info() {
    echo "$* ============"
}

info IntelAsm     && time ./HelloIntelAsm.asm
info ArmAsm       && time ./HelloArmAsm.s
info C            && time ./HelloC.c
info Cpp          && time ./HelloCpp.cpp
info V            && time ./HelloV.v
info CS           && time ./HelloCS.cs
info Go           && time ./HelloGo.go
info Rust         && time ./HelloRust.rs
info Zig          && time ./HelloZig.zig
info Java         && time ./HelloJava.java 2>/dev/null
info Kotlin       && time ./HelloKotlin.kt 2>/dev/null
info KotlinScript && time ./HelloKotlinScript.kts 2>/dev/null
info TS           && time ./HelloTS.ts
info JS           && time ./HelloJS.js
info Py           && time ./HelloPy.py
info Sh           && time ./HelloSh.sh
info OCaml        && time ./HelloOCaml.ml
info AWK          && time ./HelloAWK.awk
info Perl         && time ./HelloPerl.pl
info R            && time ./HelloR.r
info Dart         && time ./HelloDart.dart
info Julia        && time ./HelloJulia.jl
info Lua          && time ./HelloLua.lua
info Haxe         && time ./HelloHaxe.hx
info Octave       && time ./HelloOctave.m 2>/dev/null
info Vala         && time ./HelloVala.vala

info TS from 3 to 5
rn -f 3 -t 5 ./HelloTS2.ts

if [ "$1" != -nw ]; then
    info Vala GUI
    ./G\ U\ I/HelloValaGtk.vala 2> /dev/null
fi

info Vala template
rn -r Hello vala 'print (@"$(args[1]) from VALA inline\n")'

info C++ template
rn -r Hello c++  'cout << argv[1] << " from CPP inline" << endl'

info C template
rn -r "1 1" c    'int i=atoi(argv[1]),j=atoi(argv[2]),k=i+j;printf("%d + %d = %d from C inline\n",i,j,k)'

if [ "$1" != -nw ]; then
    info Vala GUI template
    rn vala 'Gtk.init(ref args);
var w=new Gtk.Window();
w.title="Ello";
w.set_default_size(300,150);
w.border_width=10;
w.destroy.connect(Gtk.main_quit);
var b=new Gtk.Button();
b.label="CLICK ME!";
b.clicked.connect(()=>{print("clicked\n");Gtk.main_quit();});
w.add(b);
w.show_all();
Gtk.main()'
fi
