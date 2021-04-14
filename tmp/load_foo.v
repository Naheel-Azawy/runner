import os
import json

struct Lang {
    ext      string
    name     string
    out_file string [json:outFile]
    cm       string
    rn       string
    tmp      string
    needs    []string
    install  LangInstall // TODO: flatten
    cm_args  []string
    equal    string
}

struct Langs {
    mut:
    m map[string]Lang
}

struct LangInstall {
    default string [json:default]
    arch    string
    fedora  string
    ubuntu  string
}

fn main() {
    languages_str := os.read_file("../runners.json") or {return}

    languages_map := json.decode(map[string]Lang, languages_str) or {
        panic('Failed to parse json')
    }

    for _, lang in languages_map {
        println(lang.ext)
    }
}
