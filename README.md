# Amy's ColecoVision Assembler

A powerful web-based Z80 assembler specifically designed for ColecoVision game development. Build retro games directly in your browser with no installation required!

## 🎮 What is This Tool?

Amy's ColecoVision Assembler is a complete Z80 development environment that runs entirely in your web browser. It features:

- **Multi-syntax Z80 Assembler** - Supports zmac, TASM, MACRO-80, MRAS, Intel, and Motorola assembly styles
- **ColecoVision ROM Generation** - Creates ready-to-run .col files for ColecoVision emulators and hardware
- **Real-time Symbol Table** - View all labels, constants, and addresses as you assemble
- **Authentic Boot Screen Emulation** - Preview your game's title screen with accurate TMS9918A rendering
- **Project Management** - Handle multiple files with includes, macros, and conditional assembly
- **Syntax Highlighting** - CodeMirror-powered editor with Z80 instruction highlighting

## 📦 Two Versions Available

### AmysCVAssembler.html (Standard Version)

**Best for:** Most users, straightforward projects, learning Z80 assembly

**Features:**
- ✅ Full Z80 instruction set with all syntaxes (zmac, TASM, etc.)
- ✅ Binary output (.col ROM files)
- ✅ Multi-file projects with INCLUDE support
- ✅ Macros and conditional assembly (IF/ELSE/ENDIF)
- ✅ Symbol table export
- ✅ ColecoVision boot screen emulation
- ✅ File management with download/rename/delete icons
- ✅ .asm, .z80, .s file support
- ✅ Auto-named output files (build_filename.col)

**File Size:** ~140 KB

### AmysCVAssemblerPro.html (Pro Version)

**Best for:** Advanced developers, multi-module projects, library development

**Features:** Everything in Standard version, PLUS:
- ✅ **Relocatable Object Files** (.REL format) - LINK-80 and Extended formats
- ✅ **Modular Linking** - Link multiple .REL files into a single binary
- ✅ **Library Support** (.LIB files) - Only pulls in functions you actually use
- ✅ **Smart Linking** - Automatic dead code elimination
- ✅ **Module Inspector** - View symbols, relocations, and dependencies in .REL files
- ✅ **Public/External Symbols** - Share functions between modules
- ✅ **Selective Compilation** - Assemble to .REL or directly to .COL
- ✅ **Project Manifest** - Track main files and build configurations

**File Size:** ~260 KB

## 🚀 Getting Started

### Quick Start (5 seconds)

1. Open either HTML file in any modern web browser (Chrome, Firefox, Edge, Safari)
2. Drag and drop your .asm, .z80, or .s file onto the window
3. Click **Compile**
4. Click **Download** to get your ColecoVision ROM!

### Your First ColecoVision ROM

```assembly
; hello.asm - Minimal ColecoVision program
.org $8000

; ColecoVision ROM header
.dw $AA55, $7500, $0000, $0000, $0000, $0000, $0000

; Game title (shown on boot screen)
.db "2024 YOUR NAME HERE"
.db "     HELLO WORLD    "

; Code starts here
start:
    di                  ; Disable interrupts
    ld sp, $7400        ; Set stack pointer

loop:
    jr loop             ; Infinite loop

.end
```

Save this as `hello.asm`, drag it into the assembler, compile, and you'll get `build_hello.col` ready to run in any ColecoVision emulator!

## 📖 Supported Assembly Syntaxes

### TASM Style (NEW!)
```assembly
.org $8000              ; Dot-prefixed directives
.dw $AA55               ; Define word
.db "Hello"             ; Define bytes
TABLE .equ $7500        ; Label before directive
.end                    ; End of assembly
```

### zmac Style
```assembly
org 8000h               ; No dot prefix
dw 0AA55h               ; Hex with 'h' suffix
db "Hello"              ; Define bytes
TABLE equ 7500h         ; Standard EQU
```

### Intel/MACRO-80 Style
```assembly
        ORG     8000H
        DW      0AA55H
        DB      'Hello'
TABLE   EQU     7500H
```

All styles work seamlessly - use what you're comfortable with!

## 🎯 Key Features Explained

### File Extensions
- **.asm** - Standard assembly source
- **.z80** - TASM-style assembly (NEW! Handles binary ROM headers correctly)
- **.s** - SDCC-style assembly
- **.rel** - Relocatable object files (Pro version)
- **.lib** - Static libraries (Pro version)

### Hex Number Formats
All of these work for the value 0x702B (28715):
- `$702B` - TASM/zmac style (dollar sign prefix)
- `0x702B` - C-style (0x prefix)
- `702Bh` - Intel style (h suffix)
- Expressions: `$702B+10` evaluates to 28725

### Output Filenames
Both versions now generate smart output names:
- Input: `game.asm` → Output: `build_game.col`
- Input: `ddt3.z80` → Output: `build_ddt3.col`
- No more generic "output.col"!

### Project Files Panel
Each file in your project shows three icons:
- **💾 (Download icon)** - Download this specific file
- **✏️ (Rename icon)** - Rename this file
- **🗑️ (Delete icon)** - Remove file from project (with confirmation)

## 🔧 Pro Version: Advanced Workflow

### Creating a Multi-Module Project

**Step 1:** Create your modules with public symbols

```assembly
; math.asm
        .globl  multiply    ; Export this function
        .area   _CODE

multiply:                   ; C = A * B
        ld      c, 0
loop:   or      a
        ret     z
        add     c, b
        dec     a
        jr      loop
```

**Step 2:** Use symbols in your main program

```assembly
; main.asm
        .globl  multiply    ; Import external function
        .area   _CODE

start:  ld      a, 5
        ld      b, 7
        call    multiply    ; C = 5 * 7 = 35
        ; ... rest of code
```

**Step 3:** Assemble and link

1. Load both files into the project
2. Select output mode: **LINK-80 .REL** or **Extended .REL**
3. Compile both files (creates .REL files automatically)
4. **Switch output mode to Binary (.col)**
5. Click **Link Modules** button
6. Download your linked binary!

### Using Libraries

If you have a `.lib` file (like the ColecoVision development libraries):

1. Drop your `.lib` file into the project
2. Compile your main program to `.REL`
3. Switch to Binary output mode
4. Click **Link Modules**
5. Only the functions you actually call are included (dead code elimination)!

## 📊 Symbol Table

After compilation, switch to the **Symbols** tab to see:

- All labels with their addresses
- Constants (EQU/EVAL values)
- File and line number where each symbol is defined
- Size of data blocks
- Easy reference for debugging

Export the symbol table as JSON for use with debuggers or documentation tools.

## 🎨 Boot Screen Emulation

Click **Test ColecoVision Screen** after compiling to see your game's title screen rendered exactly as it appears on real hardware:

- Authentic TMS9918A video chip rendering
- ColecoVision logo animation
- Your game title displayed on-screen
- Pixel-perfect accuracy
- DINA 2-in-1 mode also supported

## 🛠️ Compatibility

### Browser Support
- ✅ Chrome/Edge (recommended)
- ✅ Firefox
- ✅ Safari
- ✅ Opera
- ⚠️ IE11 not supported

### Emulator Compatibility
Output ROMs work with:
- BlueMSX
- ColEm
- CoolCV
- MAME/MESS
- Real ColecoVision hardware (via flash cartridge)

## 📝 Tips & Tricks

### Fast Development Cycle
1. Keep the assembler open in your browser
2. Edit your .asm file in your favorite text editor
3. Drag and drop the file again to reload
4. Hit Compile - no need to clear the project!

### Debugging Assembly Errors
The assembler performs 3 passes:
- **Pass 1:** Expands macros and processes conditionals
- **Pass 2:** Builds symbol table (resolves forward references)
- **Pass 3:** Generates binary code

Errors show which pass failed and the exact line number.

### Include Files
```assembly
.include "macros.inc"    ; Load common macros
.include "sprites.asm"   ; Include sprite data
```

All included files must be in the project. Just drop them in!

### Macros
```assembly
VDPWRITE    .macro  addr, value
            ld      a, \1
            out     ($BE), a
            ld      a, \2
            out     ($BE), a
            .endm

; Use it:
            VDPWRITE  $00, $40  ; Expands to the 4 instructions above
```

## 🐛 Known Limitations

### Standard Version
- Single binary output only (no modular linking)
- No library support
- All code must link into one contiguous ROM

### Pro Version
- .REL format has 6-character symbol limit in LINK-80 mode
- Use Extended .REL mode for unlimited symbol lengths
- Linking requires switching output mode to Binary

## 📚 Additional Resources

### Learning Z80 Assembly
- [Z80 Instruction Set](http://z80-heaven.wikidot.com/instructions-set)
- [ColecoVision Programming Guide](https://atarihq.com/danb/files/CV-Tech.txt)

### ColecoVision Development
- [ColecoVision BIOS Calls](http://www.atarihq.com/danb/files/CV-BIOS.txt)
- [VDP Programming](http://www.smspower.org/Development/VDPRegisters)

### Assembler Syntax
- [zmac Documentation](https://github.com/ocoleman/zmac)
- [TASM Documentation](http://www.ticalc.org/archives/files/fileinfo/250/25051.html)

## 🎯 Version History

### Current Release
- ✅ Added TASM syntax support (.org, .dw, .db, etc.)
- ✅ Added .z80 file extension support
- ✅ Fixed hex number parsing in expressions ($702b+10)
- ✅ Added END directive
- ✅ Added file download/rename/delete icons
- ✅ Smart output filenames (build_filename.col)
- ✅ Pro: Relocatable object file support (.REL)
- ✅ Pro: Module linking with dead code elimination
- ✅ Pro: Library support (.LIB files)

## 🤝 Credits

**Created by:** Amy
**Based on:** zmac assembler syntax and Z80 instruction set
**TMS9918A Emulation:** Authentic ColecoVision video chip rendering
**Editor:** CodeMirror text editor
**Compression:** pako (zlib), JSZip for archive support

## 📄 License

This tool is provided as-is for ColecoVision homebrew development. Feel free to use it for your retro gaming projects!

---

**Ready to create your ColecoVision masterpiece? Open either HTML file and start coding! 🎮**
