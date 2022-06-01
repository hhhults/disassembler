*-----------------------------------------------------------
* Title      :test file
* Written by :Harper Hults
* Date       :5/23
* Description:has a couple instructions to load into memory for the disassembler
*-----------------------------------------------------------
    ORG    $5000
START:                  ; first instruction of program

;   MOVE.L   #$00201010,D4
;   ADD.W    D4,D5
;   ADDA.L   D5,A6
;   ADD.L    D5,$9000
;   ADD.L    $9000,D5
;   AND.B    #$12,D1
   ROR.L    D1,D5
   ROR.L    #$3,D5
   ROR.W    D1,D5
   ROR.W    #$3,D5
   ROR.B    D1,D5
   ROR.B    #$3,D5
   ASL.L    D2,D3
   ASL.L    #$2,D3
   ASL.W    D2,D3
   ASL.W    #$2,D3
   ASL.B    D2,D3
   ASL.B    #$2,D3
   LSL.L    D6,D7
   LSL.L    #$5,D7
   LSL.W    D6,D7
   LSL.W    #$5,D7
   LSL.B    D6,D7
   LSL.B    #$5,D7
   
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
