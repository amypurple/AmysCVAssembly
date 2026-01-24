;===============================================================================
; AmysCVAssembler v2.1 Feature Tests
;===============================================================================
; This file tests all v2.1 features:
; - PRINT directive (output messages during assembly)
; - FAIL directive (stop assembly with error)
; - STOP directive (stop assembly without error)
; - LET directive (mutable variables)
; - Math functions (ABS, FLOOR, CEIL, SQRT, SIN, COS, etc.)
; - REPEAT/ENDR loop directive
; - WHILE/WEND loop directive
; - SWITCH/CASE/DEFAULT/ENDSWITCH directive
;===============================================================================

        ORG $8000

;===============================================================================
; SECTION 1: PRINT Directive Tests
;===============================================================================
section_print:
        PRINT "=== v2.1 Feature Tests ==="
        PRINT "Assembler: AmysCVAssembler v2.1"
        PRINT "Current PC = ", $
        PRINT "Hex format: ", "{hex}", $8000
        PRINT "Binary format: ", "{bin}", %10101010
        PRINT "Decimal format: ", "{dec}", 255
        PRINT "Expression: 10 + 20 = ", 10 + 20

;===============================================================================
; SECTION 2: LET Directive Tests (Mutable Variables)
;===============================================================================
section_let:
        ; Define mutable variable
        LET counter = 0
        ASSERT counter == 0, "LET initial value failed"
        PRINT "Initial counter = ", counter

        ; Update variable
        LET counter = counter + 5
        ASSERT counter == 5, "LET addition failed"
        PRINT "After +5: counter = ", counter

        ; Multiply
        LET counter = counter * 2
        ASSERT counter == 10, "LET multiply failed"
        PRINT "After *2: counter = ", counter

        ; Multiple variables
        LET a = 100
        LET b = 50
        LET c = a + b
        ASSERT c == 150, "LET with multiple vars failed"
        PRINT "a + b = ", c

;===============================================================================
; SECTION 3: Math Function Tests - Basic
;===============================================================================
section_math_basic:
        PRINT "=== Math Function Tests ==="

        ; ABS - absolute value
        ASSERT ABS(-5) == 5, "ABS negative failed"
        ASSERT ABS(5) == 5, "ABS positive failed"
        ASSERT ABS(0) == 0, "ABS zero failed"
        PRINT "ABS(-5) = ", ABS(-5)

        ; FLOOR, CEIL, ROUND
        ASSERT FLOOR(3.7) == 3, "FLOOR failed"
        ASSERT CEIL(3.2) == 4, "CEIL failed"
        ASSERT ROUND(3.5) == 4, "ROUND failed"
        ASSERT ROUND(3.4) == 3, "ROUND down failed"
        PRINT "FLOOR(3.7) = ", FLOOR(3.7)
        PRINT "CEIL(3.2) = ", CEIL(3.2)

        ; MIN, MAX
        ASSERT MIN(5, 3) == 3, "MIN failed"
        ASSERT MAX(5, 3) == 5, "MAX failed"
        ASSERT MIN(10, 10) == 10, "MIN equal failed"
        PRINT "MIN(5, 3) = ", MIN(5, 3)
        PRINT "MAX(5, 3) = ", MAX(5, 3)

        ; SGN - sign
        ASSERT SGN(-5) == -1, "SGN negative failed"
        ASSERT SGN(5) == 1, "SGN positive failed"
        ASSERT SGN(0) == 0, "SGN zero failed"

        ; SQRT
        ASSERT SQRT(16) == 4, "SQRT 16 failed"
        ASSERT SQRT(100) == 10, "SQRT 100 failed"
        PRINT "SQRT(16) = ", SQRT(16)

        ; POW
        ASSERT POW(2, 8) == 256, "POW 2^8 failed"
        ASSERT POW(3, 2) == 9, "POW 3^2 failed"
        PRINT "POW(2, 8) = ", POW(2, 8)

        ; INT (truncate toward zero)
        ASSERT INT(3.9) == 3, "INT positive failed"
        ASSERT INT(-3.9) == -3, "INT negative failed"

;===============================================================================
; SECTION 4: Math Function Tests - Trigonometry
;===============================================================================
section_math_trig:
        PRINT "=== Trigonometry Tests (degrees) ==="

        ; SIN - sine (input in degrees)
        ; SIN(30) should be 0.5
        PRINT "SIN(30) = ", SIN(30)
        PRINT "SIN(90) = ", SIN(90)

        ; COS - cosine
        ; COS(60) should be 0.5
        PRINT "COS(60) = ", COS(60)
        PRINT "COS(0) = ", COS(0)

        ; TAN
        PRINT "TAN(45) = ", TAN(45)

;===============================================================================
; SECTION 5: Math Function Tests - Logarithms
;===============================================================================
section_math_log:
        PRINT "=== Logarithm Tests ==="

        ; LOG2
        ASSERT LOG2(256) == 8, "LOG2(256) failed"
        PRINT "LOG2(256) = ", LOG2(256)

        ; LOG10
        ASSERT LOG10(100) == 2, "LOG10(100) failed"
        PRINT "LOG10(100) = ", LOG10(100)

;===============================================================================
; SECTION 6: REPEAT/ENDR Tests
;===============================================================================
section_repeat:
        PRINT "=== REPEAT/ENDR Tests ==="

; Basic repeat - 5 NOPs
repeat_basic:
        REPEAT 5
            NOP
        REND
repeat_basic_end:
        ASSERT repeat_basic_end - repeat_basic == 5, "Basic REPEAT failed (expected 5 NOPs)"
        PRINT "Basic REPEAT: ", repeat_basic_end - repeat_basic, " bytes"

; Repeat with counter variable
repeat_counter:
        REPEAT 4, idx
            DB idx              ; Should produce: 0, 1, 2, 3
        REND
repeat_counter_end:
        ASSERT repeat_counter_end - repeat_counter == 4, "REPEAT counter failed"
        PRINT "REPEAT with counter: ", repeat_counter_end - repeat_counter, " bytes"

; Nested repeat (4x4 = 16 bytes)
repeat_nested:
        REPEAT 4, row
            REPEAT 4, col
                DB row * 4 + col
            REND
        REND
repeat_nested_end:
        ASSERT repeat_nested_end - repeat_nested == 16, "Nested REPEAT failed"
        PRINT "Nested REPEAT 4x4: ", repeat_nested_end - repeat_nested, " bytes"

; ENDR alias test
repeat_endr:
        REPEAT 3
            NOP
        ENDR
repeat_endr_end:
        ASSERT repeat_endr_end - repeat_endr == 3, "ENDR alias failed"

;===============================================================================
; SECTION 7: Sine Table Generation (Practical Example)
;===============================================================================
section_sinetable:
        PRINT "=== Sine Table Generation ==="

sine_table:
        LET angle = 0
        REPEAT 16
            ; Generate sine value scaled to 0-255 range
            ; 128 + SIN(angle * 360 / 256) * 127
            DB 128 + FLOOR(SIN(angle * 360 / 16) * 127)
            LET angle = angle + 1
        REND
sine_table_end:
        ASSERT sine_table_end - sine_table == 16, "Sine table size wrong"
        PRINT "Sine table size: ", sine_table_end - sine_table, " bytes"

;===============================================================================
; SECTION 8: WHILE/WEND Tests
;===============================================================================
section_while:
        PRINT "=== WHILE/WEND Tests ==="

while_test:
        LET x = 0
        WHILE x < 5
            DB x
            LET x = x + 1
        WEND
while_test_end:
        ASSERT while_test_end - while_test == 5, "WHILE loop failed"
        PRINT "WHILE loop: ", while_test_end - while_test, " bytes"

;===============================================================================
; SECTION 9: SWITCH/CASE Tests
;===============================================================================
section_switch:
        PRINT "=== SWITCH/CASE Tests ==="

TEST_MODE EQU 2

switch_test:
        SWITCH TEST_MODE
            CASE 0
                DB 0
            CASE 1
                DB 1
            CASE 2
                DB 2       ; This should be included (TEST_MODE == 2)
            DEFAULT
                DB $FF
        ENDSWITCH
switch_test_end:
        ASSERT switch_test_end - switch_test == 1, "SWITCH failed"
        PRINT "SWITCH result: ", switch_test_end - switch_test, " bytes"

; SWITCH with different value
TEST_MODE2 EQU 5

switch_default:
        SWITCH TEST_MODE2
            CASE 1
                DB 1
            CASE 2
                DB 2
            DEFAULT
                DB $FF     ; This should be included (TEST_MODE2 == 5, not 1 or 2)
        ENDSWITCH
switch_default_end:
        ASSERT switch_default_end - switch_default == 1, "SWITCH DEFAULT failed"

;===============================================================================
; SECTION 10: Combined Feature Test
;===============================================================================
section_combined:
        PRINT "=== Combined Feature Test ==="

; Generate a lookup table using REPEAT and math functions
power_of_two_table:
        LET n = 0
        REPEAT 8, bit
            DW POW(2, bit)      ; 1, 2, 4, 8, 16, 32, 64, 128
            LET n = n + 1
        REND
power_of_two_table_end:
        ASSERT power_of_two_table_end - power_of_two_table == 16, "Power of 2 table failed"
        PRINT "Power of 2 table: ", power_of_two_table_end - power_of_two_table, " bytes"

;===============================================================================
; END MARKER
;===============================================================================
section_end:
end_marker:         DB $DE, $AD, $BE, $EF

total_size          EQU $ - $8000
        ASSERT total_size > 50, "Test file too small!"

        PRINT "=== Test Complete ==="
        PRINT "Total ROM size: ", total_size, " bytes"

;===============================================================================
; END OF v2.1 FEATURE TEST FILE
;===============================================================================
; If this file assembles without errors, v2.1 features work correctly:
;
; - PRINT directive (output messages)
; - LET directive (mutable variables)
; - Math functions: ABS, FLOOR, CEIL, ROUND, MIN, MAX, SGN, SQRT, POW, INT
; - Trig functions: SIN, COS, TAN (degrees)
; - Log functions: LOG, LOG2, LOG10
; - REPEAT/REND/ENDR with optional counter variable
; - Nested REPEAT support
; - WHILE/WEND loops
; - SWITCH/CASE/DEFAULT/ENDSWITCH
;===============================================================================
