/*
 * SPDX Identifier: Apache-2.0 OR LGPL-3.0-or-later
 * Copyright (c) 2026 Skylar Koningin
 * This code is licensed under Apache License 2.0 or GNU Lesser General Public License v3.0 or later
 * If you would like to use the Apache License, read "How to comply with the Apache License" in the README.md
 * If you would like to use the GNU Lesser General Public License, read "How to comply with the LGPL" in the README.md
 */

#include <algorithm>
#include <array>
#include <cstddef>
#include <cstdlib>
#include <fstream>
#include <print>
#include <string>
#include "CDoMB.hpp"
#include "lib/json.hpp"

namespace CDoMB {
    using json = nlohmann::json;

    const char three_to_one[] = {
        #embed "Three_to_One.json"
    };
    const char one_to_three[] = {
        #embed "One_to_Three.json"
    };

    void convert_three_to_one_protein(std::string protein_input, std::string protein_output) {
        if (!protein_input.ends_with(".protein") || !protein_output.ends_with(".protein")) {
            std::println("ERR: Wrong input/output file type...");
            exit(1);
        }

        std::ifstream input_fp(protein_input);
        std::ofstream output_fp(protein_output);
        std::string input;
        std::string line;
        auto three_letters = json::parse(std::begin(three_to_one), std::end(three_to_one));
        while (getline(input_fp, line)) {
            input += line;
        }
        {
            const std::array<char, 3> remove_chars = {' ', '\n', '\r'};
            for (char c : remove_chars) {
                input.erase(std::remove(input.begin(), input.end(), c), input.end());
            }
        }
        std::transform(input.begin(), input.end(), input.begin(), ::toupper);
        for (size_t i = 0; i + 2 < input.length(); i += 3) {
            if (i + 3 > input.length()) break;

            std::string chars = input.substr(i, 3);

            (three_letters.contains(chars) ? std::print(output_fp, "{} ", three_letters[chars].get<std::string>()) : std::print(output_fp, "X "));
        }
    }

    void convert_one_to_three_protein(std::string protein_input, std::string protein_output) {
        if (!protein_input.ends_with(".protein") || !protein_output.ends_with(".protein")) {
            std::println("ERR: Wrong input/output file type...");
            exit(1);
        }

        std::ifstream input_fp(protein_input);
        std::ofstream output_fp(protein_output);
        std::string input;
        std::string line;
        auto one_letter = json::parse(std::begin(one_to_three), std::end(one_to_three));
        while (getline(input_fp, line)) {
            input += line;
        }
        input.erase(std::remove(input.begin(), input.end(), ' '), input.end());
        input.erase(std::remove(input.begin(), input.end(), '\n'), input.end());
        input.erase(std::remove(input.begin(), input.end(), '\r'), input.end());
        std::transform(input.begin(), input.end(), input.begin(), ::toupper);
        for (size_t i = 0; i < input.length(); i++) {
            std::string ch = std::string(1, input[i]);

            (one_letter.contains(ch) ? std::print(output_fp, "{} ", one_letter[ch].get<std::string>()) : std::print(output_fp, "Unk "));
        }
    }
}
