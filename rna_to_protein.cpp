/*
 * SPDX Identifier: Apache-2.0 OR LGPL-3.0-or-later
 * Copyright (c) 2026 Skylar Koningin
 * This code is licensed under Apache License 2.0 or GNU Lesser General Public License v3.0 or later
 * If you would like to use the Apache License, read "How to comply with the Apache License" in the LICENSE_GUIDE.md
 * If you would like to use the GNU Lesser General Public License, read "How to comply with the LGPL" in the LICENSE_GUIDE.md
 */

#include <algorithm>
#include <cstddef>
#include <cstdlib>
#include <fstream>
#include <print>
#include <string>
#include "CDoMB.hpp"
#include "lib/json.hpp"

namespace CDoMB {
    using json = nlohmann::json;

    const char rna_to_amino[] = {
        #embed "RNA_to_Protein.json"
    };

    void compile_rna_to_protein(std::string rna_input, std::string protein_output) {
        if (!rna_input.ends_with(".rna") || !protein_output.ends_with(".protein")) {
            std::println("ERR: Wrong input/output file type...");
            exit(1);
        }

        std::ifstream rna_fp(rna_input);
        std::ofstream protein_fp(protein_output);
        std::string mRNA;
        std::string line;
        auto codons = json::parse(std::begin(rna_to_amino), std::end(rna_to_amino));
        while (getline(rna_fp, line)) {
            mRNA += line;
        }
        {
            const std::array<char, 3> remove_chars = {' ', '\n', '\r'};
            for (char c : remove_chars) {
                mRNA.erase(std::remove(mRNA.begin(), mRNA.end(), c), mRNA.end());
            }
        }
        std::transform(mRNA.begin(), mRNA.end(), mRNA.begin(), ::toupper);
        bool started = false;
        for (size_t i = 0; i + 3 <= mRNA.length(); ) {
            std::string codon = mRNA.substr(i, 3);

            if (codon == "AUG" && !started) {
                started = true;
                std::print(protein_fp, "{} ", codons[codon].get<std::string>());
                i += 3;
                continue;
            }

            if (started) {
                if (codon == "UAA" || codon == "UAG" || codon == "UGA") {
                    std::print(protein_fp, "{} ", codons[codon].get<std::string>());
                    break;
                }

                (codons.contains(codon) ? std::print(protein_fp, "{} ", codons[codon].get<std::string>()) :std::print(protein_fp, "Unk "));
                i += 3;
            } else {
                i++;
            }
        }
    }
}
