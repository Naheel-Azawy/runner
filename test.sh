#!/bin/sh
cd "t e s t" || exit 1
chmod +x ./*
chmod +x ./G\ U\ I/*

info() {
    echo "$* ============"
}

info IntelAsm && ./HelloIntelAsm.asm
info ArmAsm && ./HelloArmAsm.s
info C && ./HelloC.c
info Cpp && ./HelloCpp.cpp
info V && ./HelloV.v
info CS && ./HelloCS.cs
info Go && ./HelloGo.go
info Rust && ./HelloRust.rs
info Zig && ./HelloZig.zig
info Java && ./HelloJava.java 2>/dev/null
info Kotlin && ./HelloKotlin.kt 2>/dev/null
info KotlinScript && ./HelloKotlinScript.kts 2>/dev/null
info TS && ./HelloTS.ts
info JS && ./HelloJS.js
info Py && ./HelloPy.py
info Sh && ./HelloSh.sh
info OCaml && ./HelloOCaml.ml
info AWK && ./HelloAWK.awk
info Perl && ./HelloPerl.pl
info R && ./HelloR.r
info Dart && ./HelloDart.dart
info Julia && ./HelloJulia.jl
info Lua && ./HelloLua.lua
info Haxe && ./HelloHaxe.hx
info Octave && ./HelloOctave.m 2>/dev/null
#info Genie && ./HelloGenie.gs # Something is wrong with valac...
info Vala && ./HelloVala.vala

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
