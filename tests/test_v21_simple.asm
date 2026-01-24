; Simple v2.1 Feature Test
; Tests basic LET, PRINT, REPEAT functionality

        ORG $8000

; Test 1: LET and PRINT
        PRINT "Test 1: LET directive"
        LET x = 5
        PRINT "x = ", x
        LET x = x + 3
        PRINT "x after +3 = ", x

; Test 2: Basic REPEAT
test_repeat:
        PRINT "Test 2: Basic REPEAT"
        REPEAT 3
            NOP
        REND
test_repeat_end:
        PRINT "REPEAT generated ", test_repeat_end - test_repeat, " bytes"

; Test 3: REPEAT with counter
test_repeat2:
        PRINT "Test 3: REPEAT with counter"
        REPEAT 4, i
            DB i
        REND
test_repeat2_end:

; Test 4: Math functions
        PRINT "Test 4: Math functions"
        PRINT "ABS(-10) = ", ABS(-10)
        PRINT "SQRT(16) = ", SQRT(16)
        PRINT "MIN(3, 7) = ", MIN(3, 7)
        PRINT "MAX(3, 7) = ", MAX(3, 7)
        PRINT "POW(2, 8) = ", POW(2, 8)

; Test 5: Trig (degrees)
        PRINT "Test 5: Trig (degrees)"
        PRINT "SIN(30) = ", SIN(30)
        PRINT "COS(60) = ", COS(60)

; End marker
end_marker:
        DB $DE, $AD, $BE, $EF

        PRINT "=== Test Complete ==="
        PRINT "Total size: ", $ - $8000, " bytes"
