# Amy's ColecoVision Assembler

A powerful web-based Z80 assembler specifically designed for ColecoVision game development. Build retro games directly in your browser with no installation required!

## 🎮 What is This Tool?

Amy's ColecoVision Assembler is a complete Z80 development environment that runs entirely in your web browser. It features:

- **Browser-Based** - No installation, no setup, works offline
- **Two Versions** - Standard (single-file) and Pro (multi-module projects)
- **Modern UI** - Syntax highlighting, responsive design, drag & drop
- **ColecoVision Optimized** - Boot screen emulation, proper ROM headers
- **Cross-Platform** - Works on Windows, Mac, Linux, and mobile devices

## 🚀 Quick Start

1. Open either HTML file in any modern web browser
2. Drag and drop your .asm file onto the window
3. Click **Compile**
4. Click **Download** to get your ColecoVision ROM

## 📦 Files

### Main Applications
- **AmysCVAssembler.html** - Standard version (single-file assembly)
- **AmysCVAssemblerPro.html** - Pro version (multi-module linking, libraries)
- **index.html** - Version selector page

### Features Comparison

| Feature | Standard | Pro |
|---------|----------|-----|
| **Assembly** |
| Single-file assembly | ✅ | ✅ |
| Z80 instruction set | ✅ | ✅ |
| INCLUDE directive | ✅ | ✅ |
| Macros (MACRO/ENDM) | ✅ | ✅ |
| Conditional assembly (IF/IFDEF) | ✅ | ✅ |
| **Directives** |
| TIMES directive (repeat) | ✅ | ✅ |
| ALIGN directive (padding) | ✅ | ✅ |
| Expression operators ($, HIGH, LOW, <, >) | ✅ | ✅ |
| **Output** |
| .COL ROM files | ✅ | ✅ |
| Symbol files (.sym) | ✅ | ✅ |
| Assembly listing (.lst) | ❌ | ✅ |
| **Advanced** |
| Multi-module linking | ❌ | ✅ |
| .REL object files | ❌ | ✅ |
| .LIB libraries | ❌ | ✅ |
| PUBLIC/EXTERN symbols | ❌ | ✅ |
| **Emulation** |
| Boot screen preview | ✅ | ✅ |

## 📝 Example Code

### Complete Working Example: 7 Moving Sprites

This complete example displays 7 sprites with collision detection and movement. Copy-paste ready!

```assembly
; Colecovision - Sprites Demo
; by Daniel Bienvenu, 2010

NBR_SPRITES: equ 7

fname "7spritesmoving.rom"
cpu Z80
org $8000
dw $aa55,$7100,$7000,0,0,Start
dw 0,0,0,0,0,0,0,0,0,0
ret

Nmi:
    ; Display Sprite(s)
    ld a,NBR_SPRITES
    call $1fc4              ; WR_SPR_NM_TBL
    ld a,$d0
    out ($be),a

    ; Update Sprites position
    ld de,($8002)
    ld hl,$7180
    ld b,NBR_SPRITES
UpdateSpritesCoor:
    ld a,160
    call AddfromHLinDE
    ld a,216
    call AddfromHLinDE
    inc de
    inc de
    djnz UpdateSpritesCoor

    ; Get Video Status (collision detection)
    call $1fdc              ; READ_REGISTER
    bit 6,a
    jr z,DoNothing
    and $1f                 ; keep only 5bits = sprite#
    ld e,a
    ld d,0
    ld hl,($8004)
    push hl
    add hl,de
    ld c,(hl)               ; Get corresponding Sprite entry
    pop hl
    ld a,NBR_SPRITES
    ld b,a
reordering1:
    ld (hl),c
    inc hl
    inc c
    cp c
    jr nz,reordering2
    ld c,0
reordering2:
    djnz reordering1
DoNothing:
    retn

; Apply movement incrementation and bounce effect
AddfromHLinDE:
    push bc
    ld b,a
    ld c,(hl)
    ld a,(de)
    add a,c
    ; if new position is lower than 24 or higher than max then bounce
    cp 24
    jr c,bounce
    cp b
    jr nc,bounce
    jr endbounce
bounce:
    ld a,c
    neg
    ld (hl),a
    ld c,a
    ld a,(de)
    add a,c
endbounce:
    ld (de),a
    inc hl
    inc de
    pop bc
    ret

Start:
    call $1f85              ; MODE_1
    call $1fd6              ; TURN_OFF_SOUND
    ; Clear VRAM
    ld hl,0
    ld de,$4000
    xor a
    call $1f82              ; FILL_VRAM
    ; Load Sprite Pattern
    ld de,$3800
    ld hl,HappyAlienBugFace
    ld bc,32
    call $1fdf              ; WRITE_VRAM
    ; Init. Sprites Order
    ld a,NBR_SPRITES
    call $1fc1              ; INIT_SPR_ORDER
    ld de,($8002)
    ld hl,SprAttrib
    ld bc,NBR_SPRITES*4
    ldir
    ld de,$7180
    ld bc,NBR_SPRITES*2
    ldir
    ; Turn On Display + Enable NMI
    ld bc,$01e2
    call $1fd9              ; WRITE_REGISTER
TheEnd:
    jp TheEnd

SprAttrib:
    db 82, 24,0,13          ; Y=82, X= 24, Pattern#0, Color=13
    db 84, 56,0, 8          ; Y=84, X= 56, Pattern#0, Color=8
    db 86, 88,0, 9          ; Y=86, X= 88, Pattern#0, Color=9
    db 88,120,0,10          ; Y=88, X=120, Pattern#0, Color=10
    db 90,152,0, 3          ; Y=90, X=152, Pattern#0, Color=3
    db 92,184,0, 7          ; Y=92, X=184, Pattern#0, Color=7
    db 94,216,0, 4          ; Y=94, X=216, Pattern#0, Color=4

SprMovements:
    db 0,0
    db 1,0
    db 0,1
    db -1,0
    db 0,-1
    db 1,1
    db -1,-1

HappyAlienBugFace:
    db %00011000
    db %01100100
    db %11000011
    db %00001111
    db %00011001
    db %00110000
    db %00110110
    db %01111111
    db %01111111
    db %01111111
    db %01110000
    db %00110000
    db %00111000
    db %00011110
    db %00001111
    db %00000011

    db %00001100
    db %00010010
    db %11100011
    db %11111001
    db %11001100
    db %10000110
    db %10110110
    db %11111111
    db %11111111
    db %11111111
    db %00000111
    db %00000110
    db %00001110
    db %00111100
    db %11111000
    db %11100000
```

This example demonstrates:
- **ColecoVision BIOS calls** - Standard ROM initialization
- **Sprites** - Loading and displaying sprite graphics
- **Animation** - Moving sprites with different velocities
- **Collision detection** - Sprite overlap detection with reordering
- **Bounce effect** - Screen boundary detection and direction reversal
- **NMI interrupt** - Vertical blank interrupt handling

### Hello World Example

Simple text display demonstrating ColecoVision BIOS calls and NMI interrupts.

```assembly
; COLECOVISION - HELLO WORLD!
; By Daniel Bienvenu, 2010

; BIOS ENTRY POINTS
CALC_OFFSET: equ $08c0
LOAD_ASCII: equ $1f7f
FILL_VRAM: equ $1f82
MODE_1: equ $1f85
TURN_OFF_SOUND: equ $1fd6
WRITE_REGISTER: equ $1fd9
READ_REGISTER: equ $1fdc
WRITE_VRAM: equ $1fdf

; VRAM TABLES
VRAM_NAME: equ $1800
VRAM_COLOR: equ $2000

fname "hello.rom"
cpu Z80
org $8000

; ROM HEADER
db $aa,$55              ; Signature
dw 0,0,0,0
dw Start

rst_8:  reti : nop
rst_10: reti : nop
rst_18: reti : nop
rst_20: reti : nop
rst_28: reti : nop
rst_30: reti : nop
rst_38: reti : nop
jp Nmi

db "HELLO WORLD!/PRINT ON SCREEN/2010"

Start:
    im 1

    ; Clear video memory
    ld hl,$0000
    ld de,$4000
    xor a
    call FILL_VRAM

    ; Initialize screen mode 1
    call MODE_1
    call TURN_OFF_SOUND

    ; Load default font
    call LOAD_ASCII

    ; Set color (white on black)
    ld hl,VRAM_COLOR
    ld de,32
    ld a,$f0            ; White foreground, black background
    call FILL_VRAM

    ; Print "HELLO WORLD!" centered
    ld de,VRAM_NAME+10  ; Center position
    ld hl,HelloWorld
    ld bc,12            ; Character count
    call WRITE_VRAM

    ; Turn on screen
    ld bc,$01c2
    call WRITE_REGISTER

TheEnd:
    jp TheEnd

HelloWorld:
    db "HELLO WORLD!"

Nmi:
    ; Random color effect
    ld hl,VRAM_COLOR
    ld de,32
    ld a,r              ; Random value from refresh register
    and $f0             ; Keep background black
    call FILL_VRAM

    call READ_REGISTER  ; Required for NMI
    retn
```

This example demonstrates:
- **Text display** - Using BIOS to print on screen
- **BIOS entry points** - Standard ColecoVision functions
- **NMI interrupt** - Changing colors randomly during vertical blank
- **ROM header** - Proper RST vectors setup

### TIMES and ALIGN Directives

Both Standard and Pro versions support gasm80-compatible directives:

**TIMES** - Repeat instruction or data N times:
- `TIMES 256 DB 0x00` - Fill 256 bytes with zeros
- `TIMES 8 NOP` - Insert 8 NOP instructions
- `TIMES BUFFER_SIZE DB 0xFF` - Works with constants

**ALIGN** - Align to boundary (pads with 0xFF):
- `ALIGN 128` - Pad to next 128-byte boundary
- `ALIGN 16` - Pad to next 16-byte boundary
- Useful for VDP table alignment requirements

### Pro Version: Multi-Module Example

**main.asm:**
```assembly
    .globl start
    .extern multiply        ; Import from math module

start:
    ld bc, 10
    ld de, 20
    call multiply           ; Result in HL
    halt
```

**math.asm:**
```assembly
    .globl multiply         ; Export this function

multiply:
    ; Multiply BC * DE, result in HL
    ld hl, 0
mult_loop:
    add hl, bc
    dec de
    ld a, d
    or e
    jr nz, mult_loop
    ret
```

Compile both to .REL, then link them together in the Pro version.

## 🔧 Supported Syntax

### Number Formats
- **Hexadecimal**: `$1234`, `0x1234`, `1234h`
- **Binary**: `%10101010`, `10101010b`
- **Octal**: `@777`
- **Decimal**: `12345`

### Expressions
- **$ operator** - Current program counter: `jp $ + 5`
- **HIGH()** - High byte: `ld a, HIGH($1234)` → `$12`
- **LOW()** - Low byte: `ld a, LOW($1234)` → `$34`
- **< operator** - Low byte: `ld a, <$1234` → `$34`
- **> operator** - High byte: `ld a, >$1234` → `$12`

### Directives
- **ORG** - Set origin address
- **DB/DEFB** - Define byte(s)
- **DW/DEFW** - Define word(s)
- **DS/DEFS** - Define space
- **EQU** - Define constant
- **TIMES** - Repeat instruction/data
- **ALIGN** - Align to boundary
- **INCLUDE** - Include another file
- **MACRO/ENDM** - Define macro
- **IF/IFDEF/ELSE/ENDIF** - Conditional assembly

## 🛠️ Project Structure

This repository includes:
- **examples/** - Working assembly examples
- **z80/** - Development workspace *(work in progress)*
- **dev/** - Development tools, tests, backups *(not for GitHub)*
- **docs/** - Complete documentation *(not for GitHub)*

## 🎯 Why Choose This Assembler?

### vs TASM / ZMAC
- ✅ No installation required (browser-based)
- ✅ Works on any OS (Windows, Mac, Linux)
- ✅ Modern UI with syntax highlighting
- ✅ ColecoVision-specific features (boot screen preview)

### vs gasm80
- ✅ TIMES and ALIGN directives (gasm80-compatible)
- ✅ Multi-file projects with INCLUDE
- ✅ Macros and conditional assembly
- ✅ Pro version: Multi-module linking

### vs Command-Line Assemblers
- ✅ Instant feedback (no terminal commands)
- ✅ Built-in text editor with highlighting
- ✅ Visual boot screen preview
- ✅ Works offline after first load

## 📖 Documentation

For complete documentation and technical details, see:
- [Full Documentation](docs/FULL_README.md)
- [Changelog](docs/CHANGELOG.md)
- [Bug Fixes](docs/BUGFIX_TIMES_EQU.md)

## 📄 License

Created by Amy Purple
For ColecoVision game development

---

**Ready to create ColecoVision games? Open either HTML file and start coding! 🎮**
