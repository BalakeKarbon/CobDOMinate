# CobDOMinate
COBOL Library for interacting with the HTML DOM

Dependencies include:
 - Emscripten SDK
 - GnuCOBOL compiler
 - WASM GMP Library for use with Emscripten
 - WASM GnuCOBOL Library for use with Emscripten
 - Make

To build, setup your EMSDK environemnt and verify it has its own GMP and GnuCOBOL libraries. Then run `make`.

To install the library, veryfy the Makefile has the correct `LIB_INSTALL_DIR` and run `make install`.

Alternatively use my [Ancient Wasm](https://github.com/BalakeKarbon/ancientwasm) container for an easy ready-to-go environment.
