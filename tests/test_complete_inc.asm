;===============================================================================
; test_complete_inc.asm - Included file for comprehensive assembler test
; This file is INCLUDEd by test_complete.asm to test the INCLUDE directive
;===============================================================================

;---------------------------------------
; Constants defined in included file
;---------------------------------------
INC_CONST_DEC       EQU 100             ; Decimal
INC_CONST_HEX1      EQU $1234           ; Hex with $
INC_CONST_HEX2      EQU 0x5678          ; Hex with 0x
INC_CONST_HEX3      EQU 9ABCh           ; Hex with h suffix
INC_CONST_BIN1      EQU %10101010       ; Binary with %
INC_CONST_BIN2      EQU 11001100b       ; Binary with b suffix
INC_CONST_OCT       EQU @77             ; Octal with @
INC_CONST_CHAR      EQU 'A'             ; Character constant
INC_CONST_EXPR      EQU 10 + 20 * 2     ; Expression (should be 50)

;---------------------------------------
; Macros defined in included file
;---------------------------------------

; Simple macro - no parameters
    MACRO INC_NOP3
        nop
        nop
        nop
    ENDM

; Macro with one parameter
    MACRO INC_LOAD_A value
        ld a, value
    ENDM

; Macro with two parameters
    MACRO INC_LOAD_PAIR reg, value
        ld reg, value
    ENDM

; Macro with expression parameter
    MACRO INC_DELAY count
        ld b, count
.loop:
        djnz .loop
    ENDM

; Macro that generates data
    MACRO INC_BYTE_PATTERN b1, b2, b3
        DB b1, b2, b3
    ENDM

; Macro using local labels (with .)
    MACRO INC_SKIP_NEXT
        jr .skip
        nop
.skip:
    ENDM

;---------------------------------------
; Data defined in included file
;---------------------------------------
inc_data_bytes:
        DB $11, $22, $33, $44, $55

inc_data_words:
        DW $1111, $2222, $3333

inc_data_string:
        DB "INCLUDED", 0

inc_data_mixed:
        DB 1, 2
        DW $AABB
        DB 3, 4

;---------------------------------------
; Structure defined in included file
;---------------------------------------
    STRUCT IncludedStruct
        inc_byte1   DB 1
        inc_word1   DW 1
        inc_byte2   DB 1
        inc_array   DS 4, 0         ; 4 bytes filled with 0
    ENDSTRUCT

;---------------------------------------
; Small routine defined in included file
;---------------------------------------
inc_routine:
        push af
        ld a, INC_CONST_DEC
        pop af
        ret

;---------------------------------------
; End of included file
;---------------------------------------
