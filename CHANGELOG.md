# Changelog - Amy's ColecoVision Assembler

All notable changes to this project will be documented in this file.

---

## [Version 2.1] - 2026-01-24 (Beta: Work-in-Progress)

### New Features

**1. Assembler-Level Commands**
- print: display messages during assembly
- fail: stop assembly with an error message
- stop: halt assembly immediately
- let: assign values to symbols at assembly time
- repeat/rend: fixed-count loop for code generation
- while/wend/endw: conditional loop for assembly-time logic
- switch/case/default/endswitch: multi-branch selection at assembly time

**2. Math Expression Parsing**
- Trigonometric functions: SIN, COS, TAN, ASIN, ACOS, ATAN (degree-based)
- Logarithmic/Exponential: LOG, LOG2, LOG10, EXP, SQRT
- Utility functions: ABS, FLOOR, CEIL

---

## [Version 2.0] - 2026-01-21 (Improvements and BugFix)

### New Features
- Rename "Optimize" to "Optimize on Build"
- Add BLOCK directive
- Add tests folder with files to check for parser issues
- Add missing Z80 opcodes (oops!)

---

## [Version 1.0.0] - 2026-01-18

### Phase 1 Features Complete

This release adds new features to both Standard and Pro versions, improving compatibility with other Z80 assemblers like WLA-DX.

### New Features

**1. STRUCT/ENDSTRUCT Directive**
Define structured data types with automatic field offset calculation.

    STRUCT Sprite
        x_pos   DB 1
        y_pos   DB 1
        pattern DB 1
        color   DB 1
    ENDSTRUCT

    player: Sprite              ; Creates player.x_pos, player.y_pos, etc.
    ld (player.x_pos), a        ; Access fields with dot notation
    ASSERT SIZEOF_Sprite == 4   ; Automatic SIZEOF symbols

**2. ASSERT Directive**
Compile-time validation with custom error messages.

    ASSERT SCREEN_WIDTH == 256, "Screen width must be 256"
    ASSERT (code_end < $C000), "Code exceeded ROM space!"
    ASSERT ((sprite_table & 3) == 0), "Must be 4-byte aligned"

**3. Enhanced INCBIN Directive**
Include binary files with advanced range selection and size tracking (WLA-DX compatible).

    INCBIN "data.bin"                          ; Whole file
    INCBIN "sprites.bin", SKIP 128             ; Skip first 128 bytes
    INCBIN "font.bin", READ 256                ; Read only 256 bytes
    INCBIN "music.bin", SKIP 64, READ 512      ; Combined
    INCBIN "level1.bin", FSIZE level1_size     ; Create size symbol
    INCBIN "rom.bin", SKIP -128                ; Last 128 bytes
    INCBIN "rom.bin", READ -64                 ; All but last 64 bytes

**4. Z80 Code Optimizer**
Optional optimizer with 6 optimization types (disabled by default):
- Arithmetic no-ops removal (ADD A,0 -> removed)
- Redundant load elimination (LD A,5; LD A,10 -> keep second only)
- INC/DEC cancellation (INC A; DEC A -> both removed)
- CP 0 -> OR A conversion (saves 1 byte)
- PUSH/POP cancellation (PUSH AF; POP AF -> both removed)
- JP -> JR conversion when in range (saves 1 byte)

Enable with ⚡ Optimize Code checkbox. Shows bytes saved (e.g., 💾 -34 bytes).

### Bug Fixes
- Fixed INCBIN parameter parsing (SKIP/READ/FSIZE keywords)
- Fixed negative number parsing for INCBIN offsets
- Fixed ASSERT expression splitting
- Fixed FileMap memory leak

### Improvements
- Enhanced number parser (negative values support)
- Improved expression evaluation for ASSERT
- Cleaner console output (reduced debug traces)
- Symbol table properly rebuilt after optimization

### File Changes
- AmysCVAssembler.html: 175 KB -> 259 KB (+84 KB)
- AmysCVAssemblerPro.html: 334 KB -> 418 KB (+84 KB)

### Compatibility
- 100% backwards compatible
- WLA-DX INCBIN syntax compatible
- All existing code works without modification

---

## [Version 0.3] - 2026-01-08 (Initial Public Release)

Browser-based Z80 assembler for ColecoVision game development with no installation required.

### Features
- Standard and Pro versions (Pro: multi-module linking, .REL files, .LIB libraries)
- Multiple syntax support: zmac, TASM, MACRO-80, MRAS, Intel, Motorola
- Number formats: hex ($, 0x, h), binary (%, 0b, b), octal (@)
- MACRO, INCLUDE, REPT, conditional assembly (IF/ELSE/ENDIF)
- **TIMES directive** (repeat instruction/data)
- **ALIGN directive** (boundary alignment)
- **Enhanced expression operators** ($, HIGH, LOW, <, >)
- CodeMirror syntax highlighting
- ColecoVision boot screen simulation (TMS9918A rendering)
- Symbol table generation (.sym files for OpenMSX debugging)
- Output: .COL ROM files compatible with emulators and flash cartridges

### Additions (Jan 8th update)
- Improved UI/UX
- Added TIMES and ALIGN directives
- Enhanced expression operators

---

## [Version 0.2] - 2026-01-02

### Changes
- Automatic BBC Micro hex format conversion (&xxxx -> $xxxx)
- Support copy-paste ASM code from online sources
- Improved touch screen device support (tablets)
- Changed output format from .BIN to .COL (better emulator association)
- Added .SYM file generation for OpenMSX debugging (experimental)

---

## Getting Started

1. Open `AmysCVAssembler.html` or `AmysCVAssemblerPro.html` in your browser
2. Load an assembly file (drag & drop or file selector)
3. Enable optimizer if desired (⚡ Optimize Code checkbox)
4. Click Compile and download your ColecoVision ROM
5. Test in BlueMSX or openMSX emulator

For complete examples and usage, see [README.md](README.md).

---

**Ready to build ColecoVision games! 🎮**