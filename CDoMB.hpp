/*
 * SPDX Identifier: Apache-2.0 OR LGPL-3.0-or-later
 * Copyright (c) 2026 Skylar Koningin
 * This code is licensed under Apache License 2.0 or GNU Lesser General Public License v3.0 or later
 * If you would like to use the Apache License, read "How to comply with the Apache License" in the LICENSE_GUIDE.md
 * If you would like to use the GNU Lesser General Public License, read "How to comply with the LGPL" in the LICENSE_GUIDE.md
 */

#ifndef CDOMB
    #define CDOMB
    #include <string>
        
    namespace CDoMB {
        void select_file_to_compile(std::string file);
            
        void transpile_dna_to_rna(std::string dna_input, std::string rna_output, bool generate_intermediate);
            
        void compile_rna_to_protein(std::string rna_input, std::string protein_output);
        
        void convert_three_to_one_protein(std::string protein_input, std::string protein_output);
        void convert_one_to_three_protein(std::string protein_input, std::string protein_output);
    }
#endif