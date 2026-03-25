#!/usr/bin/env bash

: '
SPDX Identifier: CC0-1.0
Copyright (c) 2026 Skylar Koningin
This code is licensed under the Creative Commons Zero v1.0 Universal License.
Please read "How to comply with the Creative Commons Zero License" in the README.md
'

set -e
mkdir -p bin
rm -f bin/*

if [[ "$OSTYPE" == "darwin"* ]]; then
    LIB_EXT="a"
    DYLIB_EXT="dylib"
    OBJ_EXT="o"
    LDFLAGS="-fPIC -Wl,-install_name,@rpath/libCDoMB.dylib"
    INST_LOC="$HOME/.local/lib"
elif [[ "$OSTYPE" == *"win"* ]]; then
    LIB_EXT="lib"
    DYLIB_EXT="dll"
    OBJ_EXT="obj"
    LDFLAGS="-target x86_64-windows-gnu"
    INST_LOC="$LOCALAPPDATA"
else
    LIB_EXT="a"
    DYLIB_EXT="so"
    OBJ_EXT="o"
    LDFLAGS="-fPIC -Wl,-soname,libCDoMB.so"
    INST_LOC="$HOME/.local/lib"
fi

for f in *.cpp; do
    if [[ "$LIB_EXT" == "lib" ]]; then
        zig c++ -target x86_64-windows-gnu -c "$f" @compile_flags.txt -o "${f%.cpp}.lib"
    else
        zig c++ -c "$f" @compile_flags.txt -o "${f%.cpp}.$OBJ_EXT"
    fi
done

zig ar rcs "bin/libCDoMB.${LIB_EXT}" *."$OBJ_EXT"
for f in *.cpp; do
    if [[ "$LIB_EXT" == "lib" ]]; then
        zig c++ -target x86_64-windows-gnu -shared $LDFLAGS -o bin/libCDoMB.dll *.obj
    else
        zig c++ -shared $LDFLAGS -o "bin/libCDoMB.${DYLIB_EXT}" *."$OBJ_EXT"
    fi
done
zig c++ -shared $LDFLAGS -o "bin/libCDoMB.${DYLIB_EXT}" *."$OBJ_EXT"
mkdir -p "$INST_LOC"
mv -f "bin/libCDoMB.${DYLIB_EXT}" "$INST_LOC"
echo "Please add 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$INST_LOC' to your shell's path (MacOS/Linux) or '%LOCALAPPDATA%' to your User Path (Windows) if you want to dynamically link."
rm *."$OBJ_EXT"