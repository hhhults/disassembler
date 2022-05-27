*-----------------------------------------------------------
* Title      : 422 FINAL PROJECT TEST 2.0
* Written by : CAMAS COLLINS 
* Date       : 5/24/2022
* Description:
*-----------------------------------------------------------

;carrage return and line feed txt
CR          EQU $0D
LF          EQU $0A

;necessary symbols for displaying EA's
P_D         DC.B    'D',0
P_A         DC.B    'A',0
P_OPEN_PAR  DC.B    '(',0
P_CLOSE_PAR DC.B    ')',0
P_PLUS      DC.B    '+',0
P_MINUS     DC.B    '-',0
P_HASH      DC.B    '#',0
P_HEX       DC.B    '$',0
P_BINARY    DC.B    '%',0
P_COMMA     DC.B    ',',0
P_SPACE     DC.B    ' ',0
NXT_LINE    DC.B    CR,LF,0

*-----------------------------------------------------------
            ORG    $1000
START:      
            ;TESTING CODE ON NEXT LINES

            MOVEA.L #$00004000,A4
            MOVE.W  #$2C7C,(A4)+
            MOVE.L  #$00002E06,(A4)
            MOVEA.L #$00004000,A4
            MOVE.L  #$00002C7C,D3       
            MOVEA.L #$00002000,A5              ;TEMP ARRAY STORAGE LOCATION            
      
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
            MOVE.L  #M_IA,(A5)+
                        
*-----------------------------------------------------------          
CHK_EA_SOURCE     ;COMPARES A SOURCE MODE FROM THE OPCODE TO THE EA TREE
    
            CLR.L   D6
            MOVE.L  A4,D6
            ADDQ    #$4,D6
            MOVEA.L D6,A4
            
            LEA     P_SPACE,A1
            MOVE    #14,D0
            TRAP    #15   
               
            CLR.L   D5
            MOVE.W  D3,D5 
            ANDI.W  #$0028,D5
            LSR.W   #$3,D5
            
            CLR.L   D6
            CMP.B   #$7,D5
            BEQ     IS_ABS_IMM            
            
            MULU.W  #$4,D5
            ADDI.W  #$2000,D5
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

            JMP     CHK_EA_DEST                      
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
            ADDI.W  #$2000,D5
            MOVEA.L D5,A5
            
            CLR.L   D1
            MOVE.W  D3,D1 
            ANDI.W  #$0E00,D1
            ROL.W   #$7,D1
         
            MOVEA.L (A5),A6
            JSR     (A6)
            
            LEA     NXT_LINE,A1
            MOVE    #14,D0
            
            JMP     DONE    ;TEMP INSTRUCTION DURRING TESTING       
*-----------------------------------------------------------
IS_ABS_IMM      ;COMPARES 
            CMP     #9,D6
            BNE     IS_DEST
            
            LEA     P_HASH,A1
            MOVE.B  #14,D0    
            TRAP    #15 
            
IS_DEST            
            BTST    D6,D3
            BNE     M_ALA
            ADDQ    #2,D6

            BTST    D6,D3
            BNE     M_IA
            SUBQ    #1,D6
            
            BTST    D6,D3
            BEQ     M_AWA

            ;add invalid branch here             
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
C_MOVE_EA   ;CHECK MOVE INSTRUCTION EA

            MOVE.B  #14,D0  
*-----------------------------------------------------------
DONE
            MOVE.B  #9,D0
            TRAP    #15

    END    START       




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
