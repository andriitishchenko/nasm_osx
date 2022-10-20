#### @2022
#### All text below applies to MacOs 11+ only

NASM - The Netwide Assembler 

>If you newcomer to NASM, start with DOCS https://www.nasm.us/docs.php , it will save your time.


Perhaps instead of setting up the environment locally, you could try the online NASM IDE. In this case, most examples from the Internet will work without special modifications for Macos.

* x64 https://www.mycompiler.io/new/asm-x86_64
* x64 https://ideone.com/qETYF4
* x32 https://www.tutorialspoint.com/compile_assembly_online.php
* x32 https://www.jdoodle.com/compile-assembler-nasm-online/
* x32 https://rextester.com/l/nasm_online_compiler

-----
[Part 1](README.md) | [Part 2](part2.md) | [Part 3](part3.md)
-----

# Intro to NASM

## How to use NASM for MacOs 11+?
1. install Command Line Tools
```
$ xcode-select --install
```
2. install NASM (https://brew.sh)
```
$ brew install nasm
```
3. create a file with code: 
>test.asm
```asm test.asm
bits 64                         ; x64 mode
section	.text                   ; section type
   global _main                 ; default entry point
_main:                          ; label name
        mov rax, 0x2000001      ; syscall 1: exit (
        mov rdi, 0              ;    retcode
        syscall                 ; )
```
>This code will do nothing. Just exit the app.
4. build to Object file
```
$ nasm -f macho64 test.asm -DDARWIN
```
>After running this command, "test.o" will be created.
5. link Object file to executable 
```
$ ld test.o -o test -demangle -dynamic -macosx_version_min 11.0 -L/usr/local/lib -syslibroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -lSystem -no_pie
```
>After running this command, executable "test" will be created.
6. run executable
```
$ ./test
```
>Thats it. Nothing will print because there are no any logic. 


# Lets optimize build process.

Create a new file, ``` $ touch Makefile```
>[Makefile](Makefile)
```
all:
	nasm -f macho64 $(source).asm -DDARWIN
	ld $(source).o -o $(source) -demangle -dynamic -macosx_version_min 11.0 -L/usr/local/lib -syslibroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -lSystem -no_pie
	rm $(source).o
```

Now to build and link any **filename**.asm file, run
```
$ make source=filename
```
>to build test.asm, run 
```
$ make source=test
```

# Using clang

```
$ nasm -f macho64 test.asm
$ clang -g -o test test.o -Wl,-no_pie
```


# Lets build and debug *.asm directly from Visual Studio Code(VSCode).

extensions: 
- CodeLLDB
- NASM Language Support

For breackpoints in *.asm
>debug.allowBreakpointsEverywhere = true

menu Code -> Preferences -> Settings, 
search "debug.allowBreakpointsEverywhere" and enable it.

Add VSCode launch.json and tasks.json:
```
-
 |_.vscode_|
 |         |_launch.json
 |         |_tasks.json
 |
 |_test.asm

$ mkdir .vscode
$ touch .vscode/launch.json
$ touch .vscode/tasks.json
```

>[launch.json](.vscode/launch.json)
```
{
    "version": "0.2.0",
    "configurations": [
        {
            "type": "lldb",
            "request": "launch",
            "name": "macho64",
            "program": "${fileDirname}/${fileBasenameNoExtension}",
            "cwd": "${workspaceFolder}",
            "args": [],
            "preLaunchTask": "ld-OSx"
        },
    ]
}
```
>[tasks.json](.vscode/tasks.json)
```
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "build-NASM",
            "command": "nasm", //nasm -f macho64 $(source).asm -DDARWIN
            "args": [
                "-f","macho64",
                "-F","dwarf",
                "-g","${file}"
            ]
        },
        {
            "label": "ld-OSx",
            "command": "/usr/bin/ld", //ld $(source).o -o $(source) -demangle -dynamic -macosx_version_min 11.0 -L/usr/local/lib -syslibroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -lSystem -no_pie
            "args": [
                "${fileDirname}/${fileBasenameNoExtension}.o",
                "-o","${fileDirname}/${fileBasenameNoExtension}",
                "-demangle",
                "-dynamic",
                "-macosx_version_min","11.0",
                "-L","/usr/local/lib",
                "-syslibroot","/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk",
                "-lSystem",
                "-no_pie"
            ],
            "dependsOn": [
                "build-NASM"
            ],
            "group": {
                "kind": "build",
                "isDefault": true
            },
            "problemMatcher": {
                "pattern": {
                    "regexp": "error"
                }
            },
            "presentation": {
                "focus": true,
                "panel": "dedicated",
                "reveal": "silent",
                "clear": true
            }
        },        
    ]
}
```

Now open file "test.asm" and press **F5** (Run->Start Debug). Breackpoints must also works.

>In debug mode, from the left panel, you can observe the state of the registers in the "VARIABLES" section.


# Xcode build 

>There are no registers debug window

Where are 2 ways:
1. Create a new build target with an external build system and customize it with the above commands.

2. Build Rules -> Custom -> [+]

Process file with names matching: *.asm
Using stript:
```
/usr/local/bin/nasm -f macho64 ${INPUT_FILE_PATH} -o ${SCRIPT_OUTPUT_FILE_0}
```
In the "Output Files" section and add the following:
```
$(DERIVED_FILE_DIR)/${INPUT_FILE_BASE}.o
```


## addons

Good article about LLDB https://rderik.com/blog/using-lldb-for-reverse-engineering/

and LLDB itself https://lldb.llvm.org/use/map.html


-----
[Part 1](README.md) | [Part 2](part2.md) | [Part 3](part3.md)
-----
