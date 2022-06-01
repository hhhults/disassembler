*-----------------------------------------------------------
* Title      :test file
* Written by :Harper Hults
* Date       :5/23
* Description:has a couple instructions to load into memory for the disassembler
*-----------------------------------------------------------
    ORG    $5000
START:                  ; first instruction of program

   MOVE.L   #$00201010,D4
   ADD.W    D4,D5
   ADDA.L   D5,A6
   ADD.L    D5,$9000
   ADD.L    $9000,D5
   AND.B    #$12,D1
;    NOT D0
;    NOP
;    LEA DONE,A1
;    JSR DONE
;    SIMHALT             ; halt simulator


;DONE MOVE.B #$F,D0
;     RTS           
* Put variables and constants here

    END    START        ; last line of source








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
