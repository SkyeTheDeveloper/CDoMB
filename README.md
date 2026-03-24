# CDoMB (a DNA/RNA to Protein Compiler)
## Overview
CDoMB ("see-dahm"; /'si-dɑm/), an acronym meaning "Central Dogma of Molecular Biology", is a C++23 library that "compiles" DNA or RNA into a Protein Sequence.

I am using "transpile" to mean DNA to RNA transcription and "compile" to mean RNA to Protein translation, as those two ideas can easily be mapped onto one another due to the similarity between code transpilation/compilation and DNA -> RNA transcription/RNA -> Protein translation.

### Dependencies
Compiler: at minimum GCC 13, Clang 15, or MSVC 19.33
nlohmann/json: bundled!

### How to compile
1. Open a terminal in the root of this project
2. Run `chmod u+x ./compile_CDoMB.sh`
3. Run `./compile_CDoMB.sh`

### Code Example
```cpp
#include "CDoMB.hpp"

int main() {
  // this would compile from a single .dna or .rna file using the same file name for each file.
  CDoMB::select_file_to_compile("sequence.dna");
  
  // these would compile from a single file using a set file name for each file.
  CDoMB::transpile_dna_to_rna("sequence.dna", "rnaseq.rna");
  CDoMB::compile_rna_to_protein("rnaseq.rna", "protein.protein");
  
  // all of these output to files on your computer
}
```

### Important Notes
- **Input:** Files should be raw nucleotide text (there can be spaces or new lines between codons). The library **DOES NOT AND WILL NOT** support FASTA files.
- **Start Codon:** The compiler scans until it finds the first **AUG**. It will not start translating until it hits that, and if no start is found, the .protein file will be fully empty.
- **Interactive Prompt:** Processing `.dna` files will trigger a terminal prompt asking if you want to save the intermediary `.rna` file.
- **Unknown codons:** If a codon contains an invalid symbol or is not found in the translation table, it is replaced with an "X" in the output to indicate an unknown amino acid.

## How to use this project
See ["LICENSE_GUIDE.md"](https://github.com/SkyeTheDeveloper/CDoMB/blob/main/LICENSE_GUIDE.md)

## Credits
This project includes software developed by Niels Lohmann - Copyright (c) 2013-2026 Niels Lohmann.
See ["NOTICE.md"](https://github.com/SkyeTheDeveloper/CDoMB/blob/main/NOTICE.md) for more details.