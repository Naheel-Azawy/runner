import (
    cli
    os
    json
)

struct Lang {
    ext      string
    name     string
    out_file string [json:outFile]
    cm       string
    rn       string
    tmp      string
    needs    []string
    install  LangInstall
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

fn init_langs() Langs {
    mut langs := Langs{map[string]Lang}
    // ### FILL FROM ITSELF ###
    langs.update('runners.json')
    langs.update(os.getenv('HOME') + '/.config/.runners.json')
    if langs.m.keys().len == 0 {
        panic('No runner languages found')
    }
    return langs
}

fn (l mut Langs) update(file string) {
    languages_str := os.read_file(file) or {
        return
    }
    languages_arr := json.decode([]Lang, languages_str) or {
        panic('Failed to parse json')
    }

    for lang in languages_arr {
        l.m[lang.ext] = lang
    }
}

fn (l Langs) get(ext string) Lang {
    if ext in l.m {
        if l.m[ext].equal != '' {
            return l.m[l.m[ext].equal[1..]]
        } else {
            return l.m[ext]
        }
    } else {
        panic('Unknown language extention `$ext`')
    }
}

fn (l Lang) get_installer(distro string) string {
    inst := match distro {
        'arch'   { l.install.arch    }
        'fedora' { l.install.fedora  }
        'ubuntu' { l.install.ubuntu  }
        else     { l.install.default }
    }
    if inst == '' {
        panic('Could not install ${l.name}. Please install it manually')
    } else {
        return inst
    }
}

pub fn (l Lang) str() string {
    return 'Lang{\n' +
        '    ext: ${enc_str(l.ext)},\n' +
        '    name: ${enc_str(l.name)},\n' +
        '    out_file: ${enc_str(l.out_file)},\n' +
        '    cm: ${enc_str(l.cm)},\n' +
        '    rn: ${enc_str(l.rn)},\n' +
        '    tmp: ${enc_str(l.tmp)},\n' +
        '    needs: ${l.needs},\n' +
        '    install: ${l.install},\n' +
        '    cm_args: $l.cm_args,\n'
        '    equal: ${enc_str(l.equal)}\n}'
}

pub fn (i LangInstall) str() string {
    return 'LangInstall{\n' +
        '        default: ${enc_str(i.default)},\n' +
        '        arch: ${enc_str(i.arch)},\n' +
        '        fedora: ${enc_str(i.fedora)},\n' +
        '        ubuntu: ${enc_str(i.ubuntu)}\n    }'
}

fn enc_str(s string) string {
    return "r'" + s
        .replace('\n', '\\n')
        .replace("'", '"') + "'"
}

fn enc_str_normal(s string) string {
    return "'" + s
        .replace('\n', '\\n')
        .replace("'", '"') + "'"
}

fn main() {
    mut cmd := cli.Command{
        name: 'rn',
        description: 'Run everything like a script!',
        version: '1.0.0',
        execute: run,
        parent: 0
    }
    cmd.add_flag(cli.Flag{ flag: .string, name: 'compargs',  abbrev: 'c',
                           description: 'Arguments from the compiler'})
    cmd.add_flag(cli.Flag{ flag: .string, name: 'runargs',   abbrev: 'r',
                           description: 'Running arguments'})
    cmd.add_flag(cli.Flag{ flag: .string, name: 'morefiles', abbrev: 'm',
                           description: 'Additional files'})
    cmd.add_flag(cli.Flag{ flag: .int,    name: 'from',      abbrev: 'f',
                           description: 'Lines from', value: '0'})
    cmd.add_flag(cli.Flag{ flag: .int,    name: 'to',        abbrev: 't',
                           description: 'Lines to',   value: '-1'})
    cmd.add_flag(cli.Flag{ flag: .bool,   name: 'showcmds',  abbrev: 'v'
                           description: 'Print executed commands'})
    cmd.add_flag(cli.Flag{ flag: .bool,   name: 'outlangs',
                           description: 'Output languages map'})
    cmd.parse(os.args)
}

fn run(cmd mut cli.Command) {

    languages := init_langs()

    outlangs := cmd.flags.get_bool('outlangs') or { panic(err) }
    if outlangs {
        for l in languages.m.keys() {
            println('langs.m[\'$l\'] = ${languages.m[l]}')
        }
        return
    }

    home := os.getenv('HOME')
    base := home + '/.cache/runnables'

    if !os.is_dir(base) {
        os.mkdir_all(base)
    }

    fr            := cmd.flags.get_int('from')         or { panic(err) }
    mut to        := cmd.flags.get_int('to')           or { panic(err) }
    cm_files      := cmd.flags.get_string('morefiles') or { panic(err) }
    mut cm_args   := cmd.flags.get_string('compargs')  or { panic(err) }
    mut rn_args   := cmd.flags.get_string('runargs')   or { panic(err) }
    show_commands := cmd.flags.get_bool('showcmds')    or { panic(err) }

    mut source_file := ''
    mut tmp         := false
    mut tmp_src     := ''

    if cmd.args.len > 0 {
        if os.exists(cmd.args[0]) {
            source_file = cmd.args[0]
            for i in 1..cmd.args.len {
                rn_args += ' ' + enc_str_normal(cmd.args[i])
            }
        } else if cmd.args[0] in languages.m {
            if cmd.args.len > 1 {
                tmp_src = cmd.args[1]
                for i in 2..cmd.args.len {
                    tmp_src += ' ' + cmd.args[i]
                }
                tmp_src += '\n'
                tmp = true
                source_file = '$base/Tmp.${cmd.args[0]}'
            } else {
                panic('Source needs to be provided as argument')
            }
        } else {
            panic('File `${cmd.args[0]}` not found')
        }
    } else {
        // shebang
        if os.args.len == 3 {
            mut new_args := [ os.args[0] ]
            // TODO: handle splitting correctly
            for arg in os.args[1].split(' ') {
                new_args << arg
            }
            new_args << os.args[2]

            /*println('=== OS')
            println(os.args)
            println('=== CMD')
            println(cmd.args)
            println('=== NEW')
            println(new_args)*/

            cmd.parse(new_args)
            return
        } else {
            panic('No input provided')
        }
    }

    source_file = os.real_path(source_file)
    index1 := source_file.last_index('/') or {panic('Wrong file name')}
    index2 := source_file.last_index('.') or {panic('Wrong file name')}

    arch             := get_arch()
    file_name        := source_file[index1+1..]
    file_name_no_ext := source_file[index1+1..index2]
    file_path        := source_file[..index1+1]
    file_extension   := source_file[index2..]
    out_path         := base + os.getwd() + '/'
    temp_file        := '${out_path}.${file_name}.tmp'
    mut input_files  := "'" + source_file + "'"
    if cm_files != '' {
        input_files += " '" + cm_files.replace('\$p', file_path) + "'"
    }

    mut vars_map := map[string]string
    vars_map['{arch}']          = arch
    vars_map['{fileName}']      = file_name
    vars_map['{fileNameNoExt}'] = file_name_no_ext
    vars_map['{filePath}']      = file_path
    vars_map['{fileExtension}'] = file_extension
    vars_map['{outPath}']       = out_path
    vars_map['{tempFile}']      = temp_file
    vars_map['{inputFiles}']    = input_files
    vars_map['{sourceFile}']    = source_file

    lang     := languages.get(file_extension[1..])
    out_file := format_item(vars_map, lang.out_file)
    vars_map['{outFile}'] = out_file
    mut cm   := format_item(vars_map, lang.cm)
    mut rn   := format_item(vars_map, lang.rn)

    cm_args = cm_args.replace('\$p', file_path)
    rn_args = rn_args.replace('\$p', file_path)

    // add compiler arguments from cli
    if cm != '' {
        cm += ' ' + cm_args
    }

    // add running arguments from cli
    rn += ' ' + rn_args

    if tmp && tmp_src != '' {
        if lang.tmp != '' {
            tmp_src = lang.tmp
                .replace('{{', '{')
                .replace('}}', '}')
                .replace('\\n', '\n')
                .replace('{s}', tmp_src)
        }
        os.write_file(source_file, tmp_src)
    }

    // TODO: use tmp_src if possible
    data_str := os.read_file(source_file) or {
        panic('Could not read file $source_file')
    }
    mut data := data_str.split('\n')

    // add compiler arguments from langs
    for i := 0; i < lang.cm_args.len; i += 2 {
        for line in data {
            if line.contains(lang.cm_args[i]) {
                cm += ' ' + lang.cm_args[i + 1]
            }
        }
    }

    // install deps if needed
    distro := get_distro()
    mut needs_install := false
    needed := lang.needs
    for dep in needed {
        if !is_installed(dep) {
            needs_install = true
            break
        }
    }
    if needs_install {
        println('Installing ${needed}...')
        os.system(lang.get_installer(distro))
    }

    // get the last modified time before moving if needed
    source_file_mtime := os.file_last_mod_unix(source_file)

    mut sh := false
    if data[0].starts_with('#!') {
        sh = true
        data[0] = ''
    }

    gen_temp := sh || fr != 0 || to != -1
    if gen_temp {
        os.mkdir_all(out_path)
        os.cp(source_file, temp_file) or {panic(err)}
        if to == -1 {
            to = data.len
        } else {
            to++
        }
        os.write_file(source_file, data[fr..to].join_lines())
    }

    // compile if needed
    mut code := 0
    bin := out_file[1..out_file.len-1]
    if !os.exists(bin) || os.file_last_mod_unix(bin) < source_file_mtime || fr != 0 || to != -1 {
        os.mkdir_all(out_path)
        if cm != '' {
            if show_commands {
                println('> $cm')
            }
            code = os.system(cm)
        }
    }

    if code == 0 {
        // run
        if show_commands {
            println('> $rn')
        }
        os.system("cd '$file_path' && $rn")
    }

    if tmp {
        os.rm(source_file)
    }

    if gen_temp {
        os.cp(temp_file, source_file) or {panic(err)}
    }

    //println('{cm} = $cm')
    //println('{rn} = $rn')
    //println('{cm_args} = $cm_args')
    //println('{rn_args} = $rn_args')
    //println(distro)
    //for v in vars_map.keys() {
    //    println('$v = ${vars_map[v]}')
    //}
    //println(source_file)
    //println(data)
    //println(is_installed('gcc'))
    //println(lang.get_installer(distro))
    //println(languages.get('v').get_installer(distro))
    //println(json.encode(languages.get('gs')))
    //println(json.encode(languages))
    //println('fr=$fr, to=$to, cm_args=$cm_args, rn_args=$rn_args, args=${cmd.args[0]}')
}

fn format_item(m map[string]string, s string) string {
    mut res := s.clone()
    for v in m.keys() {
        res = res.replace(v, m[v])
    }
    return res
}

fn get_arch() string {
    o := os.exec('uname -m') or {
        panic('Failed getting machine architecture')
    }
    return if o.output.contains('64') {'64'} else {'32'}
}

fn get_distro() string {
    o := os.exec('lsb_release -ds') or {
        panic('Failed getting distribution name')
    }
    to := o.output.index(' ') or {o.output.len - 2}
    return o.output[1..to].to_lower()
}

fn is_installed(name string) bool {
    o := os.exec('command -v $name') or {
        panic('Failed checking for dependencies')
    }
    return o.exit_code == 0
}

