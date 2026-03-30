/*
 * SPDX Identifier: Apache-2.0 OR LGPL-3.0-or-later
 * Copyright (c) 2026 Skylar Koningin
 * This code is licensed under Apache License 2.0 or GNU Lesser General Public License v3.0 or later
 * If you would like to use the Apache License, read "How to comply with the Apache License" in the LICENSE_GUIDE.md
 * If you would like to use the GNU Lesser General Public License, read "How to comply with the LGPL" in the LICENSE_GUIDE.md
 */

#include "CDoMB.hpp"
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <print>

namespace CDoMB {

    void select_file_to_compile(std::string file) {
        {
            std::ifstream filetest(file);

            if (file.ends_with(".dna") || file.ends_with(".rna")) {
                if (!(filetest.is_open())) {
                    std::println(std::cerr, "File not found...\nEnsure you have typed the correct path.");
                    exit(1);
                } else {
                    filetest.close();
                }
            } else {
                std::println("ERR: Wrong input file type...");
                filetest.close();
                exit(1);
            }
        }
        std::string intermediary = file;
        if (intermediary.ends_with(".dna")) {
            intermediary.replace(intermediary.rfind(".dna"), 4, ".rna");
        }
        std::string output = intermediary;
        output.replace(output.rfind(".rna"), 4, ".protein");

        (file.ends_with(".dna") ? transpile_dna_to_rna(file, intermediary, true) : compile_rna_to_protein(intermediary, output));
    }
}
