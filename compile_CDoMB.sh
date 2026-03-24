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
    LDFLAGS="-Wl,-install_name,@rpath/libCDoMB.dylib"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    LIB_EXT="lib"
    DYLIB_EXT="dll"
    OBJ_EXT="obj"
    LDFLAGS=""
else
    LIB_EXT="a"
    DYLIB_EXT="so"
    OBJ_EXT="o"
    LDFLAGS="-Wl,-soname,libCDoMB.so"
fi

echo "Compiling objects..."
for f in *.cpp; do
    if [[ "$f" != "main.cpp" ]]; then
        clang++ @compile_flags.txt -fPIC -c "$f" -o "${f%.cpp}.$OBJ_EXT"
    fi
done

ar rcs "bin/libCDoMB.${LIB_EXT}" *."$OBJ_EXT"
clang++ -shared $LDFLAGS -o "bin/libCDoMB.${DYLIB_EXT}" *."$OBJ_EXT"
rm *."$OBJ_EXT"