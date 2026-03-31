# How to use this project
Select the license that you want to abide by:
- Apache - Permissive Copyright License (generally recommended for non-GPL open-source projects or non-open-source projects)
- GNU LGPL - Restrictive Copyleft License (recommended for GPL or open-source projects that use dynamic linking only)

Select a linking method:
- Source Code: copy the source files directly into your project (not recommended over statically or dynamically linking)
- Statically Linking: copy the static library into a folder in your project then link to it
- Dynamically Linking: link to the dynamic library's install location (standard location is `~/.local/lib` on Linux/MacOS or `%LOCALAPPDATA%` on Windows)

## How to comply with the Apache License 
1. Copy both the [LICENSE-APACHE](https://github.com/SkyeTheDeveloper/CDoMB/blob/main/LICENSE-APACHE) and [NOTICE.md](https://github.com/SkyeTheDeveloper/CDoMB/blob/main/NOTICE.md) files into your project's root folder.
2. Change the license file's name to "COPYING-CDoMB-Apache".
3. Use any linking method

## How to comply with the LGPL
### If your project is GPL:
1. Copy the [LICENSE-LGPL](https://github.com/SkyeTheDeveloper/CDoMB/blob/main/LICENSE-LGPL) file into your project's root folder.
2. Change the license file's name to "COPYING-CDoMB-LGPL".
3. Use any linking method

### If your project is open-source but non-GPL:
1. Copy the [LICENSE-LGPL](https://github.com/SkyeTheDeveloper/CDoMB/blob/main/LICENSE-LGPL) file into your project's root folder.
2. Change the license file's name to "COPYING-CDoMB-LGPL".
3. **Statically or Dynamically link, do not use source code at all.**

### If your project is non-open-source:
1. Copy the [LICENSE-LGPL](https://github.com/SkyeTheDeveloper/CDoMB/blob/main/LICENSE-LGPL) file into your project's root folder.
2. Change the license file's name to "COPYING-CDoMB-LGPL".
3. **Dynamically link only, do not use source code at all.**

## How to comply with the Creative Commons Zero License
**(only applies to [compile_CDoMB.sh](https://github.com/SkyeTheDeveloper/CDoMB/blob/main/compile_CDoMB.sh), [RNA_to_Protein.json](https://github.com/SkyeTheDeveloper/CDoMB/blob/main/RNA_to_Protein.json), [Three_to_One.json](https://github.com/SkyeTheDeveloper/CDoMB/blob/main/Three_to_One.json), and [One_to_Three.json](https://github.com/SkyeTheDeveloper/CDoMB/blob/main/One_to_Three.json))**
1. Copy the [LICENSE-CC0](https://github.com/SkyeTheDeveloper/CDoMB/blob/main/LICENSE-CC0) file into your project's root folder.
2. Change the license file's name to "COPYING-CDoMB_Build_Scripts-CC0".