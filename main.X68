*-----------------------------------------------------------
* Title      : motorola 68k disassembler prototype
* Written by : Harper Hults, Camas Collins
* Date       : 5/29/22
* Description: allows for decoding of opcodes.
*-----------------------------------------------------------
    ORG    $1000
START:
        *JSR        WELCOME
        MOVEA.L     #$5000,A2    * for testing
        MOVEA.L     #$5157,A3
        MOVEA.L     #$00000500,A5
        MOVEA.L     A2,A4      * does this need to be W depending on where in mem start is?
        JSR         BUILD_EA_TREE
        JSR         BUILDTREE
LOOP
        CLR.B       D2
        JSR         BLOCK_OUT
        MOVE.B      #14,D0
        
        LEA         IOMSG,A1
        TRAP        #15
        
        MOVE.B      #2,D0
        TRAP        #15
        BRA         LOOP    
    
NEXTLINE
        CLR.L       D4
        CLR.L       D5
        CLR.L       D6
        MOVE.W      A4,D4
        JSR         PRINTHEX 
        JSR         DECODE_OP
        CMP.L       A4,A3
        BLE         DONE
        LEA         NXT_LINE,A1
        MOVE        #13,D0
        TRAP        #15
        RTS

BLOCK_OUT
        MOVE.B      D2,-(SP)
        JSR         NEXTLINE
        MOVE.B      (SP)+,D2    
        CMPA.L      END,A4
        BLE         DONE
        ADDQ        #1,D2
        CMP.B       #$1F,D2
        BNE         BLOCK_OUT
        RTS

DONE                * end program
        LEA         NXT_LINE,A1
        MOVE        #13,D0
        TRAP        #15

        LEA DONEMSG,A1
        MOVE.B #14,D0
        TRAP #15
        MOVE.B      #9,D0
        TRAP        #15
    
WELCOME
        LEA         PROMPT1,A1  * get start memory value, put in A2
        MOVE.B      #14,D0
        TRAP        #15
    
        JSR         GETINPUT
        MOVE.L      D3,BEGIN
    
        LEA         PROMPT2,A1  * get end memory value, put in D3
        MOVE.B      #14,D0
        TRAP        #15
    
        JSR         GETINPUT
        MOVE.L      D3,END
        RTS
    
BUILDTREE
        MOVE.W      #0,D0
        MOVEA.L     TREE,A1
BLDLOOP 
        MOVE.L      #UNDEF,(A1)+    * initialize whole tree to undefined
        ADDQ        #1,D0
        CMP.W       #513,D0
        BNE         BLDLOOP
        
        MOVEA.L     TREE,A1

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
        MOVE.L #OR,(A1)+      * OR GOES AT 23
        MOVE.L #SUB,(A1)+      * 24 is SUB
        
        ADDA.W #8,A1           * should put us at TREE + $6C
        MOVE.L #AND,(A1)+      * node 27 is AND
        MOVE.L #ADD,(A1)+      * node 28 is ADD
        MOVE.L #SHIFT_TEST,(A1)+  * 29 is a decision node
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
    
DECODE_OP 
        MOVE.B      #$F,D2 * decodes the opcode at A4
        MOVEA.L     TREE,A5
        MOVEA.L     (A5),A1
        JSR         (A1)
        RTS    
*-----------------------------------------------------------
*EA STUFF STARTS HERE
*-----------------------------------------------------------
;BUILDS THE BINARY EA TREE FOR COMPARISONS
BUILD_EA_TREE   
            ;ALL THE REGISTERS ADDED TO ARRAY
            MOVE.L  #M_DR,(A5)+
            MOVE.L  #M_AR,(A5)+
            MOVE.L  #M_DIR_A,(A5)+
            MOVE.L  #M_API,(A5)+
            MOVE.L  #M_APD,(A5)+
            ;ABSOLUTE AND IMMEDIATE ADDED TO ARRAY           
            MOVE.L  #M_AWA,(A5)+
            MOVE.L  #M_ALA,(A5)+
            MOVE.L  #$00000000,(A5)+ ;added to simplify algorithm
            MOVE.L  #$00000000,(A5)+ ;added to simplify algorithm
            MOVE.L  #M_IA,(A5)+
            RTS            
*-----------------------------------------------------------          
;COMPARES A SOURCE MODE FROM THE OPCODE TO THE EA TREE
CHK_EA_SOURCE         
            CLR.L   D5
            MOVE.L  A4,D5
            ADDQ    #$2,D5
            MOVEA.L D5,A4  
               
            CLR.L   D5
            MOVE.W  D3,D5 
            ANDI.W  #$0038,D5
            LSR.W   #$3,D5
            
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
            
            CLR.L   D5

            RTS
*-----------------------------------------------------------
;COMPARES A DESTINATION MODE FROM THE OPCODE TO THE EA TREE FOR MOVE INSTRUCTIONS
CHK_EA_DEST       
            CLR.L   D5
            MOVE.W  D3,D5 
            ANDI.W  #$01C0,D5
            LSR.W   #$6,D5
            
            MOVE.L  #9,D6
            
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
;COMPARES REGISTER NUMBER FOR ABSOLUTES AND IMMEDIATES FOR PRINTING
IS_ABS_IMM      
            MOVE.W  D3,D5
            CMP     #9,D6
            BEQ     IS_DEST                   
            ANDI.W  #$0007,D5
            BRA     IS_SOURCE                        
IS_DEST    
            ANDI.W  #$0E00,D5
            ROL.W   #$07,D5
            BRA     IS_SOURCE             
IS_SOURCE
            ADDQ    #$4,D5
            MULU.W  #$04,D5
            ADDQ    #$4,D5
            ADD.L   EA_TREE,D5
            
            MOVEA.L D5,A5
            MOVEA.L (A5),A6
            JSR     (A6)
            
            RTS
*-----------------------------------------------------------            
LOGIC_PARAMETER_CHK
            CLR.L   D5
            CLR.L   D1

            MOVE.W  D3,D5
            BTST    #$08,D5
            BEQ     LOGIC_TOEA
            ;IF THE DESTINATION IS A REGISTER
            MOVE.W  D3,D1
            ANDI.W  #$0E00,D1
            ROL.W   #$07,D1
            JSR     M_DR 
            CLR.L   D1            
            LEA     P_COMMA,A1
            MOVE    #14,D0
            TRAP    #15           
            JSR     CHK_EA_SOURCE
            RTS           
LOGIC_TOEA  ;IF THE DESTINATION IS AN ADDRESS            
            JSR     CHK_EA_SOURCE            
            LEA     P_COMMA,A1
            MOVE    #14,D0
            TRAP    #15 
            MOVE.W  D3,D1
            ANDI.W  #$0E00,D1
            ROL.W   #$07,D1          
            JSR     M_DR 
            CLR.L   D1            
            RTS
*-----------------------------------------------------------            
;CHECKS AND PRINTS SIZE (.L/.W/.B)FOR ADD/AND/SUB/ADDA/OR/NOT
LOGIC_SIZE_CHK      
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
            BRA     LOGIC_DONE
LOGIC_A     ;IF THE INSTRUCTION IS ADDA, PRINTS THE A
            LEA     P_A,A1
            MOVE.B  #14,D0
            TRAP    #15
            MOVE.L  #$08,D6                        
            BTST    #$8,D5
            BNE     LOGIC_WORD
            BRA     LOGIC_LONG                                 
LOGIC_DONE
            LEA     P_SPACE,A1
            MOVE    #14,D0
            TRAP    #15
             
            RTS   
*-----------------------------------------------------------  
SHIFT_REG_PARAMETER_CHK  
            ;ROTATION VALUE CHECK
            CLR.L   D5
            MOVE.L  A4,D5
            ADDQ    #$2,D5
            MOVEA.L D5,A4
            CLR.L   D5
            MOVE.W  D3,D5
            ANDI.W  #$0018,D5
            LSR.W   #3,D5
            CMP     #0,D5
            BEQ     SHIFT_ASD
            CMP     #1,D5
            BEQ     SHIFT_LSD
            CMP     #2,D5
            BEQ     NOT_MY_PROBLEM
            CMP     #3,D5
            BEQ     SHIFT_ROD
SHIFT_ASD
            BTST    #$8,D3
            BNE     ASD_LEFT
            LEA     AR,A1
            MOVE    #14,D0
            TRAP    #15
            BRA     SHIFT_SIZE
ASD_LEFT
            LEA     AL,A1
            MOVE    #14,D0
            TRAP    #15
            BRA     SHIFT_SIZE            
SHIFT_LSD
            BTST    #$8,D3
            BNE     LSD_LEFT
            LEA     LR,A1
            MOVE    #14,D0
            TRAP    #15
            BRA     SHIFT_SIZE
LSD_LEFT
            LEA     LL,A1
            MOVE    #14,D0
            TRAP    #15
            BRA     SHIFT_SIZE
SHIFT_ROD
            BTST    #$8,D3
            BNE     ROD_LEFT
            LEA     RR,A1
            MOVE    #14,D0
            TRAP    #15
            BRA     SHIFT_SIZE
ROD_LEFT
            LEA     RL,A1
            MOVE    #14,D0
            TRAP    #15
SHIFT_SIZE
            LEA     P_PERIOD,A1
            MOVE.B  #14,D0
            TRAP    #15
            CLR.L   D5
            MOVE.W  D3,D5
            ANDI.W  #$00C0,D5
            LSR.W   #6,D5
            CMP     #0,D5
            BEQ     SHIFT_ISBYTE
            CMP     #1,D5
            BEQ     SHIFT_ISWORD
            LEA     P_L,A1
            MOVE.B  #14,D0
            TRAP    #15
            BRA     SHIFT_POSTSIZE
SHIFT_ISBYTE
            LEA     P_B,A1
            MOVE.B  #14,D0
            TRAP    #15
            BRA     SHIFT_POSTSIZE
SHIFT_ISWORD  
            LEA     P_W,A1
            MOVE.B  #14,D0
            TRAP    #15 
SHIFT_POSTSIZE
            LEA     P_SPACE,A1
            MOVE.B  #14,D0
            TRAP    #15  
            BTST    #5,D3
            BNE     SHIFT_ISREG
            MOVE.W  D3,D1
            ANDI.W  #$0E00,D1
            ROL.W   #$07,D1
            LEA     P_HASH,A1
            MOVE.B  #14,D0
            TRAP    #15
            LEA     P_HEX,A1
            MOVE.B  #14,D0
            TRAP    #15
            MOVE.W  D3,D1
            ANDI.W  #$0E00,D1
            ROL.W   #$07,D1
            MOVE.B  #3,D0
            TRAP    #15
            BRA     SHIFT_END
SHIFT_ISREG
            MOVE.W  D3,D1
            ANDI.W  #$0E00,D1
            ROL.W   #$07,D1
            JSR     M_DR
            BRA     SHIFT_END 
NOT_MY_PROBLEM
            JSR     BAD
SHIFT_END   
            LEA     P_COMMA,A1
            MOVE.B  #14,D0
            TRAP    #15 
            CLR.L   D1
            MOVE.W  D3,D1
            ANDI.W  #$0007,D1
            JSR     M_DR
                    
            RTS 
*-----------------------------------------------------------  
SHIFT_MEM_PARAMETER_CHK
            ;SIZE CHECK -> REGISTER INFO -> PRINT
            LEA     P_PERIOD,A1
            MOVE.B  #14,D0
            TRAP    #15
            LEA     P_W,A1
            MOVE.B  #14,D0
            TRAP    #15
            LEA     P_SPACE,A1
            MOVE.B  #14,D0
            TRAP    #15
            JSR     CHK_EA_SOURCE
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
            
            MOVE.B  #3,D0
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
            MOVE.W  D3,D4   
            CMP     #6,D6
            BEQ     IA_LOGIC_SIZE
            CMP     #8,D6
            BEQ     IA_ADDA_SIZE
            
            ANDI.W  #$3000,D4
            ROL.W   #4,D4
            CMP     #$3,D4
            BEQ     IA_WORD            
            CMP     #2,D4
            BEQ     IA_LONG    
            
IA_LOGIC_SIZE
            ANDI.W  #$00C0,D4
            LSR.W   #6,D4
            CMP     #$1,D4
            BEQ     IA_WORD            
            CMP     #2,D4
            BEQ     IA_LONG   
IA_ADDA_SIZE 
            ANDI.W  #$0100,D4
            LSR.W   #8,D4
            CMP     #$0,D4
            BEQ     IA_WORD            
            CMP     #1,D4
            BEQ     IA_LONG                             
IA_LONG
            MOVE.L  (A4)+,D4
            JSR PRINTHEX
            RTS            
IA_WORD
            MOVE.W  (A4)+,D4
            JSR PRINTHEX
            RTS          
*-----------------------------------------------------------
M_ALA   ;IF MODE IS AN ABSOLUTE LONG ADDRESS (xxx).L
            LEA     P_HEX,A1
            MOVE.B  #14,D0    
            TRAP    #15 
            
            MOVE.L  (A4)+,D4
            JSR PRINTHEX

            RTS  
*-----------------------------------------------------------
M_AWA   ;IF MODE IS AN ABSOLUTE WORD ADDRESS (xxx).W
            LEA     P_HEX,A1
            MOVE.B  #14,D0    
            TRAP    #15 
            
            MOVE.W  (A4)+,D4
            JSR PRINTHEX

            RTS    
*-----------------------------------------------------------
*INSTRUCTION PRINTING START HERE         
*----------------------------------------------------------- 
UNDEF  
       LEA      UNDEFINED,A1
       MOVE.B   #14,D0
       TRAP     #15
       RTS 
*-----------------------------------------------------------      
BAD    
       LEA      BADDATA,A1
       MOVE.B   #14,D0
       TRAP     #15
       LEA      P_HEX,A1
       MOVE.B   #14,D0    
       TRAP     #15
       MOVE.L   D3,D4
       JSR      PRINTHEX
       ADD.L    #$4,A4
       RTS
*-----------------------------------------------------------      
MOVEB  
       LEA      MB,A1
       MOVE.B   #14,D0
       TRAP     #15
       
       JSR      CHK_EA_SOURCE
       LEA      P_COMMA,A1
       MOVE     #14,D0
       TRAP     #15
       JSR      CHK_EA_DEST
       
       RTS 
*-----------------------------------------------------------      
MOVEQ  
       LEA      MQ,A1     
       MOVE.B   #14,D0
       TRAP     #15
       
       CLR.L    D1
       MOVE.W   D3,D1
       ADDI.W   #$00FF,D1
       MOVE.B   #3,D0
       TRAP     #15
       
       CLR.L    D1
       MOVE.W   D3,D1
       ANDI.W   #$0E00,D1
       ROL.W    #$07,D1
      
       LEA      P_COMMA,A1
       MOVE     #14,D0
       TRAP     #15         
       
       JSR      M_DR
       
       CLR.L   D5
       MOVE.L  A4,D5
       ADDQ    #$2,D5
       MOVEA.L D5,A4
       
       RTS
*-----------------------------------------------------------       
MOVEL 
       CLR.L    D5
       MOVE.W   D3,D5
       ANDI.W   #$01C0,D5
       LSR.W    #$06,D5
       CMP.B    #1,D5
       BEQ      MOVEAL      
       LEA      ML,A1        
BREAKL      
       MOVE.B   #14,D0
       TRAP     #15
       JSR      CHK_EA_SOURCE
       LEA      P_COMMA,A1
       MOVE     #14,D0
       TRAP     #15
       JSR      CHK_EA_DEST      
       RTS     
MOVEAL 
       LEA      MAL,A1
       BRA      BREAKL
*-----------------------------------------------------------      
MOVEW 
       CLR.L    D5
       MOVE.W   D3,D5
       ANDI.W   #$01C0,D5
       LSR.W    #$06,D5
       CMP.B    #1,D5
       BEQ      MOVEAW      
       LEA      MW,A1
BREAKW
       MOVE.B   #14,D0
       TRAP     #15
       JSR      CHK_EA_SOURCE
       LEA      P_COMMA,A1
       MOVE     #14,D0
       TRAP     #15
       JSR      CHK_EA_DEST
       RTS
MOVEAW 
       LEA      MAW,A1
       BRA      BREAKW
*-----------------------------------------------------------      
SUB    
       LEA      SB,A1
       MOVE.B   #14,D0
       TRAP     #15       
       JSR      LOGIC_SIZE_CHK 
       MOVE.L   #6,D6  
       JSR      LOGIC_PARAMETER_CHK    
       RTS      
*-----------------------------------------------------------      
NOPETC 
       MOVE.W   (A4),D3
       CLR.L    D5
       MOVE.W   D3,D5
       ROL.W    #8,D5
       CMP.B    #$46,D5
       BEQ      NOT
       
       MOVE.W   D3,D5
       BTST     #$8,D3
       BNE      LEA 
       BTST     D2,D3 
       BEQ      BAD
       ROR.W    #6,D5
       ANDI.W   #$03FF,D5
       CMP.W    #$013A,D5
       BEQ      JSR
       
       MOVE.W   D3,D5
       ROR.W    #2,D5
       ANDI     #$3FFF,D5
       CMP.W    #$139D,D5
       BEQ      RTS
       CMP.W    #$139C,D5
       BEQ      NOP
       BRA      BAD
       RTS
*-----------------------------------------------------------       
NOT    
       LEA      NT,A1        
       MOVE.B   #14,D0
       TRAP     #15
       JSR      LOGIC_SIZE_CHK
       MOVE.L   #6,D6
       JSR      CHK_EA_SOURCE
       RTS     
*----------------------------------------------------------- 
OR
       LEA      OAR,A1
       MOVE.B   #14,D0
       TRAP     #15
       JSR      LOGIC_SIZE_CHK 
       MOVE.L   #6,D6  
       JSR      LOGIC_PARAMETER_CHK 
       RTS
*-----------------------------------------------------------
LEA    
       LEA      LA,A1
       MOVE.B   #14,D0
       TRAP     #15
       MOVE.W   (A4),D3
       JSR      CHK_EA_SOURCE
       LEA      P_COMMA,A1
       MOVE     #14,D0
       TRAP     #15
       CLR.L   D1
       MOVE.W  D3,D1 
       ANDI.W  #$0E00,D1
       ROL.W   #$7,D1
       JSR M_AR

       RTS
*-----------------------------------------------------------
JSR    
       LEA      JS,A1       
       MOVE.B   #14,D0
       TRAP     #15
       MOVE.W   (A4),D3
       JSR      CHK_EA_SOURCE
       RTS
*-----------------------------------------------------------       
RTS    
       LEA      RT,A1       
       MOVE.B   #14,D0
       TRAP     #15
       RTS
*-----------------------------------------------------------
NOP    
       LEA      NP,A1       
       MOVE.B   #14,D0
       TRAP     #15
       CLR.L    D5
       MOVE.L   A4,D5
       ADDQ     #$2,D5
       MOVEA.L  D5,A4
       RTS   
*-----------------------------------------------------------       
ADDQ   
       LEA      AQ,A1
       MOVE.B   #14,D0
       TRAP     #15
       
       CLR.L    D1
       MOVE.W   D3,D1
       ANDI.W   #$0E00,D1
       ROL.W    #$07,D1

       LEA      P_HASH,A1
       MOVE.B   #14,D0    
       TRAP     #15 
          
       LEA      P_HEX,A1
       MOVE.B   #14,D0    
       TRAP     #15
       
       MOVE.B   #3,D0
       TRAP     #15
       CLR.L    D1
       
       LEA      P_COMMA,A1
       MOVE     #14,D0
       TRAP     #15
       MOVE.L   #6,D6
       JSR      CHK_EA_SOURCE
       
       RTS
*-----------------------------------------------------------
AND    
       LEA      AN,A1
       MOVE.B   #14,D0
       TRAP     #15       
       JSR      LOGIC_SIZE_CHK
       MOVE.L   #6,D6
       JSR      LOGIC_PARAMETER_CHK  
       RTS
*-----------------------------------------------------------       
ADD    
       LEA      AD,A1
       MOVE.B   #14,D0
       TRAP     #15
       JSR      LOGIC_SIZE_CHK
       CMP      #8,D6
       BEQ      IS_ADDA
       MOVE.L   #6,D6
       JSR      LOGIC_PARAMETER_CHK
       RTS
IS_ADDA
       JSR      CHK_EA_SOURCE
       LEA      P_COMMA,A1
       MOVE     #14,D0
       TRAP     #15
       CLR.L    D1
       MOVE.W   D3,D1
       ANDI.W   #$0E00,D1
       ROL.W    #$07,D1
       JSR      M_AR
       RTS
*-----------------------------------------------------------
BRA    
       LEA      BR,A1
       MOVE.B   #14,D0
       TRAP     #15
       JSR PRINT_DISPLACEMENT
       RTS
*-----------------------------------------------------------
BEQ    
       LEA      BE,A1
       MOVE.B   #14,D0
       TRAP     #15
       JSR PRINT_DISPLACEMENT
       RTS
*-----------------------------------------------------------       
BGT    
       LEA      BG,A1
       MOVE.B   #14,D0
       TRAP     #15
       JSR PRINT_DISPLACEMENT
       RTS
*-----------------------------------------------------------       
BLE    LEA      BL,A1
       MOVE.B   #14,D0
       TRAP     #15
       JSR PRINT_DISPLACEMENT
       RTS
*-----------------------------------------------------------
PRINT_DISPLACEMENT
      MOVE.W (A4),D3
      CMP.B #0,D3
      BEQ WORDDISP
      CMP.B #$FF,D3
      BEQ LONGDISP
      CLR.L D4
      MOVE.B D3,D4
      EXT.W D4
      ADDA.L #2,A4
      ADD.W A4,D4
      JSR PRINTHEX
      RTS
WORDDISP
     ADDA.L #2,A4
     MOVE.L A4,D4
     ADD.W (A4)+,D4
     JSR PRINTHEX
     RTS
LONGDISP
     ADDA.L #2,A4
     MOVE.L A4,D4
     ADD.L (A4)+,D4
     JSR PRINTHEX
     RTS           
*-----------------------------------------------------------       
ASR    
       LEA      AR,A1
       MOVE.B   #14,D0
       TRAP     #15
       JSR      SHIFT_MEM_PARAMETER_CHK
       RTS
*-----------------------------------------------------------       
ASL    
       LEA      AL,A1
       MOVE.B   #14,D0
       TRAP     #15
       JSR      SHIFT_MEM_PARAMETER_CHK
       RTS
*-----------------------------------------------------------       
LSR    
       LEA      LR,A1
       MOVE.B   #14,D0
       TRAP     #15
       JSR      SHIFT_MEM_PARAMETER_CHK
       RTS
*-----------------------------------------------------------       
LSL    
       LEA      LL,A1
       MOVE.B   #14,D0
       TRAP     #15
       JSR      SHIFT_MEM_PARAMETER_CHK
       RTS
*-----------------------------------------------------------       
ROR    
       LEA      RR,A1
       MOVE.B   #14,D0
       TRAP     #15
       JSR      SHIFT_MEM_PARAMETER_CHK
       RTS
*-----------------------------------------------------------       
ROL    
       LEA      RL,A1
       MOVE.B   #14,D0
       TRAP     #15
       JSR      SHIFT_MEM_PARAMETER_CHK
       RTS
*-----------------------------------------------------------
SHIFT_TEST
       CLR.L    D3
       MOVE.W   (A4),D3
       MOVE.W   D3,D5
       ROR.W    #6,D5
       ANDI.B   #03,D5
       CMP.B    #3,D5
       BEQ      TESTBIT
       JSR      SHIFT_REG_PARAMETER_CHK
       RTS
       
*-----------------------------------------------------------
TESTBIT
       CLR.L    D3
       MOVE.W   (A4),D3
       MOVE.L   A5,D1
       SUB.L    TREE,D1
       ASL.L    #1,D1
       MOVEA.L  D1,A5
       BTST.L   D2,D3
       BEQ      IS_ZERO
       BRA      NOT_ZERO
    
IS_ZERO   * if bit D2 of (A4) is zero (go left on tree)
       SUBQ     #1,D2
       ADDA.W   #4,A5
       ADDA.L   TREE,A5
       MOVEA.L  (A5),A1
       JSR      (A1)
       RTS

NOT_ZERO  * if bit D2 of (A4) is one (go right on tree)
       SUBQ     #1,D2
       ADDA.W   #8,A5
       ADDA.L   TREE,A5
       MOVEA.L  (A5),A1
       JSR      (A1)
       RTS   
* ----------------------------------------------------------
* GETINPUT: gets hex value in ascii from user, puts it in D3   
GETINPUT 
       MOVE.B   #2,D0     * get user string
       TRAP     #15      

LOOP1  
       LSL.L    #4,D3       * get single char from string
       MOVE.B   (A1)+,D2
       SUBI     #1,D1
       BRA      HEXVAL       
       
HEXVAL 
       CMPI.B   #$39,D2     * convert ascii char value to hex
       BGT.B    LETTER
       SUBI.B   #$30,D2
       BRA      WRITE
    
LETTER 
       SUBI.B   #$37,D2
       BRA      WRITE
    
WRITE                     * write hex val to D3
       ADD.B    D2,D3
       CMPI.B   #0,D1
       BNE      LOOP1
       RTS
*-----------------------------------------------------------
PRINTHEX 
         MOVE.B #1,D5
NEXTDIG  
         MOVE.L D4,D1
         ASL.B  #2,D5
         ROL.L  D5,D1
         ASR.B  #2,D5
         
         AND.L  #$0000000F,D1
         CMP.B  #$F,D1
         BEQ    IF_F
         CMP.B  #$E,D1
         BEQ    IF_E
         CMP.B  #$D,D1
         BEQ    IF_D
         CMP.B  #$C,D1
         BEQ    IF_C
         CMP.B  #$B,D1
         BEQ    IF_B
         CMP.B  #$A,D1
         BEQ    IF_A
         
         MOVE.B #3,D0
         TRAP   #15
LP_INC         
         ADDQ   #1,D5
         CMP.B  #8,D5
         BLE    NEXTDIG
         RTS
         
IF_A     LEA    P_A,A1
         MOVE.B #14,D0
         TRAP   #15
         BRA    LP_INC     
IF_B     
         LEA    P_B,A1
         MOVE.B #14,D0
         TRAP   #15
         BRA    LP_INC
IF_C     
         LEA    P_C,A1
         MOVE.B #14,D0
         TRAP   #15
         BRA    LP_INC
IF_D     
         LEA    P_D,A1
         MOVE.B #14,D0
         TRAP   #15
         BRA    LP_INC
IF_E     
         LEA    P_E,A1
         MOVE.B #14,D0
         TRAP   #15
         BRA    LP_INC
IF_F 
         LEA    P_F,A1
         MOVE.B #14,D0
         TRAP   #15
         BRA    LP_INC
*-----------------------------------------------------------

    
* var storage
TREE        DC.L    $7000  
EA_TREE     DC.L    $0500
BEGIN       DS.L    $5000
END         DS.L    $6000  
* string storage
CR          EQU     $0D
LF          EQU     $09
NEWLINE     DC.B    '',CR,LF,0
PROMPT1     DC.B    'Please enter the memory value of the start of the program: ',0
PROMPT2     DC.B    'Please enter the memory value of the end of the program: ',0
UNDEFINED   DC.B    'The program should never reach this state.',0
DONEMSG     DC.B    'You have reached the end of the disassembler.',0
IOMSG       DC.B    'Press enter to see the next screen of data.',0
BADDATA     DC.B    ' Data ',0
MQ          DC.B    ' MOVEQ ',0
MB          DC.B    ' MOVE.B ',0
MAL         DC.B    ' MOVEA.L ',0
MAW         DC.B    ' MOVEA.W ',0
ML          DC.B    ' MOVE.L ',0
MW          DC.B    ' MOVE.W ',0
NP          DC.B    ' NOP',0
NT          DC.B    ' NOT',0
AQ          DC.B    ' ADDQ ',0
AN          DC.B    ' AND',0
AD          DC.B    ' ADD',0
BR          DC.B    ' BRA ',0
BE          DC.B    ' BEQ ',0
BG          DC.B    ' BGT ',0
BL          DC.B    ' BLE ',0
AR          DC.B    ' ASR',0
AL          DC.B    ' ASL',0
LA          DC.B    ' LEA ',0
LR          DC.B    ' LSR',0
LL          DC.B    ' LSL',0
RR          DC.B    ' ROR',0
RL          DC.B    ' ROL',0
SB          DC.B    ' SUB',0
JS          DC.B    ' JSR ',0
RT          DC.B    ' RTS',0
OAR         DC.B    ' OR',0

;necessary symbols for displaying EA's
P_A         DC.B    'A',0
P_B         DC.B    'B',0
P_C         DC.B    'C',0
P_D         DC.B    'D',0
P_E         DC.B    'E',0
P_F         DC.B    'F',0
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

            END     START













*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
