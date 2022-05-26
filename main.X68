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
    
    JSR BUILDTREE
    MOVEA.L TREE,A5
    MOVEA.L (A5),A1
    JSR (A1)


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
    
BUILDTREE
        MOVE.W #0,D0
        MOVEA.L TREE,A1
BLDLOOP *LEA UNDEF,A6      * initialize whole tree to undefined
        MOVE.L #UNDEF,(A1)+
        ADDQ #1,D0
        CMP.W #513,D0
        BNE BLDLOOP
        
        MOVEA.L TREE,A1

        MOVE.L #TESTBIT,(A1)+ * nodes 0 - 11 are decision nodes
        MOVE.L #TESTBIT,(A1)+
        MOVE.L #TESTBIT,(A1)+
        MOVE.L #TESTBIT,(A1)+
        MOVE.L #TESTBIT,(A1)+
        MOVE.L #TESTBIT,(A1)+
        MOVE.L #TESTBIT,(A1)+
        MOVE.L #TESTBIT,(A1)+
        MOVE.L #TESTBIT,(A1)+
        MOVE.L #TESTBIT,(A1)+
        MOVE.L #TESTBIT,(A1)+
        MOVE.L #TESTBIT,(A1)+

        
            * node 12 is an invalid code
        MOVE.L #BAD,(A1)+
        
        MOVE.L #TESTBIT,(A1)+  * nodes 13&14 are decision nodes
        MOVE.L #TESTBIT,(A1)+ 
        
        *
        *
        *
            * node 15 is an invalid node
        MOVEA.L TREE,A1
        ADDA.L #$58,A1
        MOVE.L #BAD,(A1)
        
            * put MOVEQ at node 22
        MOVEA.L TREE,A1
        ADDA.L #$58,A1
        MOVE.L #MOVEQ,(A1)
        
            * put MOVE.B at node 16
        MOVEA.L TREE,A1
        ADDA.L #$40,A1
        MOVE.L #MOVEB,(A1)
        
        RTS
    
UNDEF LEA UNDEFINED,A1
      MOVE.B #14,D0
      TRAP #15
      JSR DONE 
      
BAD   LEA BADDATA,A1
      MOVE.B #14,D0
      TRAP #15
      JSR DONE
      
MOVEB  LEA MB,A1
       MOVE.B #14,D0
       TRAP #15
       RTS 
      
MOVEQ LEA MQP,A1
       MOVE.B #14,D0
       TRAP #15
       RTS 

TESTBIT
    MOVE.W (A4),D3
    MOVE.L A5,D1
    SUB.L TREE,D1
    ASL.L #1,D1
    MOVEA.L D1,A5
    BTST.L D2,D3
    BEQ IS_ZERO
    BRA NOT_ZERO
    
IS_ZERO   * if bit D2 of (A4) is zero (go left on tree)
    SUBQ #1,D2
    ADDA.W #4,A5
    ADDA.L TREE,A5
    MOVEA.L (A5),A1
    JSR (A1)
    RTS

NOT_ZERO  * if bit D2 of (A4) is one (go right on tree)
    SUBQ #1,D2
    ADDA.W #8,A5
    ADDA.L TREE,A5
    MOVEA.L (A5),A1
    JSR (A1)
    RTS
    
* var storage
TREE DC.L $7000    
* string storage
PROMPT1  DC.B  'Please enter the memory value of the start of the program: ',0
PROMPT2  DC.B  'Please enter the memory value of the end of the program: ',0
UNDEFINED DC.B 'The program should never reach this state.',0
BADDATA  DC.B 'The data on line ____ is not a valid opcode.',0
MQP DC.B 'Congrats! You successfully found MOVEQ!',0
MB  DC.B 'found MOVEB',0

    END    START


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
