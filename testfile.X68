*-----------------------------------------------------------
* Title      :test file
* Written by :Harper Hults
* Date       :5/23
* Description:has a couple instructions to load into memory for the disassembler
*-----------------------------------------------------------
    ORG    $5000
START:                  ; first instruction of program

    *MOVE.B #$FF,D1
    NOP
    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
