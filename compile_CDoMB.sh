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

declare -a COMPILER=()
COMPILERS=("clang++" "zig" "g++")

if [[ "$OSTYPE" == "darwin"* ]]; then
    DYLIB_EXT="dylib"
    COMPFLAGS="-fPIC"
    LDFLAGS="-Wl,-install_name,@rpath/libCDoMB.dylib"
    INST_LOC="$HOME/.local/lib"
elif [[ "$OSTYPE" == *"win"* || "$OSTYPE" == *"msys"* ]]; then
    DYLIB_EXT="dll"
    INST_LOC="$LOCALAPPDATA"
    COMPILER=("zig" "c++")
else
    DYLIB_EXT="so"
    COMPFLAGS="-fPIC"
    LDFLAGS="-Wl,-soname,libCDoMB.so"
    INST_LOC="$HOME/.local/lib"
fi

if [[ ${#COMPILER[@]} -eq 0 ]]; then
    for comp in "${COMPILERS[@]}"; do
        if command -v "$comp" &>/dev/null; then
            if [[ "$comp" == "zig" ]]; then
                COMPILER=("zig" "c++")
            else
                COMPILER=("$comp")
            fi
            break
        fi
    done
fi
if [[ ${#COMPILER[@]} -eq 0 ]]; then
    echo "ERR: No compiler found... Ensure you have 'clang', 'zig', or 'gcc' installed."
    exit 1
fi

for f in *.cpp; do
    "${COMPILER[@]}" -c "$f" @compile_flags.txt $COMPFLAGS -o "${f%.cpp}.o"
done

ar rcs bin/libCDoMB.a *.o
"${COMPILER[@]}" -shared $LDFLAGS -o "bin/libCDoMB.${DYLIB_EXT}" *.o
mkdir -p "$INST_LOC"
mv -f "bin/libCDoMB.${DYLIB_EXT}" "$INST_LOC"
if [[ "$DYLIB_EXT" == "so" ]]; then
    echo "Please add 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$INST_LOC' to your shell's path if you want to dynamically link."
elif [[ "$DYLIB_EXT" == "dylib" ]]; then
    echo "Please add 'export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:$INST_LOC' to your shell's path if you want to dynamically link."
else
    echo "Please add '%LOCALAPPDATA%' to your User Path (Windows) if you want to dynamically link."
fi
rm *.o

if [[ "$DYLIB_EXT" == "dll" ]]; then
    rm -f bin/*.pdb
    for f in bin/*.lib; do
        mv -f "$f" "bin/libCDoMB.dll.a"
    done
fi
