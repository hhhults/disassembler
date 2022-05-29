*-----------------------------------------------------------
* Title      : motorola 68k disassembler prototype
* Written by : Harper Hults
* Date       : 5/25/22
* Description: allows for decoding of MOVEB and MOVEQ opcodes.
*-----------------------------------------------------------
    ORG    $1000
START:
    *JSR WELCOME
    MOVEA.L #$5000,A2    * for testing
    MOVEA.L #$501E,A3
    MOVEA.L #$00000500,A5
    MOVEA.L  A2,A4      * does this need to be W depending on where in mem start is?
    JSR BUILD_EA_TREE
    JSR BUILDTREE
    
    
NEXTLINE JSR DECODE_OP
         CMP.L A4,A3
         BLE DONE
         LEA     NXT_LINE,A1
         MOVE    #13,D0
         TRAP    #15
         BRA NEXTLINE


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
BLDLOOP MOVE.L #UNDEF,(A1)+    * initialize whole tree to undefined
        ADDQ #1,D0
        CMP.W #513,D0
        BNE BLDLOOP
        
        MOVEA.L TREE,A1

        MOVE.L #TESTBIT,(A1)+  * nodes 0 - 11 are decision nodes
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
        MOVE.L #BAD,(A1)+      * node 12 is an invalid code
        MOVE.L #TESTBIT,(A1)+  * nodes 13&14 are decision nodes
        MOVE.L #TESTBIT,(A1)+
        MOVE.L #BAD,(A1)+      * node 15 is an invalid node
        MOVE.L #MOVEB,(A1)+    * put MOVE.B at node 16
        MOVE.L #MOVEL,(A1)+    * MOVE.L/MOVEA.L goes at node 17
        MOVE.L #MOVEW,(A1)+    * MOVE.W/MOVEA.W goes at 18
        MOVE.L #NOPETC,(A1)+   * NOP et al. subroutine goes at 19
        MOVE.L #ADDQ,(A1)+     * ADDQ goes at 20
        MOVE.L #TESTBIT,(A1)+  * 21 is a decision node
        MOVE.L #MOVEQ,(A1)+    * MOVEQ goes at 22
        MOVE.L #BAD,(A1)+      * 23 is invalid code
        MOVE.L #SUB,(A1)+      * 24 is SUB
        
        ADDA.W #8,A1           * should put us at TREE + $6C
        MOVE.L #AND,(A1)+      * node 27 is AND
        MOVE.L #ADD,(A1)+      * node 28 is ADD
        MOVE.L #TESTBIT,(A1)+  * 29 is a decision node
        MOVE.L #BAD,(A1)+      * 30 is invalid code, puts us at TREE + $7C
        
        ADDA.W #$30,A1         * go to TREE + $AC which is node 43
        MOVE.L #TESTBIT,(A1)+  * 43 is decision node
        MOVE.L #TESTBIT,(A1)   * 44 is decision node, should be B0
        
        ADDA.W #$3C,A1         * should put us at TREE + $EC
        MOVE.L #TESTBIT,(A1)+  * node 59 is decision
        MOVE.L #BAD,(A1)       * node 60 is invalid code
        
        ADDA.W #$6C,A1         * should put us at TREE + $15C
        MOVE.L #BRA,(A1)+      * node 87 is BRA
        MOVE.L #BEQ,(A1)+      * node 88 is BEQ
        MOVE.L #BAD,(A1)+      * node 89 is an invalid code
        MOVE.L #TESTBIT,(A1)   * node 90 is a decision node
        
        ADDA.W #$74,A1         * should put us at TREE + $DC?
        MOVE.L #TESTBIT,(A1)+  * nodes 119,120 are decision nodes
        MOVE.L #TESTBIT,(A1)   * A1= TREE + $1E0?
        
        ADDA.W #$F4,A1         * puts us at TREE + $2D4?
        MOVE.L #BAD,(A1)+      * node 181 is an invalid code
        MOVE.L #TESTBIT,(A1)   * node 182 is a decision node
        
        ADDA.W #$E4,A1
        MOVE.L #TESTBIT,(A1)+  * node 239 is a deicsion node
        MOVE.L #TESTBIT,(A1)+  * node 240 is a deicsion node
        MOVE.L #BAD,(A1)+      * node 241 is an invalid code
        MOVE.L #TESTBIT,(A1)   * node 242 is a deicsion node
        
        ADDA.W #$1EC,A1
        MOVE.L #BGT,(A1)+      * node 365 is BGT
        MOVE.L #BLE,(A1)       * node 366 is BLE
        
        ADDA.W #$1C4,A1
        MOVE.L #ASR,(A1)+      * node 479 is ASR
        MOVE.L #ASL,(A1)+      * node 480 is ASL
        MOVE.L #LSR,(A1)+      * node 481 is LSR
        MOVE.L #LSL,(A1)       * node 482 is LSL
        
        ADDA.W #$C,A1
        MOVE.L #ROR,(A1)+      * node 485 is ROR
        MOVE.L #ROL,(A1)       * node 486 is ROL
        
        RTS
    
DECODE_OP MOVE.B #$F,D2 * decodes the opcode at A4
          MOVEA.L TREE,A5
          MOVEA.L (A5),A1
          JSR (A1)
          RTS    
*-----------------------------------------------------------
*EA STUFF STARTS HERE
*-----------------------------------------------------------
BUILD_EA_TREE   ;BUILDS THE BINARY EA TREE FOR COMPARISONS
            ;ALL THE REGISTERS ADDED TO ARRAY
            MOVE.L  #M_DR,(A5)+
            MOVE.L  #M_AR,(A5)+
            MOVE.L  #M_DIR_A,(A5)+
            MOVE.L  #M_API,(A5)+
            MOVE.L  #M_APD,(A5)+
            ;ABSOLUTE AND IMMEDIATE ADDED TO ARRAY           
            MOVE.L  #M_AWA,(A5)+
            MOVE.L  #M_ALA,(A5)+
            MOVE.L  #$00000000,(A5)+
            MOVE.L  #M_IA,(A5)+
            RTS            
*-----------------------------------------------------------          
CHK_EA_SOURCE     ;COMPARES A SOURCE MODE FROM THE OPCODE TO THE EA TREE
    
            CLR.L   D6
            MOVE.L  A4,D6
            ADDQ    #$2,D6
            MOVEA.L D6,A4
            
            LEA     P_SPACE,A1
            MOVE    #14,D0
            TRAP    #15   
               
            CLR.L   D5
            MOVE.W  D3,D5 
            ANDI.W  #$0038,D5
            LSR.W   #$3,D5
            
            CLR.L   D6
            CMP.B   #$7,D5
            BEQ     IS_ABS_IMM            
            
            MULU.W  #$4,D5
            ADD.L   EA_TREE,D5
            MOVEA.L D5,A5
           
            CLR.L   D1
            MOVE.W  D3,D1 
            ANDI.W  #$0007,D1
                        
            MOVEA.L (A5),A6
            JSR     (A6)    
            
            LEA     P_COMMA,A1
            MOVE    #14,D0
            TRAP    #15
            
            CLR.L   D5

            RTS
*-----------------------------------------------------------
CHK_EA_DEST       ;COMPARES A DESTINATION MODE FROM THE OPCODE TO THE EA TREE

            CLR.L   D5
            CLR.L   D6
            MOVE.W  D3,D5 
            ANDI.W  #$01C0,D5
            LSR.W   #$6,D5
            
            MOVE.B  #9,D6
            CMP.B   #$7,D5
            BEQ     IS_ABS_IMM            
            
            MULU.W  #$4,D5
            ADD.L   EA_TREE,D5
            MOVEA.L D5,A5
            
            CLR.L   D1
            MOVE.W  D3,D1 
            ANDI.W  #$0E00,D1
            ROL.W   #$7,D1
         
            MOVEA.L (A5),A6
            JSR     (A6)
            
            RTS      
*-----------------------------------------------------------
IS_ABS_IMM      ;COMPARES REGISTER NUMBER FOR ABSOLUTES AND IMMEDIATES FOR PRINTING
            CMP     #9,D6
            BEQ     IS_DEST
            
            MOVE.W  D3,D5
            ANDI.W  #$0007,D5
            BRA     IS_SOURCE                        
IS_DEST                        
            MOVE.W  D3,D5
            ANDI.W  #$0E00,D5
            ROL.W   #$07,D5
IS_SOURCE
            ADDQ    #$4,D5
            MULU.W  #$04,D5
            ADD.L   EA_TREE,D5
            
            MOVEA.L D5,A5
            MOVEA.L (A5),A6
            JSR     (A6)
            
            CMP     #9,D6
            BEQ     RTS
            
            LEA     P_COMMA,A1
            MOVE    #14,D0
            TRAP    #15
            
            RTS
*-----------------------------------------------------------            
LOGIC_DEST_CHK
            CLR.L   D5
            CLR.L   D6
            MOVE.W  D3,D5
            
            
*-----------------------------------------------------------            
LOGIC_SIZE_CHK      ;CHECKS AND PRINTS SIZE (.L/.W/.B) FOR ADD/AND/SUB/ADDA/OR
            CLR.L   D5
            MOVE.W  D3,D5
            ANDI.W  #$00C0,D5
            LSR.W   #$06,D5 
            
            CMP     #00,D5
            BEQ     LOGIC_BYTE            
            CMP     #01,D5
            BEQ     LOGIC_WORD           
            CMP     #02,D5
            BEQ     LOGIC_LONG  
            CMP     #03,D5
            BEQ     LOGIC_A          
            BRA     LOGIC_DONE
LOGIC_BYTE  ;IF THE INSTRICTION IS BYTE SIZED
            LEA     P_PERIOD,A1
            MOVE.B  #14,D0
            TRAP    #15            
            LEA     P_B,A1
            MOVE.B  #14,D0
            TRAP    #15            
            BRA     LOGIC_DONE
LOGIC_WORD  ;IF THE INSTRICTION IS WORD SIZED
            LEA     P_PERIOD,A1
            MOVE.B  #14,D0
            TRAP    #15            
            LEA     P_W,A1
            MOVE.B  #14,D0
            TRAP    #15            
            BRA     LOGIC_DONE
LOGIC_LONG    ;IF THE INSTRICTION IS LONG-WORD SIZED
            LEA     P_PERIOD,A1
            MOVE.B  #14,D0
            TRAP    #15            
            LEA     P_L,A1
            MOVE.B  #14,D0
            TRAP    #15  
LOGIC_A     ;IF THE INSTRUCTION IS ADDA, PRINTS THE A
            LEA     P_A,A1
            MOVE.B  #14,D0
            TRAP    #15                        
            BTST    #$8,D5
            BEQ     LOGIC_WORD
            BRA     LOGIC_LONG                                 
LOGIC_DONE
            LEA     P_SPACE,A1
            MOVE    #14,D0
            TRAP    #15 
            RTS      
*-----------------------------------------------------------    
M_DR    ;IF MODE IS A DATA REGISTER Dn
            
            LEA     P_D,A1
            MOVE.B  #14,D0    
            TRAP    #15
    
            MOVE.B  #3,D0
            TRAP    #15 
            
            RTS
*-----------------------------------------------------------            
M_AR    ;IF MODE IS AN ADDRESS REGISTER An

            LEA     P_A,A1
            MOVE.B  #14,D0    
            TRAP    #15  

            MOVE.B  #3,D0
            TRAP    #15  
            
            RTS
*-----------------------------------------------------------
M_DIR_A ;IF MODE IS A DIRECT ADDRESS (An)

            LEA     P_OPEN_PAR,A1
            MOVE.B  #14,D0    
            TRAP    #15 
            
            LEA     P_A,A1
            MOVE.B  #14,D0    
            TRAP    #15
            
            LEA     P_CLOSE_PAR,A1
            MOVE.B  #14,D0    
            TRAP    #15
            
            RTS  
*-----------------------------------------------------------
M_API   ;IF MODE IS AN ADDRESS WITH POSTINCREMENT (An)+

            LEA     P_OPEN_PAR,A1
            MOVE.B  #14,D0    
            TRAP    #15 
            
            LEA     P_A,A1
            MOVE.B  #14,D0    
            TRAP    #15
            
            MOVE.B  #3,D0
            TRAP    #15 
            
            LEA     P_CLOSE_PAR,A1
            MOVE.B  #14,D0    
            TRAP    #15
            
            LEA     P_PLUS,A1
            MOVE.B  #14,D0    
            TRAP    #15
            
            RTS  
*-----------------------------------------------------------
M_APD   ;IF MODE IS AN ADDRESS WITH PREDECREMENT -(An)

            LEA     P_MINUS,A1
            MOVE.B  #14,D0    
            TRAP    #15

            LEA     P_OPEN_PAR,A1
            MOVE.B  #14,D0    
            TRAP    #15 
            
            LEA     P_A,A1
            MOVE.B  #14,D0    
            TRAP    #15
            
            MOVE.B  #3,D0
            TRAP    #15 
            
            LEA     P_CLOSE_PAR,A1
            MOVE.B  #14,D0    
            TRAP    #15
            
            RTS  
*-----------------------------------------------------------
M_IA    ;IF MODE IS IMMIDIATE ADDRESSING #IMM

            LEA     P_HASH,A1
            MOVE.B  #14,D0    
            TRAP    #15 
            
            LEA     P_HEX,A1
            MOVE.B  #14,D0    
            TRAP    #15
            
            CLR.L   D4
            MOVE.W  D3,D4
            ANDI.W  #$3000,D4
            ROL.W   #$04,D4            
            
            CMP     #$3,D4
            BEQ     IA_WORD
            
            CMP     #2,D4
            BEQ     IA_LONG
            
IA_END      RTS
            
IA_LONG
            MOVE.L  (A4)+,D1
            MOVE.B  #3,D0
            TRAP    #15
            BRA     IA_END
            
IA_WORD
            MOVE.W  (A4)+,D1
            MOVE.B  #3,D0
            TRAP    #15  
            BRA     IA_END          
*-----------------------------------------------------------
M_ALA   ;IF MODE IS AN ABSOLUTE LONG ADDRESS (xxx).L

            LEA     P_HEX,A1
            MOVE.B  #14,D0    
            TRAP    #15 
            
            MOVE.L  (A4)+,D1
            MOVE.B  #3,D0
            TRAP    #15

            RTS  
*-----------------------------------------------------------
M_AWA   ;IF MODE IS AN ABSOLUTE WORD ADDRESS (xxx).W

            LEA     P_HEX,A1
            MOVE.B  #14,D0    
            TRAP    #15 
            
            MOVE.W  (A4)+,D1
            MOVE.B  #3,D0
            TRAP    #15

            RTS            
*----------------------------------------------------------- 
UNDEF LEA UNDEFINED,A1
      MOVE.B #14,D0
      TRAP #15
      RTS 
      
BAD   LEA BADDATA,A1
      MOVE.B #14,D0
      TRAP #15
      RTS
      
MOVEB  LEA MB,A1
       MOVE.B #14,D0
       TRAP #15
       
       JSR   CHK_EA_SOURCE
       JSR   CHK_EA_DEST
       
       RTS 
      
MOVEQ LEA MQ,A1     ;CHANGE OPCODE SOURCE ANANLYSIS CODE*************************
      MOVE.B #14,D0
      TRAP #15
       
      CLR.L     D5
      MOVE.W    D3,D5
      ADDI.W    #$0F,D5
      
      JSR       CHK_EA_DEST
       
      RTS
       
MOVEL LEA ML,A1         ;FIGURE OUT HOW TO DEAL WITH THE MOVEQ BUG *****************
      MOVE.B #14,D0
      TRAP #15
      
      JSR   CHK_EA_SOURCE
      JSR   CHK_EA_DEST
      
      RTS
      
MOVEW LEA MW,A1
      MOVE.B #14,D0
      TRAP #15
      JSR   CHK_EA_SOURCE
      JSR   CHK_EA_DEST
      RTS
      
SUB    LEA SB,A1
       MOVE.B #14,D0
       TRAP #15
       
       JSR  LOGIC_SIZE_CHK
       JSR  CHK_EA_SOURCE
       
       RTS      
      
NOPETC MOVE.L (A4),D3   ; NOT WORKING RN***************************************
       ROL.L #8,D3
       CMP.B #$46,D3
       BEQ NOT
       
       MOVE.L (A4),D3
       BTST.L #8,D3
       BEQ LEA * this is around where the problem is************************
       BTST.L D2,D3 * is this the correct bit? should be since testbit iterates..
       BNE BAD
       ROL.L #8,D3
       ROL.L #2,D3
       ANDI.W #$03FF,D3
       CMP.W #$013A,D3
       BEQ JSR
       
       MOVE.L (A4),D3
       ROL.L #8,D3
       ROL.L #6,D3
       ANDI #$3FFF,D3
       CMP.W #$139B,D3
       BEQ RTS
       CMP.W #$139A,D3
       BEQ NOP
       BRA BAD
       RTS
       
NOT    LEA NT,A1        ;DONE, NEEDS TESTING *********************************
       MOVE.B #14,D0
       TRAP #15
       JSR  LOGIC_SIZE_CHK
       JSR  CHK_EA_SOURCE
       RTS     

LEA    LEA LA,A1        ;NOT WORKING RN*******************************************
       MOVE.B #14,D0
       TRAP #15
       RTS

JSR    LEA JS,A1        ;NOT WORKING RN************************************
       MOVE.B #14,D0
       TRAP #15
       RTS
RTS    LEA RT,A1       ;NOT WORKING RN*********************************
       MOVE.B #14,D0
       TRAP #15
       RTS

NOP    LEA NP,A1       ;NOT WORKING RN*********************************
       MOVE.B #14,D0
       TRAP #15
       RTS   
       
ADDQ   LEA AQ,A1
       MOVE.B #14,D0
       TRAP #15
       RTS

AND    LEA AN,A1
       MOVE.B #14,D0
       TRAP #15
       RTS
       
ADD    LEA AD,A1
       MOVE.B #14,D0
       TRAP #15
       JSR  LOGIC_SIZE_CHK
       JSR  CHK_EA_SOURCE
       RTS

BRA   LEA BR,A1
      MOVE.B #14,D0
      TRAP #15
      RTS

BEQ   LEA BE,A1
       MOVE.B #14,D0
       TRAP #15
       RTS
       
BGT   LEA BG,A1
       MOVE.B #14,D0
       TRAP #15
       RTS
       
BLE   LEA BL,A1
       MOVE.B #14,D0
       TRAP #15
       RTS
       
ASR   LEA AR,A1
       MOVE.B #14,D0
       TRAP #15
       RTS
       
ASL   LEA AL,A1
       MOVE.B #14,D0
       TRAP #15
       RTS
       
LSR   LEA LR,A1
       MOVE.B #14,D0
       TRAP #15
       RTS
       
LSL   LEA LL,A1
       MOVE.B #14,D0
       TRAP #15
       RTS
       
ROR   LEA RR,A1
       MOVE.B #14,D0
       TRAP #15
       RTS
       
ROL   LEA RL,A1
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
EA_TREE DC.L    $0500  
* string storage
CR EQU $0D
LF EQU $09
NEWLINE DC.B '',CR,LF,0
PROMPT1  DC.B  'Please enter the memory value of the start of the program: ',0
PROMPT2  DC.B  'Please enter the memory value of the end of the program: ',0
UNDEFINED DC.B 'The program should never reach this state.',0
BADDATA  DC.B 'The data on line ____ is not a valid opcode.',CR,LF,0
MQ DC.B 'MOVEQ',0
MB  DC.B 'MOVE.B',0
ML  DC.B 'MOVE.L/MOVEA.L',0
MW  DC.B 'MOVE.W/MOVEA.W',0
NP DC.B 'NOP',0
NT DC.B 'NOT',0
AQ DC.B 'ADDQ',0
AN DC.B 'AND',0
AD DC.B 'ADD',0
BR DC.B 'BRA',0
BE DC.B 'BEQ',0
BG DC.B 'BGT',0
BL DC.B 'BLE',0
AR DC.B 'ASR',0
AL DC.B 'ASL',0
LA DC.B 'LEA',0
LR DC.B 'LSR',0
LL DC.B 'LSL',0
RR DC.B 'ROR',0
RL DC.B 'ROL',0
SB DC.B 'SUB',0
JS DC.B 'JSR',0
RT DC.B 'RTS',0

;necessary symbols for displaying EA's
P_D         DC.B    'D',0
P_A         DC.B    'A',0
P_B         DC.B    'B',0
P_W         DC.B    'W',0
P_L         DC.B    'L',0
P_PERIOD    DC.B    '.',0
P_OPEN_PAR  DC.B    '(',0
P_CLOSE_PAR DC.B    ')',0
P_PLUS      DC.B    '+',0
P_MINUS     DC.B    '-',0
P_HASH      DC.B    '#',0
P_HEX       DC.B    '$',0
P_BINARY    DC.B    '%',0
P_COMMA     DC.B    ',',0
P_SPACE     DC.B    ' ',0
NXT_LINE    DC.B    '',CR,LF,0

    END    START









*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
