# raylib and raygui in zig

I am trying to get raygui to work with raylib in a zig project. raygui itself relys on raylib and so i've been hitting issues trying to get them to work together. The current implimentation of raygui support inside of raylib using the build.zig file relys on the raygui.h file to be provided by the user in a location zig can find. But I would really like this to be handled by the zig package manager so this project can be built from source with no required files from the user (or having the raygui.h file shipped with the source of this repo)

# current build error

```
pavocracy@minty:~/git/personal/raylib-and-raygui-in-zig$ zig build run
zig build-lib raygui Debug native: error: error(compilation): clang failed with stderr: In file included from /home/pavocracy/git/personal/raylib-and-raygui-in-zig/zig-cache/o/bd6f69c4ad671ea1a3d06ec144b15c9d/src/raygui.c:3:
/home/pavocracy/.cache/zig/p/122005a45aa0cf025fd0e72f3f3ec9b8c738cc86c52cb32d72d334035acdcee1c726/src/raygui.h:1623:118: error: use of undeclared identifier 'BLANK'
/home/pavocracy/.cache/zig/p/122005a45aa0cf025fd0e72f3f3ec9b8c738cc86c52cb32d72d334035acdcee1c726/src/raygui.h:1624:137: error: use of undeclared identifier 'BLANK'
/home/pavocracy/.cache/zig/p/122005a45aa0cf025fd0e72f3f3ec9b8c738cc86c52cb32d72d334035acdcee1c726/src/raygui.h:1625:137: error: use of undeclared identifier 'BLANK'
/home/pavocracy/.cache/zig/p/122005a45aa0cf025fd0e72f3f3ec9b8c738cc86c52cb32d72d334035acdcee1c726/src/raygui.h:1650:128: error: use of undeclared identifier 'BLANK'
/home/pavocracy/.cache/zig/p/122005a45aa0cf025fd0e72f3f3ec9b8c738cc86c52cb32d72d334035acdcee1c726/src/raygui.h:1660:152: error: use of undeclared identifier 'BLANK'
/home/pavocracy/.cache/zig/p/122005a45aa0cf025fd0e72f3f3ec9b8c738cc86c52cb32d72d334035acdcee1c726/src/raygui.h:1662:214: error: use of undeclared identifier 'BLANK'
/home/pavocracy/.cache/zig/p/122005a45aa0cf025fd0e72f3f3ec9b8c738cc86c52cb32d72d334035acdcee1c726/src/raygui.h:1716:56: error: call to undeclared function 'GetScreenWidth'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
/home/pavocracy/.cache/zig/p/122005a45aa0cf025fd0e72f3f3ec9b8c738cc86c52cb32d72d334035acdcee1c726/src/raygui.h:1767:112: error: use of undeclared identifier 'BLANK'
/home/pavocracy/.cache/zig/p/122005a45aa0cf025fd0e72f3f3ec9b8c738cc86c52cb32d72d334035acdcee1c726/src/raygui.h:1877:54: error: use of undeclared identifier 'KEY_LEFT_CONTROL'
/home/pavocracy/.cache/zig/p/122005a45aa0cf025fd0e72f3f3ec9b8c738cc86c52cb32d72d334035acdcee1c726/src/raygui.h:1877:85: error: use of undeclared identifier 'KEY_LEFT_SHIFT'
/home/pavocracy/.cache/zig/p/122005a45aa0cf025fd0e72f3f3ec9b8c738cc86c52cb32d72d334035acdcee1c726/src/raygui.h:1893:33: error: use of undeclared identifier 'BLANK'
/home/pavocracy/.cache/zig/p/122005a45aa0cf025fd0e72f3f3ec9b8c738cc86c52cb32d72d334035acdcee1c726/src/raygui.h:1920:37: error: use of undeclared identifier 'BLANK'
/home/pavocracy/.cache/zig/p/122005a45aa0cf025fd0e72f3f3ec9b8c738cc86c52cb32d72d334035acdcee1c726/src/raygui.h:1924:119: error: use of undeclared identifier 'BLANK'
/home/pavocracy/.cache/zig/p/122005a45aa0cf025fd0e72f3f3ec9b8c738cc86c52cb32d72d334035acdcee1c726/src/raygui.h:2172:60: error: use of undeclared identifier 'BLANK'
/home/pavocracy/.cache/zig/p/122005a45aa0cf025fd0e72f3f3ec9b8c738cc86c52cb32d72d334035acdcee1c726/src/raygui.h:2173:66: error: use of undeclared identifier 'BLANK'
/home/pavocracy/.cache/zig/p/122005a45aa0cf025fd0e72f3f3ec9b8c738cc86c52cb32d72d334035acdcee1c726/src/raygui.h:2174:66: error: use of undeclared identifier 'BLANK'
/home/pavocracy/.cache/zig/p/122005a45aa0cf025fd0e72f3f3ec9b8c738cc86c52cb32d72d334035acdcee1c726/src/raygui.h:2185:86: error: call to undeclared function 'Fade'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
/home/pavocracy/.cache/zig/p/122005a45aa0cf025fd0e72f3f3ec9b8c738cc86c52cb32d72d334035acdcee1c726/src/raygui.h:2185:86: error: passing 'int' to parameter of incompatible type 'Color' (aka 'struct Color')
/home/pavocracy/.cache/zig/p/122005a45aa0cf025fd0e72f3f3ec9b8c738cc86c52cb32d72d334035acdcee1c726/src/raygui.h:1471:86: note: passing argument to parameter 'tint' here
/home/pavocracy/.cache/zig/p/122005a45aa0cf025fd0e72f3f3ec9b8c738cc86c52cb32d72d334035acdcee1c726/src/raygui.h:2242:120: error: use of undeclared identifier 'BLANK'
fatal error: too many errors emitted, stopping now [-ferror-limit=]


zig build-lib raygui Debug native: error: the following command failed with 1 compilation errors:
/usr/local/zig/zig build-lib /home/pavocracy/git/personal/raylib-and-raygui-in-zig/zig-cache/o/bd6f69c4ad671ea1a3d06ec144b15c9d/src/raygui.c -lGL -lX11 -lc --cache-dir /home/pavocracy/git/personal/raylib-and-raygui-in-zig/zig-cache --global-cache-dir /home/pavocracy/.cache/zig --name raygui -static -I /home/pavocracy/.cache/zig/p/122005a45aa0cf025fd0e72f3f3ec9b8c738cc86c52cb32d72d334035acdcee1c726/src/ -I /home/pavocracy/.cache/zig/p/1220bd9c983d89fa08ecfcec29f5e35887dd023ab99b98845be6e929989f71ee661b/src/ -I /home/pavocracy/git/personal/raylib-and-raygui-in-zig/zig-cache/i/d4fdc9814ac66070f7f7765f51559bbe/include --listen=- 
Build Summary: 6/12 steps succeeded; 1 failed (disable with --summary none)
run transitive failure
└─ run raylib-and-raygui-example transitive failure
   ├─ zig build-exe raylib-and-raygui-example Debug native transitive failure
   │  └─ zig build-lib raygui Debug native 1 errors
   └─ install transitive failure
      └─ install raylib-and-raygui-example transitive failure
         └─ zig build-exe raylib-and-raygui-example Debug native (+5 more reused dependencies)
/home/pavocracy/git/personal/raylib-and-raygui-in-zig/zig-cache/o/bd6f69c4ad671ea1a3d06ec144b15c9d/src/raygui.c:1:1: error: unable to build C object: clang exited with code 1
```

# current zig version

```
pavocracy@minty:~/git/personal/raylib-and-raygui-in-zig$ zig version
0.12.0-dev.817+54e7f58fc
```
