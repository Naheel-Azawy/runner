# Runner
Run everything like a script!

Note that this might not be so stable as V is still in a very early stage. Maybe check the older version [Executor](https://github.com/Naheel-Azawy/Executor)

### Supported files
- C	(gcc)
- C++	(g++)
- V	(v)
- C#	(mcs and mono)
- VisualBasic .NET   (vbnc and mono)
- Go	(gccgo)
- Rust	(rustc)
- Java	(javac)
- Kotlin    (kotlinc and java)
- Kotlin Script (kotlinc -script)
- Vala	(valac)
- Genie	(valac)
- TypeScript	(tsc and node)
- JavaScript    (node)
- Python    (python3)
- GNU Octave    (octave)
- ARM Assembly (arm-linux-gnu-as, arm-linux-gnu-ld, and qemu-arm)
- Intel Assembly (nasm)
- OCaml (ocamlopt)
- Shell (bash)
- AWK (awk)
- Perl (perl)
- R (R)
- Dart (dart)
- Julia (julia)
- Haxe (haxe and python3)

### Installation
```sh
$ git clone https://github.com/Naheel-Azawy/runner.git
$ cd runner
$ make && sudo make install
```

### Usage

```sh
$ rn hello.c
```

Or even better, add a shebang to your file `test.vala`:

```c
#!/bin/rn
void main() { print ("Hello!\n"); }
```

```sh
$ chmod +x test.vala
$ ./test.vala
```

It's also possible to run a range of lines

```sh
$ ./test.ts --from 3 --to 5
```

One more cool feature! I leave you with examples:

```sh
$ rn -r Hello vala 'print (@"$(args[1]) from VALA\n")'
Hello from VALA
$ rn -r Hello c++ 'cout << argv[1] << " from CPP" << endl'
Hello from CPP
$ rn -r "1 1" c 'int i=atoi(argv[1]),j=atoi(argv[2]),k=i+j;printf("%d + %d = %d\n",i,j,k)'
1 + 1 = 2
```

### Emacs
Add this to you `.emacs`:

```
(defun run-program ()
  (interactive)
  (defvar cmd)
  (setq cmd (concat "rn " (buffer-name) ))
  (shell-command cmd))
(global-set-key [C-f5] 'run-program)
```

![screenshot](./screenshot-emacs.png)

### Gedit
Yes! it comes with a gedit plugin!

- Run `./install-gedit`
- Open gedit preferences -> plugins
- Enable Runner
- Enjoy 

![screenshot](./screenshot-gedit.png)

### Add / Override
Create `~/.config/.runners.json`. Example:

```json
{
    ".js": {
        "ext": "js",
        "outFile": "'{sourceFile}'",
        "cm": "",
        "rn": "gjs {outFile}"
    }
}
```

### Clean up
Binaries will be generated under '~/.cache/runnables directory.

### License
GPL

