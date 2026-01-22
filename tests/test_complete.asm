;===============================================================================
; test_complete.asm - Comprehensive Z80 Assembler Test Suite
;===============================================================================
; This file tests EVERY feature of Amy's CV Assembler:
; - All Z80 opcodes (main, CB, ED, DD, FD prefixes)
; - All addressing modes
; - All number formats
; - All directives and their variations
; - All expression operators
; - Include directive
; - Macros, conditionals, structures
;
; Assemble this file and compare output to test_complete.bin
; If they match byte-for-byte, the assembler is working correctly.
;===============================================================================

;===============================================================================
; SECTION 1: ORIGIN AND INCLUDE TEST
;===============================================================================
        ORG $8000

; Test INCLUDE directive
        INCLUDE "test_complete_inc.asm"

;===============================================================================
; SECTION 2: NUMBER FORMAT TESTS
;===============================================================================
section_numbers:

; All ways to write the same value (255)
num_decimal:        DB 255              ; Decimal
num_hex_dollar:     DB $FF              ; Hex with $
num_hex_0x:         DB 0xFF             ; Hex with 0x
num_hex_h:          DB 0FFh             ; Hex with h suffix
num_binary_pct:     DB %11111111        ; Binary with %
num_binary_b:       DB 11111111b        ; Binary with b suffix

; Octal format
num_octal:          DB @377             ; Octal (255 decimal)

; Character constants
num_char_single:    DB 'A'              ; Single char = 65
num_char_escape:    DB '\n'             ; Newline = 10
num_char_zero:      DB '0'              ; Zero char = 48

; Negative numbers
num_negative:       DB -1               ; Should be $FF
num_neg_expr:       DB -128             ; Should be $80

; 16-bit values in different formats
word_decimal:       DW 65535            ; Decimal
word_hex_dollar:    DW $ABCD            ; Hex with $
word_hex_0x:        DW 0x1234           ; Hex with 0x
word_hex_h:         DW 5678h            ; Hex with h suffix

;===============================================================================
; SECTION 3: EXPRESSION AND OPERATOR TESTS
;===============================================================================
section_expressions:

; Arithmetic operators
expr_add:           DB 10 + 5           ; = 15
expr_sub:           DB 20 - 5           ; = 15
expr_mul:           DB 3 * 5            ; = 15
expr_div:           DB 30 / 2           ; = 15
expr_mod:           DB 17 % 5           ; = 2
expr_neg:           DB -(5 - 10)        ; = 5

; Bitwise operators
expr_and:           DB $F0 & $0F        ; = $00
expr_or:            DB $F0 | $0F        ; = $FF
expr_xor:           DB $FF ^ $AA        ; = $55
expr_not:           DB ~$F0 & $FF       ; = $0F
expr_shl:           DB 1 << 4           ; = 16
expr_shr:           DB 64 >> 2          ; = 16

; HIGH/LOW operators
expr_high:          DB HIGH($1234)      ; = $12
expr_low:           DB LOW($1234)       ; = $34
expr_high_alt:      DB >$5678           ; = $56
expr_low_alt:       DB <$5678           ; = $78

; Complex expressions
expr_complex1:      DB (10 + 5) * 2     ; = 30
expr_complex2:      DB HIGH($AABB) | LOW($CCDD)  ; = $AA | $DD = $FF
expr_complex3:      DW $1000 + $234     ; = $1234

; Program counter ($) usage
pc_current:         DW $                ; Current address
pc_offset:          DW $ + 10           ; Current + 10
pc_diff:
        nop
        nop
        nop
pc_diff_end:
pc_diff_val:        DB pc_diff_end - pc_diff    ; = 3

;===============================================================================
; SECTION 4: EQU AND SET TESTS
;===============================================================================
section_equ:

; Basic EQU
CONST_BYTE          EQU $42
CONST_WORD          EQU $1234
CONST_EXPR          EQU 100 + 50
CONST_LABEL         EQU section_equ

; EQU with various formats
CONST_DEC           EQU 255
CONST_HEX           EQU $FF
CONST_BIN           EQU %10101010
CONST_BIN2          EQU 11001100b
CONST_OCT           EQU @177
CONST_OCT2          EQU @377
CONST_CHAR          EQU 'Z'

; Verify number format parsing
        ASSERT CONST_DEC == 255, "Decimal constant failed"
        ASSERT CONST_HEX == 255, "Hex constant failed"
        ASSERT CONST_BIN == 170, "Binary % format failed (expected 170)"
        ASSERT CONST_BIN2 == 204, "Binary b suffix failed (expected 204)"
        ASSERT CONST_OCT == 127, "Octal @ format failed (expected 127)"
        ASSERT CONST_OCT2 == 255, "Octal @377 failed (expected 255)"
        ASSERT CONST_CHAR == 90, "Character constant failed (expected 90 = 'Z')"

; Using EQU constants
equ_test1:          DB CONST_BYTE       ; = $42
equ_test2:          DW CONST_WORD       ; = $1234
equ_test3:          DB CONST_EXPR       ; = 150
equ_test4:          DW CONST_LABEL      ; = address of section_equ

; EQU with expressions using other EQUs
CONST_DERIVED       EQU CONST_BYTE + CONST_DEC
equ_test5:          DW CONST_DERIVED

;===============================================================================
; SECTION 5: LABEL TESTS
;===============================================================================
section_labels:

; Basic labels
label_basic:
        nop

; Label with colon
label_colon:
        nop

; Label at start of line (no indent)
label_noindent:
        nop

; Local labels (with dot prefix)
label_parent1:
        nop
.local1:
        nop
.local2:
        jr .local1

label_parent2:
        nop
.local1:            ; Same name, different scope
        nop
        jr .local1

; Label arithmetic
label_arith_start:
        DB 1, 2, 3, 4, 5
label_arith_end:
label_arith_size:   DB label_arith_end - label_arith_start  ; = 5

; Forward reference test
        jp label_forward
        nop
        nop
label_forward:
        nop

;===============================================================================
; SECTION 6: DATA DIRECTIVE TESTS
;===============================================================================
section_data:

;---------------------------------------
; DB / DEFB / BYTE variants
;---------------------------------------
data_db_single:     DB $12
data_db_multi:      DB $11, $22, $33, $44, $55
data_db_expr:       DB 10 + 20, $FF & $0F
data_db_char:       DB 'A', 'B', 'C'
data_db_string:     DB "Hello"
data_db_mixed:      DB "Hi", 0, $FF

data_defb_test:     DEFB $AA, $BB, $CC
data_byte_test:     BYTE $DD, $EE

;---------------------------------------
; DW / DEFW / WORD variants
;---------------------------------------
data_dw_single:     DW $1234
data_dw_multi:      DW $1111, $2222, $3333
data_dw_expr:       DW $1000 + $234
data_dw_label:      DW section_data
data_dw_highlow:    DW HIGH($AABB) * 256 + LOW($CCDD)

data_defw_test:     DEFW $5555, $6666
data_word_test:     WORD $7777, $8888

;---------------------------------------
; DS / DEFS / BLOCK variants
; DS n, fill - fills with byte value (allowed in ROM)
; DS n - without fill value, only in BSS section
;---------------------------------------
data_ds_zeros:      DS 5, $00           ; 5 bytes of $00
data_ds_ffs:        DS 5, $FF           ; 5 bytes of $FF
data_defs_test:     DEFS 3, 0           ; 3 bytes of $00 (DEFS alias)
data_block_test:    BLOCK 4, $AA        ; 4 bytes of $AA

;---------------------------------------
; String directives
;---------------------------------------
data_defm:          DEFM "DEFM TEST"
data_ascii:         ASCII "ASCII"
data_text:          TEXT "TEXT"
data_asciiz:        DB "NULL TERM", 0
data_asciz:         DEFM "ASCIZ", 0

;---------------------------------------
; TIMES directive
;---------------------------------------
data_times_db:      TIMES 8 DB $CC      ; 8 bytes of $CC
data_times_dw:      TIMES 4 DW $DDDD    ; 4 words
data_times_nop:     TIMES 5 NOP         ; 5 NOPs
data_times_expr:    TIMES 2+1 DB $EE    ; 3 bytes

;===============================================================================
; SECTION 7: ALIGN DIRECTIVE TESTS
;===============================================================================
section_align:
        DB $FF                          ; Ensure misalignment
        ALIGN 4
align_4:
        DB $44                          ; Should be at address divisible by 4

        DB $FF, $FF                     ; Misalign again
        ALIGN 16
align_16:
        DB $16                          ; Should be at address divisible by 16

        ALIGN 256
align_256:
        DB $00                          ; Should be at address divisible by 256

;===============================================================================
; SECTION 8: CONDITIONAL ASSEMBLY TESTS
;===============================================================================
section_conditionals:

; Define test constants
COND_TRUE           EQU 1
COND_FALSE          EQU 0
COND_VALUE          EQU 42

;---------------------------------------
; IF / ELSE / ENDIF
;---------------------------------------
        IF COND_TRUE
cond_if_true:       DB $11              ; Should be included
        ELSE
cond_if_false:      DB $00              ; Should NOT be included
        ENDIF

        IF COND_FALSE
cond_if2_true:      DB $00              ; Should NOT be included
        ELSE
cond_if2_false:     DB $22              ; Should be included
        ENDIF

;---------------------------------------
; IF / ELIF / ELSE / ENDIF
;---------------------------------------
        IF COND_VALUE == 10
cond_elif_10:       DB $10
        ELIF COND_VALUE == 42
cond_elif_42:       DB $42              ; Should be included
        ELIF COND_VALUE == 50
cond_elif_50:       DB $50
        ELSE
cond_elif_else:     DB $00
        ENDIF

;---------------------------------------
; IFDEF / IFNDEF
;---------------------------------------
        IFDEF COND_TRUE
cond_ifdef:         DB $33              ; Should be included (COND_TRUE is defined)
        ENDIF

        IFNDEF UNDEFINED_SYMBOL
cond_ifndef:        DB $44              ; Should be included (UNDEFINED_SYMBOL not defined)
        ENDIF

        IFDEF UNDEFINED_SYMBOL
cond_ifdef_no:      DB $00              ; Should NOT be included
        ELSE
cond_ifdef_else:    DB $55              ; Should be included
        ENDIF

;---------------------------------------
; Nested conditionals
;---------------------------------------
        IF COND_TRUE
            IF COND_VALUE > 40
cond_nested:        DB $66              ; Should be included
            ENDIF
        ENDIF

;---------------------------------------
; Comparison operators in conditionals
;---------------------------------------
        IF COND_VALUE == 42
cond_eq:            DB $01              ; Equal
        ENDIF

        IF COND_VALUE != 0
cond_ne:            DB $02              ; Not equal
        ENDIF

        IF COND_VALUE > 40
cond_gt:            DB $03              ; Greater than
        ENDIF

        IF COND_VALUE >= 42
cond_ge:            DB $04              ; Greater or equal
        ENDIF

        IF COND_VALUE < 50
cond_lt:            DB $05              ; Less than
        ENDIF

        IF COND_VALUE <= 42
cond_le:            DB $06              ; Less or equal
        ENDIF

;===============================================================================
; SECTION 9: MACRO TESTS
;===============================================================================
section_macros:

;---------------------------------------
; Simple macro (no parameters)
;---------------------------------------
        MACRO NOP5
            nop
            nop
            nop
            nop
            nop
        ENDM

macro_nop5:
        NOP5

;---------------------------------------
; Macro with parameters
;---------------------------------------
        MACRO LOAD_A_IMM value
            ld a, value
        ENDM

macro_load:
        LOAD_A_IMM $42

;---------------------------------------
; Macro with multiple parameters
;---------------------------------------
        MACRO LOAD_PAIR16 reg, val
            ld reg, val
        ENDM

macro_pair:
        LOAD_PAIR16 hl, $1234
        LOAD_PAIR16 de, $5678
        LOAD_PAIR16 bc, $9ABC

;---------------------------------------
; Macro with expression parameter
;---------------------------------------
        MACRO ADD_CONST base, offset
            ld a, base + offset
        ENDM

macro_expr:
        ADD_CONST $10, $05

;---------------------------------------
; Macro with local labels
;---------------------------------------
        MACRO DELAY_LOOP count
            ld b, count
.loop:
            djnz .loop
        ENDM

macro_delay:
        DELAY_LOOP 10
        DELAY_LOOP 20

;---------------------------------------
; Use macros from included file
;---------------------------------------
macro_inc1:
        INC_NOP3
macro_inc2:
        INC_LOAD_A $99
macro_inc3:
        INC_LOAD_PAIR bc, $AABB

;===============================================================================
; SECTION 10: STRUCTURE TESTS
;===============================================================================
section_structs:

;---------------------------------------
; Define structure
;---------------------------------------
        STRUCT PlayerData
            player_x        DB 1
            player_y        DB 1
            player_health   DW 1
            player_score    DW 1
            player_name     DS 8, 0             ; 8 bytes filled with 0
        ENDSTRUCT

;---------------------------------------
; Structure instances
;---------------------------------------
player1:
        PlayerData

player2:
        PlayerData

;---------------------------------------
; Structure size constant
;---------------------------------------
struct_size:        DB SIZEOF_PlayerData

;---------------------------------------
; Use structure from included file
;---------------------------------------
inc_struct_instance:
        IncludedStruct
inc_struct_size:    DB SIZEOF_IncludedStruct

;===============================================================================
; SECTION 11: Z80 OPCODE TESTS - MAIN INSTRUCTIONS (NO PREFIX)
;===============================================================================
section_opcodes_main:

;---------------------------------------
; 8-bit Load instructions
;---------------------------------------
op_ld_r_r:
        ld a, a             ; 7F
        ld a, b             ; 78
        ld a, c             ; 79
        ld a, d             ; 7A
        ld a, e             ; 7B
        ld a, h             ; 7C
        ld a, l             ; 7D
        ld b, a             ; 47
        ld b, b             ; 40
        ld b, c             ; 41
        ld b, d             ; 42
        ld b, e             ; 43
        ld b, h             ; 44
        ld b, l             ; 45
        ld c, a             ; 4F
        ld c, b             ; 48
        ld c, c             ; 49
        ld c, d             ; 4A
        ld c, e             ; 4B
        ld c, h             ; 4C
        ld c, l             ; 4D
        ld d, a             ; 57
        ld d, b             ; 50
        ld d, c             ; 51
        ld d, d             ; 52
        ld d, e             ; 53
        ld d, h             ; 54
        ld d, l             ; 55
        ld e, a             ; 5F
        ld e, b             ; 58
        ld e, c             ; 59
        ld e, d             ; 5A
        ld e, e             ; 5B
        ld e, h             ; 5C
        ld e, l             ; 5D
        ld h, a             ; 67
        ld h, b             ; 60
        ld h, c             ; 61
        ld h, d             ; 62
        ld h, e             ; 63
        ld h, h             ; 64
        ld h, l             ; 65
        ld l, a             ; 6F
        ld l, b             ; 68
        ld l, c             ; 69
        ld l, d             ; 6A
        ld l, e             ; 6B
        ld l, h             ; 6C
        ld l, l             ; 6D

op_ld_r_n:
        ld a, $12           ; 3E 12
        ld b, $34           ; 06 34
        ld c, $56           ; 0E 56
        ld d, $78           ; 16 78
        ld e, $9A           ; 1E 9A
        ld h, $BC           ; 26 BC
        ld l, $DE           ; 2E DE

op_ld_r_hl:
        ld a, (hl)          ; 7E
        ld b, (hl)          ; 46
        ld c, (hl)          ; 4E
        ld d, (hl)          ; 56
        ld e, (hl)          ; 5E
        ld h, (hl)          ; 66
        ld l, (hl)          ; 6E

op_ld_hl_r:
        ld (hl), a          ; 77
        ld (hl), b          ; 70
        ld (hl), c          ; 71
        ld (hl), d          ; 72
        ld (hl), e          ; 73
        ld (hl), h          ; 74
        ld (hl), l          ; 75

op_ld_hl_n:
        ld (hl), $42        ; 36 42

op_ld_a_indirect:
        ld a, (bc)          ; 0A
        ld a, (de)          ; 1A
        ld (bc), a          ; 02
        ld (de), a          ; 12

op_ld_a_nn:
        ld a, ($1234)       ; 3A 34 12
        ld ($5678), a       ; 32 78 56

;---------------------------------------
; 16-bit Load instructions
;---------------------------------------
op_ld_rr_nn:
        ld bc, $1234        ; 01 34 12
        ld de, $5678        ; 11 78 56
        ld hl, $9ABC        ; 21 BC 9A
        ld sp, $DEF0        ; 31 F0 DE

op_ld_hl_nn_ind:
        ld hl, ($1234)      ; 2A 34 12
        ld ($5678), hl      ; 22 78 56

op_ld_sp_hl:
        ld sp, hl           ; F9

;---------------------------------------
; Stack operations
;---------------------------------------
op_push:
        push af             ; F5
        push bc             ; C5
        push de             ; D5
        push hl             ; E5

op_pop:
        pop af              ; F1
        pop bc              ; C1
        pop de              ; D1
        pop hl              ; E1

;---------------------------------------
; Exchange instructions
;---------------------------------------
op_ex:
        ex de, hl           ; EB
        ex af, af'          ; 08
        exx                 ; D9
        ex (sp), hl         ; E3

;---------------------------------------
; 8-bit Arithmetic/Logic
;---------------------------------------
op_add_a_r:
        add a, a            ; 87
        add a, b            ; 80
        add a, c            ; 81
        add a, d            ; 82
        add a, e            ; 83
        add a, h            ; 84
        add a, l            ; 85
        add a, (hl)         ; 86
        add a, $42          ; C6 42

op_adc_a_r:
        adc a, a            ; 8F
        adc a, b            ; 88
        adc a, c            ; 89
        adc a, d            ; 8A
        adc a, e            ; 8B
        adc a, h            ; 8C
        adc a, l            ; 8D
        adc a, (hl)         ; 8E
        adc a, $42          ; CE 42

op_sub_r:
        sub a               ; 97
        sub b               ; 90
        sub c               ; 91
        sub d               ; 92
        sub e               ; 93
        sub h               ; 94
        sub l               ; 95
        sub (hl)            ; 96
        sub $42             ; D6 42

op_sbc_a_r:
        sbc a, a            ; 9F
        sbc a, b            ; 98
        sbc a, c            ; 99
        sbc a, d            ; 9A
        sbc a, e            ; 9B
        sbc a, h            ; 9C
        sbc a, l            ; 9D
        sbc a, (hl)         ; 9E
        sbc a, $42          ; DE 42

op_and_r:
        and a               ; A7
        and b               ; A0
        and c               ; A1
        and d               ; A2
        and e               ; A3
        and h               ; A4
        and l               ; A5
        and (hl)            ; A6
        and $42             ; E6 42

op_or_r:
        or a                ; B7
        or b                ; B0
        or c                ; B1
        or d                ; B2
        or e                ; B3
        or h                ; B4
        or l                ; B5
        or (hl)             ; B6
        or $42              ; F6 42

op_xor_r:
        xor a               ; AF
        xor b               ; A8
        xor c               ; A9
        xor d               ; AA
        xor e               ; AB
        xor h               ; AC
        xor l               ; AD
        xor (hl)            ; AE
        xor $42             ; EE 42

op_cp_r:
        cp a                ; BF
        cp b                ; B8
        cp c                ; B9
        cp d                ; BA
        cp e                ; BB
        cp h                ; BC
        cp l                ; BD
        cp (hl)             ; BE
        cp $42              ; FE 42

op_inc_r:
        inc a               ; 3C
        inc b               ; 04
        inc c               ; 0C
        inc d               ; 14
        inc e               ; 1C
        inc h               ; 24
        inc l               ; 2C
        inc (hl)            ; 34

op_dec_r:
        dec a               ; 3D
        dec b               ; 05
        dec c               ; 0D
        dec d               ; 15
        dec e               ; 1D
        dec h               ; 25
        dec l               ; 2D
        dec (hl)            ; 35

;---------------------------------------
; 16-bit Arithmetic
;---------------------------------------
op_add_hl_rr:
        add hl, bc          ; 09
        add hl, de          ; 19
        add hl, hl          ; 29
        add hl, sp          ; 39

op_inc_rr:
        inc bc              ; 03
        inc de              ; 13
        inc hl              ; 23
        inc sp              ; 33

op_dec_rr:
        dec bc              ; 0B
        dec de              ; 1B
        dec hl              ; 2B
        dec sp              ; 3B

;---------------------------------------
; Rotate/Shift (accumulator)
;---------------------------------------
op_rot_a:
        rlca                ; 07
        rrca                ; 0F
        rla                 ; 17
        rra                 ; 1F

;---------------------------------------
; General purpose
;---------------------------------------
op_misc:
        daa                 ; 27
        cpl                 ; 2F
        scf                 ; 37
        ccf                 ; 3F
        nop                 ; 00
        halt                ; 76
        di                  ; F3
        ei                  ; FB

;---------------------------------------
; Jump instructions
;---------------------------------------
op_jp:
        jp $1234            ; C3 34 12
        jp nz, $1234        ; C2 34 12
        jp z, $1234         ; CA 34 12
        jp nc, $1234        ; D2 34 12
        jp c, $1234         ; DA 34 12
        jp po, $1234        ; E2 34 12
        jp pe, $1234        ; EA 34 12
        jp p, $1234         ; F2 34 12
        jp m, $1234         ; FA 34 12
        jp (hl)             ; E9

op_jr:
        jr op_jr            ; 18 FE (jump to self)
        jr nz, op_jr        ; 20 FC
        jr z, op_jr         ; 28 FA
        jr nc, op_jr        ; 30 F8
        jr c, op_jr         ; 38 F6

op_djnz:
        djnz op_djnz        ; 10 FE (jump to self)

;---------------------------------------
; Call and Return
;---------------------------------------
op_call:
        call $1234          ; CD 34 12
        call nz, $1234      ; C4 34 12
        call z, $1234       ; CC 34 12
        call nc, $1234      ; D4 34 12
        call c, $1234       ; DC 34 12
        call po, $1234      ; E4 34 12
        call pe, $1234      ; EC 34 12
        call p, $1234       ; F4 34 12
        call m, $1234       ; FC 34 12

op_ret:
        ret                 ; C9
        ret nz              ; C0
        ret z               ; C8
        ret nc              ; D0
        ret c               ; D8
        ret po              ; E0
        ret pe              ; E8
        ret p               ; F0
        ret m               ; F8

;---------------------------------------
; RST instructions
;---------------------------------------
op_rst:
        rst $00             ; C7
        rst $08             ; CF
        rst $10             ; D7
        rst $18             ; DF
        rst $20             ; E7
        rst $28             ; EF
        rst $30             ; F7
        rst $38             ; FF

;---------------------------------------
; I/O instructions
;---------------------------------------
op_io:
        in a, ($42)         ; DB 42
        out ($42), a        ; D3 42

;===============================================================================
; SECTION 12: Z80 OPCODE TESTS - CB PREFIX (BIT OPERATIONS)
;===============================================================================
section_opcodes_cb:

;---------------------------------------
; Rotate/Shift operations
;---------------------------------------
op_rlc:
        rlc a               ; CB 07
        rlc b               ; CB 00
        rlc c               ; CB 01
        rlc d               ; CB 02
        rlc e               ; CB 03
        rlc h               ; CB 04
        rlc l               ; CB 05
        rlc (hl)            ; CB 06

op_rrc:
        rrc a               ; CB 0F
        rrc b               ; CB 08
        rrc c               ; CB 09
        rrc d               ; CB 0A
        rrc e               ; CB 0B
        rrc h               ; CB 0C
        rrc l               ; CB 0D
        rrc (hl)            ; CB 0E

op_rl:
        rl a                ; CB 17
        rl b                ; CB 10
        rl c                ; CB 11
        rl d                ; CB 12
        rl e                ; CB 13
        rl h                ; CB 14
        rl l                ; CB 15
        rl (hl)             ; CB 16

op_rr:
        rr a                ; CB 1F
        rr b                ; CB 18
        rr c                ; CB 19
        rr d                ; CB 1A
        rr e                ; CB 1B
        rr h                ; CB 1C
        rr l                ; CB 1D
        rr (hl)             ; CB 1E

op_sla:
        sla a               ; CB 27
        sla b               ; CB 20
        sla c               ; CB 21
        sla d               ; CB 22
        sla e               ; CB 23
        sla h               ; CB 24
        sla l               ; CB 25
        sla (hl)            ; CB 26

op_sra:
        sra a               ; CB 2F
        sra b               ; CB 28
        sra c               ; CB 29
        sra d               ; CB 2A
        sra e               ; CB 2B
        sra h               ; CB 2C
        sra l               ; CB 2D
        sra (hl)            ; CB 2E

op_srl:
        srl a               ; CB 3F
        srl b               ; CB 38
        srl c               ; CB 39
        srl d               ; CB 3A
        srl e               ; CB 3B
        srl h               ; CB 3C
        srl l               ; CB 3D
        srl (hl)            ; CB 3E

;---------------------------------------
; BIT test operations
;---------------------------------------
op_bit:
        bit 0, a            ; CB 47
        bit 1, b            ; CB 48
        bit 2, c            ; CB 51
        bit 3, d            ; CB 5A
        bit 4, e            ; CB 63
        bit 5, h            ; CB 6C
        bit 6, l            ; CB 75
        bit 7, (hl)         ; CB 7E

;---------------------------------------
; SET bit operations
;---------------------------------------
op_set:
        set 0, a            ; CB C7
        set 1, b            ; CB C8
        set 2, c            ; CB D1
        set 3, d            ; CB DA
        set 4, e            ; CB E3
        set 5, h            ; CB EC
        set 6, l            ; CB F5
        set 7, (hl)         ; CB FE

;---------------------------------------
; RES bit operations
;---------------------------------------
op_res:
        res 0, a            ; CB 87
        res 1, b            ; CB 88
        res 2, c            ; CB 91
        res 3, d            ; CB 9A
        res 4, e            ; CB A3
        res 5, h            ; CB AC
        res 6, l            ; CB B5
        res 7, (hl)         ; CB BE

;===============================================================================
; SECTION 13: Z80 OPCODE TESTS - ED PREFIX (EXTENDED)
;===============================================================================
section_opcodes_ed:

;---------------------------------------
; Block transfer instructions
;---------------------------------------
op_block_ld:
        ldi                 ; ED A0
        ldir                ; ED B0
        ldd                 ; ED A8
        lddr                ; ED B8

;---------------------------------------
; Block compare instructions
;---------------------------------------
op_block_cp:
        cpi                 ; ED A1
        cpir                ; ED B1
        cpd                 ; ED A9
        cpdr                ; ED B9

;---------------------------------------
; Block I/O instructions
;---------------------------------------
op_block_io:
        ini                 ; ED A2
        inir                ; ED B2
        ind                 ; ED AA
        indr                ; ED BA
        outi                ; ED A3
        otir                ; ED B3
        outd                ; ED AB
        otdr                ; ED BB

;---------------------------------------
; 16-bit arithmetic with carry
;---------------------------------------
op_adc_hl:
        adc hl, bc          ; ED 4A
        adc hl, de          ; ED 5A
        adc hl, hl          ; ED 6A
        adc hl, sp          ; ED 7A

op_sbc_hl:
        sbc hl, bc          ; ED 42
        sbc hl, de          ; ED 52
        sbc hl, hl          ; ED 62
        sbc hl, sp          ; ED 72

;---------------------------------------
; 16-bit load to memory
;---------------------------------------
op_ld_nn_rr:
        ld ($1234), bc      ; ED 43 34 12
        ld ($1234), de      ; ED 53 34 12
        ld ($1234), hl      ; ED 63 34 12  (alternate encoding)
        ld ($1234), sp      ; ED 73 34 12

op_ld_rr_nn_ind:
        ld bc, ($1234)      ; ED 4B 34 12
        ld de, ($1234)      ; ED 5B 34 12
        ld hl, ($1234)      ; ED 6B 34 12  (alternate encoding)
        ld sp, ($1234)      ; ED 7B 34 12

;---------------------------------------
; Negate accumulator
;---------------------------------------
op_neg:
        neg                 ; ED 44

;---------------------------------------
; Interrupt modes
;---------------------------------------
op_im:
        im 0                ; ED 46
        im 1                ; ED 56
        im 2                ; ED 5E

;---------------------------------------
; Return from interrupt
;---------------------------------------
op_reti:
        reti                ; ED 4D
        retn                ; ED 45

;---------------------------------------
; I/O with C register
;---------------------------------------
op_io_c:
        in a, (c)           ; ED 78
        in b, (c)           ; ED 40
        in c, (c)           ; ED 48
        in d, (c)           ; ED 50
        in e, (c)           ; ED 58
        in h, (c)           ; ED 60
        in l, (c)           ; ED 68
        out (c), a          ; ED 79
        out (c), b          ; ED 41
        out (c), c          ; ED 49
        out (c), d          ; ED 51
        out (c), e          ; ED 59
        out (c), h          ; ED 61
        out (c), l          ; ED 69

;---------------------------------------
; Special registers
;---------------------------------------
op_special:
        ld i, a             ; ED 47
        ld r, a             ; ED 4F
        ld a, i             ; ED 57
        ld a, r             ; ED 5F
        rrd                 ; ED 67
        rld                 ; ED 6F

;===============================================================================
; SECTION 14: Z80 OPCODE TESTS - DD PREFIX (IX REGISTER)
;===============================================================================
section_opcodes_dd:

;---------------------------------------
; IX load instructions
;---------------------------------------
op_ld_ix:
        ld ix, $1234        ; DD 21 34 12
        ld ($1234), ix      ; DD 22 34 12
        ld ix, ($1234)      ; DD 2A 34 12
        ld sp, ix           ; DD F9

op_ld_ix_offset:
        ld a, (ix+$10)      ; DD 7E 10
        ld b, (ix+$10)      ; DD 46 10
        ld c, (ix+$10)      ; DD 4E 10
        ld d, (ix+$10)      ; DD 56 10
        ld e, (ix+$10)      ; DD 5E 10
        ld h, (ix+$10)      ; DD 66 10
        ld l, (ix+$10)      ; DD 6E 10

op_ld_ix_offset_r:
        ld (ix+$10), a      ; DD 77 10
        ld (ix+$10), b      ; DD 70 10
        ld (ix+$10), c      ; DD 71 10
        ld (ix+$10), d      ; DD 72 10
        ld (ix+$10), e      ; DD 73 10
        ld (ix+$10), h      ; DD 74 10
        ld (ix+$10), l      ; DD 75 10

op_ld_ix_offset_n:
        ld (ix+$10), $42    ; DD 36 10 42

;---------------------------------------
; IX arithmetic
;---------------------------------------
op_add_ix:
        add ix, bc          ; DD 09
        add ix, de          ; DD 19
        add ix, ix          ; DD 29
        add ix, sp          ; DD 39

op_inc_dec_ix:
        inc ix              ; DD 23
        dec ix              ; DD 2B
        inc (ix+$10)        ; DD 34 10
        dec (ix+$10)        ; DD 35 10

;---------------------------------------
; IX arithmetic with offset
;---------------------------------------
op_arith_ix:
        add a, (ix+$10)     ; DD 86 10
        adc a, (ix+$10)     ; DD 8E 10
        sub (ix+$10)        ; DD 96 10
        sbc a, (ix+$10)     ; DD 9E 10
        and (ix+$10)        ; DD A6 10
        or (ix+$10)         ; DD B6 10
        xor (ix+$10)        ; DD AE 10
        cp (ix+$10)         ; DD BE 10

;---------------------------------------
; IX stack operations
;---------------------------------------
op_push_pop_ix:
        push ix             ; DD E5
        pop ix              ; DD E1

;---------------------------------------
; IX exchange
;---------------------------------------
op_ex_ix:
        ex (sp), ix         ; DD E3

;---------------------------------------
; IX jump
;---------------------------------------
op_jp_ix:
        jp (ix)             ; DD E9

;---------------------------------------
; IX bit operations (DD CB prefix)
;---------------------------------------
op_bit_ix:
        rlc (ix+$10)        ; DD CB 10 06
        rrc (ix+$10)        ; DD CB 10 0E
        rl (ix+$10)         ; DD CB 10 16
        rr (ix+$10)         ; DD CB 10 1E
        sla (ix+$10)        ; DD CB 10 26
        sra (ix+$10)        ; DD CB 10 2E
        srl (ix+$10)        ; DD CB 10 3E
        bit 0, (ix+$10)     ; DD CB 10 46
        bit 7, (ix+$10)     ; DD CB 10 7E
        set 0, (ix+$10)     ; DD CB 10 C6
        set 7, (ix+$10)     ; DD CB 10 FE
        res 0, (ix+$10)     ; DD CB 10 86
        res 7, (ix+$10)     ; DD CB 10 BE

;===============================================================================
; SECTION 15: Z80 OPCODE TESTS - FD PREFIX (IY REGISTER)
;===============================================================================
section_opcodes_fd:

;---------------------------------------
; IY load instructions
;---------------------------------------
op_ld_iy:
        ld iy, $1234        ; FD 21 34 12
        ld ($1234), iy      ; FD 22 34 12
        ld iy, ($1234)      ; FD 2A 34 12
        ld sp, iy           ; FD F9

op_ld_iy_offset:
        ld a, (iy+$10)      ; FD 7E 10
        ld b, (iy+$10)      ; FD 46 10
        ld c, (iy+$10)      ; FD 4E 10
        ld d, (iy+$10)      ; FD 56 10
        ld e, (iy+$10)      ; FD 5E 10
        ld h, (iy+$10)      ; FD 66 10
        ld l, (iy+$10)      ; FD 6E 10

op_ld_iy_offset_r:
        ld (iy+$10), a      ; FD 77 10
        ld (iy+$10), b      ; FD 70 10
        ld (iy+$10), c      ; FD 71 10
        ld (iy+$10), d      ; FD 72 10
        ld (iy+$10), e      ; FD 73 10
        ld (iy+$10), h      ; FD 74 10
        ld (iy+$10), l      ; FD 75 10

op_ld_iy_offset_n:
        ld (iy+$10), $42    ; FD 36 10 42

;---------------------------------------
; IY arithmetic
;---------------------------------------
op_add_iy:
        add iy, bc          ; FD 09
        add iy, de          ; FD 19
        add iy, iy          ; FD 29
        add iy, sp          ; FD 39

op_inc_dec_iy:
        inc iy              ; FD 23
        dec iy              ; FD 2B
        inc (iy+$10)        ; FD 34 10
        dec (iy+$10)        ; FD 35 10

;---------------------------------------
; IY arithmetic with offset
;---------------------------------------
op_arith_iy:
        add a, (iy+$10)     ; FD 86 10
        adc a, (iy+$10)     ; FD 8E 10
        sub (iy+$10)        ; FD 96 10
        sbc a, (iy+$10)     ; FD 9E 10
        and (iy+$10)        ; FD A6 10
        or (iy+$10)         ; FD B6 10
        xor (iy+$10)        ; FD AE 10
        cp (iy+$10)         ; FD BE 10

;---------------------------------------
; IY stack operations
;---------------------------------------
op_push_pop_iy:
        push iy             ; FD E5
        pop iy              ; FD E1

;---------------------------------------
; IY exchange
;---------------------------------------
op_ex_iy:
        ex (sp), iy         ; FD E3

;---------------------------------------
; IY jump
;---------------------------------------
op_jp_iy:
        jp (iy)             ; FD E9

;---------------------------------------
; IY bit operations (FD CB prefix)
;---------------------------------------
op_bit_iy:
        rlc (iy+$10)        ; FD CB 10 06
        rrc (iy+$10)        ; FD CB 10 0E
        rl (iy+$10)         ; FD CB 10 16
        rr (iy+$10)         ; FD CB 10 1E
        sla (iy+$10)        ; FD CB 10 26
        sra (iy+$10)        ; FD CB 10 2E
        srl (iy+$10)        ; FD CB 10 3E
        bit 0, (iy+$10)     ; FD CB 10 46
        bit 7, (iy+$10)     ; FD CB 10 7E
        set 0, (iy+$10)     ; FD CB 10 C6
        set 7, (iy+$10)     ; FD CB 10 FE
        res 0, (iy+$10)     ; FD CB 10 86
        res 7, (iy+$10)     ; FD CB 10 BE

;===============================================================================
; SECTION 16: NEGATIVE OFFSETS FOR IX/IY
;===============================================================================
section_negative_offsets:

op_ix_neg:
        ld a, (ix-$10)      ; DD 7E F0 (offset -16 = $F0)
        ld (ix-1), a        ; DD 77 FF (offset -1 = $FF)
        add a, (ix-$20)     ; DD 86 E0 (offset -32 = $E0)

op_iy_neg:
        ld a, (iy-$10)      ; FD 7E F0
        ld (iy-1), a        ; FD 77 FF
        add a, (iy-$20)     ; FD 86 E0

;===============================================================================
; SECTION 17: UNDOCUMENTED OPCODES (OPTIONAL)
;===============================================================================
section_undocumented:

; IXH, IXL, IYH, IYL (if supported)
; These are undocumented but widely used
op_ixh_ixl:
        ld a, ixh           ; DD 7C (if supported)
        ld a, ixl           ; DD 7D
        ld ixh, a           ; DD 67
        ld ixl, a           ; DD 6F
        ld ixh, $42         ; DD 26 42
        ld ixl, $42         ; DD 2E 42

op_iyh_iyl:
        ld a, iyh           ; FD 7C
        ld a, iyl           ; FD 7D
        ld iyh, a           ; FD 67
        ld iyl, a           ; FD 6F
        ld iyh, $42         ; FD 26 42
        ld iyl, $42         ; FD 2E 42

;===============================================================================
; SECTION 18: INCBIN TESTS
;===============================================================================
; test_incbin_data.bin contains: "TESTDATA0123456789ABCDEF" (24 bytes)
section_incbin:

;---------------------------------------
; Basic INCBIN - include entire file
;---------------------------------------
incbin_full_start:
        INCBIN "test_incbin_data.bin"
incbin_full_end:
        ASSERT (incbin_full_end - incbin_full_start) == 24, "INCBIN full file failed"

;---------------------------------------
; INCBIN with offset - skip first N bytes
;---------------------------------------
incbin_offset_start:
        INCBIN "test_incbin_data.bin", 8        ; Skip "TESTDATA", include rest
incbin_offset_end:
        ASSERT (incbin_offset_end - incbin_offset_start) == 16, "INCBIN offset failed"

;---------------------------------------
; INCBIN with offset and length - partial include
;---------------------------------------
incbin_partial_start:
        INCBIN "test_incbin_data.bin", 4, 4     ; Include "DATA" only
incbin_partial_end:
        ASSERT (incbin_partial_end - incbin_partial_start) == 4, "INCBIN offset+length failed"

;---------------------------------------
; INCBIN from start with length limit
;---------------------------------------
incbin_length_start:
        INCBIN "test_incbin_data.bin", 0, 8     ; Include "TESTDATA" only
incbin_length_end:
        ASSERT (incbin_length_end - incbin_length_start) == 8, "INCBIN length limit failed"

;---------------------------------------
; INCBIN with expression offsets
;---------------------------------------
INCBIN_OFFSET EQU 10
INCBIN_LENGTH EQU 6
incbin_expr_start:
        INCBIN "test_incbin_data.bin", INCBIN_OFFSET, INCBIN_LENGTH
incbin_expr_end:
        ASSERT (incbin_expr_end - incbin_expr_start) == INCBIN_LENGTH, "INCBIN expression params failed"

;---------------------------------------
; Multiple INCBIN in sequence
;---------------------------------------
incbin_multi_start:
        INCBIN "test_incbin_data.bin", 0, 4     ; "TEST"
        INCBIN "test_incbin_data.bin", 20, 4    ; "CDEF"
incbin_multi_end:
        ASSERT (incbin_multi_end - incbin_multi_start) == 8, "Multiple INCBIN failed"

;===============================================================================
; SECTION 19: ASSERT TESTS
;===============================================================================
section_asserts:

; Test ASSERT with various expressions
        ASSERT 1 == 1, "Basic equality failed"
        ASSERT 10 > 5, "Greater than failed"
        ASSERT 5 < 10, "Less than failed"
        ASSERT 10 >= 10, "Greater or equal failed"
        ASSERT 10 <= 10, "Less or equal failed"
        ASSERT 5 != 10, "Not equal failed"
        ASSERT CONST_BYTE == $42, "EQU constant assert failed"
        ASSERT INC_CONST_DEC == 100, "Included constant assert failed"

;===============================================================================
; SECTION 20: BSS SECTION TEST (Uninitialized RAM)
;===============================================================================
; BSS section for uninitialized variables (RAM only, not in ROM)
; This tests v2's SECTION BSS feature

        SECTION BSS

bss_start:
bss_byte_var:       DS 1                ; 1 byte uninitialized
bss_word_var:       DS 2                ; 2 bytes (word) uninitialized
bss_buffer:         DS 32               ; 32-byte buffer uninitialized
bss_array:          DS 10               ; 10-byte array uninitialized
bss_end:

; Calculate BSS size
bss_size            EQU bss_end - bss_start

        SECTION CODE                    ; Return to CODE section

;===============================================================================
; SECTION 21: FINAL TEST DATA AND END
;===============================================================================
section_end:

; Final marker
end_marker:         DB $DE, $AD, $BE, $EF

; Calculate total size (ROM only, not BSS)
total_size          EQU $ - $8000

; Verify we generated something substantial (expecting ~1400+ bytes)
        ASSERT total_size > $500, "Test file too small!"

;===============================================================================
; END OF TEST FILE
;===============================================================================
; If this file assembles without errors, the assembler supports:
;
; ✅ All number formats (decimal, hex $, 0x, h, binary %, b, octal @, char)
; ✅ All expression operators (+, -, *, /, %, &, |, ^, ~, <<, >>, HIGH, LOW, <, >)
; ✅ Program counter ($) in expressions
; ✅ EQU constants and expressions
; ✅ All label types (basic, with colon, local with .)
; ✅ Forward and backward references
; ✅ Label arithmetic
; ✅ All data directives (DB, DW, DS, DEFB, DEFW, DEFS, BYTE, WORD, BLOCK, DEFM, ASCII, TEXT)
; ✅ TIMES directive
; ✅ ALIGN directive
; ✅ INCLUDE directive
; ✅ INCBIN directive (full file, offset, offset+length, expression params)
; ✅ Conditional assembly (IF, ELIF, ELSE, ENDIF, IFDEF, IFNDEF)
; ✅ Macros with parameters and local labels
; ✅ STRUCT/ENDSTRUCT
; ✅ ASSERT directive
; ✅ SECTION BSS (v2 feature - uninitialized RAM)
; ✅ SECTION CODE (explicit code section)
; ✅ All main Z80 opcodes (no prefix)
; ✅ All CB-prefix opcodes (bit operations)
; ✅ All ED-prefix opcodes (extended)
; ✅ All DD-prefix opcodes (IX register)
; ✅ All FD-prefix opcodes (IY register)
; ✅ DD CB and FD CB prefix opcodes (IX/IY bit operations)
; ✅ Negative offsets for IX/IY
; ✅ Undocumented IXH, IXL, IYH, IYL (if supported)
;===============================================================================
