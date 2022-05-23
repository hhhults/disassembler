*-----------------------------------------------------------
* Title      : motorola 68k disassembler prototype
* Written by : Harper Hults
* Date       : 5/23/22
* Description: expect you to load a testfile in at $5000. checks the 15th bit.
*-----------------------------------------------------------
    ORG    $1000
START:
    *JSR WELCOME
    MOVEA.L #$5000,A2    * for testing
    MOVEA.L #$6000,A3
    
    MOVE.B #$F,D2
    MOVEA.L  A2,A4      * does this need to be W depending on where in mem start is?
    JSR TESTBIT


DONE                * end program
    MOVE.B  #9,D0
    TRAP    #15
    
WELCOME
    LEA PROMPT1,A1  * get start memory value, put in A2
    MOVE.B #14,D0
    TRAP #15
    MOVE.B #4,D0
    TRAP #15
    MOVEA.L D1,A2
    
    LEA PROMPT2,A1  * get end memory value, put in D3
    MOVE.B #14,D0
    TRAP #15
    MOVE.B #4,D0
    TRAP #15
    MOVEA.L D1,A3
    RTS
    
TESTBIT
    MOVE.W (A4),D3
    BTST.L D2,D3
    BEQ IS_ZERO
    BRA NOT_ZERO
    
IS_ZERO   * if bit D2 of (A4) is zero (go left on tree)
    

NOT_ZERO  * if bit D2 of (A4) is one (go right on tree)
    
* string storage
PROMPT1  DC.B  'Please enter the memory value of the start of the program: ',0
PROMPT2  DC.B  'Please enter the memory value of the end of the program: ',0

    END    START

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
