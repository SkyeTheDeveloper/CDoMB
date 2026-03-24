/*
 * SPDX Identifier: Apache-2.0 OR LGPL-3.0-or-later
 * Copyright (c) 2026 Skylar Koningin
 * This code is licensed under Apache License 2.0 or GNU Lesser General Public License v3.0 or later
 * If you would like to use the Apache License, read "How to comply with the Apache License" in the README.md
 * If you would like to use the GNU Lesser General Public License, read "How to comply with the LGPL" in the README.md
 */

#include <algorithm>
#include <cctype>
#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <print>
#include <string>
#include "CDoMB.hpp"

namespace CDoMB {
    namespace fs = std::filesystem;
    
    bool generate_intermediate;
    
    void transpile_dna_to_rna(std::string dna_input, std::string rna_output) {
        if (dna_input.substr(dna_input.length() - 4) != ".dna" || rna_output.substr(rna_output.length() - 4) != ".rna") {
            std::println("ERR: Wrong input/output file type...");
            exit(1);
        }
        
        {
            char save_intermediary = '\0';
            while (save_intermediary != 'y' && save_intermediary != 'n') {
                std::print("Do you want to generate an intermediary file (y/n)? ");
                if (!(std::cin >> save_intermediary)) {
                    std::println(std::cerr, "Invalid input...\nPlease enter 'y' or 'n'.");
                    save_intermediary = '\0';
                } else if (save_intermediary == 'y') {
                    generate_intermediate = true;
                } else if (save_intermediary == 'n') {
                    generate_intermediate = false;
                } else {
                    std::println("Invalid input...\nPlease try again.");
                }
            }
        }
        
        std::ifstream dna_fp(dna_input);
        std::ofstream rna_fp(rna_output);
        std::string transcription;
        std::string line;
        int i = 0;
        while (std::getline(dna_fp, line)) {
            for (char c : line) {
                if (!(c == ' ' || c == '\n' || c == '\r')) {
                    i++;
                    transcription += c;
                    if (i % 3 == 0) {
                        transcription += ' ';
                    }
                }
            }
        }
        std::transform(transcription.begin(), transcription.end(), transcription.begin(), ::toupper);
        std::replace(transcription.begin(), transcription.end(), 'T', 'U');
        transcription.pop_back();
        std::print(rna_fp, "{}", transcription);
        rna_fp.close();
        dna_fp.close();
        std::string output = rna_output;
        output.replace(output.rfind(".rna"), 4, ".protein");
        compile_rna_to_protein(rna_output, output);
        if (!generate_intermediate) {
            fs::remove(rna_output);
        }
    }
}