#!/usr/bin/env bash

: '
SPDX Identifier: CC0-1.0
Copyright (c) 2026 Skylar Koningin
This code is licensed under the Creative Commons Zero v1.0 Universal License.
Please read "How to comply with the Creative Commons Zero License" in the LICENSE_GUIDE.md
'

set -e
mkdir -p bin
rm -f bin/*

if [[ "$OSTYPE" == "darwin"* ]]; then
    DYLIB_EXT="dylib"
    LDFLAGS="-fPIC -Wl,-install_name,@rpath/libCDoMB.dylib"
    INST_LOC="$HOME/.local/lib"
elif [[ "$OSTYPE" == *"win"* || "$OSTYPE" == *"msys"* ]]; then
    DYLIB_EXT="dll"
    LDFLAGS="-target x86_64-windows-gnu"
    INST_LOC="$LOCALAPPDATA"
else
    DYLIB_EXT="so"
    LDFLAGS="-fPIC -Wl,-soname,libCDoMB.so"
    INST_LOC="$HOME/.local/lib"
fi

for f in *.cpp; do
    if [[ "$DYLIB_EXT" == "dll" ]]; then
        zig c++ -target x86_64-windows-gnu -c "$f" @compile_flags.txt -o "${f%.cpp}.o"
    else
        zig c++ -c "$f" @compile_flags.txt -o "${f%.cpp}.o"
    fi
done

ar rcs bin/libCDoMB.a *.o
if [[ "$DYLIB_EXT" == "dll" ]]; then
    zig c++ -target x86_64-windows-gnu -shared $LDFLAGS -o bin/libCDoMB.dll *.o
else
    zig c++ -shared $LDFLAGS -o "bin/libCDoMB.${DYLIB_EXT}" *.o
fi
mkdir -p "$INST_LOC"
mv -f "bin/libCDoMB.${DYLIB_EXT}" "$INST_LOC"
echo "Please add 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$INST_LOC' to your shell's path (MacOS/Linux) or '%LOCALAPPDATA%' to your User Path (Windows) if you want to dynamically link."
rm *.o

if [[ "$DYLIB_EXT" == "dll" ]]; then
    rm bin/*.pdb
    for f in bin/*.lib; do
        mv -f "$f" "bin/libCDoMB.dll.a"
    done
fi
