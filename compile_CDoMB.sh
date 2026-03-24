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
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    LIB_EXT="lib"
    DYLIB_EXT="dll"
    OBJ_EXT="obj"
    LDFLAGS=""
    INST_LOC="$LOCALAPPDATA"
else
    LIB_EXT="a"
    DYLIB_EXT="so"
    OBJ_EXT="o"
    LDFLAGS="-fPIC -Wl,-soname,libCDoMB.so"
    INST_LOC="$HOME/.local/lib"
fi

for f in *.cpp; do
    if [[ "$f" != "main.cpp" ]]; then
        clang++ @compile_flags.txt -c "$f" -o "${f%.cpp}.$OBJ_EXT"
    fi
done

ar rcs "bin/libCDoMB.${LIB_EXT}" *."$OBJ_EXT"
clang++ -shared $LDFLAGS -o "bin/libCDoMB.${DYLIB_EXT}" *."$OBJ_EXT"
mkdir -p "$INST_LOC"
if [[ $SHELL == "/bin/zsh" || $SHELL == "/usr/bin/zsh" ]]; then
    echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$INST_LOC" >> ~/.zshrc
elif [[ $SHELL == "/bin/bash" || $SHELL == "/usr/bin/bash" ]]; then
    echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$INST_LOC" >> ~/.bashrc
else
    echo "Non-BASH/Non-ZSH shell as default. Please add 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$INST_LOC' to your shell's path."
fi
mv -f "bin/libCDoMB.${DYLIB_EXT}" "$INST_LOC"
rm *."$OBJ_EXT"