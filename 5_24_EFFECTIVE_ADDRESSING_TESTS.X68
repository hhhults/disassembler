*-----------------------------------------------------------
* Title      : 422 FINAL PROJECT TEST 2.0
* Written by : CAMAS COLLINS 
* Date       : 5/24/2022
* Description:
*-----------------------------------------------------------

*NOTES: 
*   MOVE THE NEW LINE CARRAGE TO AFTER THE DESTINATION LOOP 
*   TO MOVE TO THE LABEL IN THE ADDRESS REGISTER - JSR (An)
*   DONT FORGET TO RTS AT THE END OF EACH SUBROUTINE



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
NXT_LINE    DC.B    CR,LF,0


*-----------------------------------------------------------

            ORG    $1000
START:      

            MOVE.L  #%0010111000000110,D3      ;MOVE.L  D6,D7 FOR TESTING
            MOVEA.L #$00002000,A5
            
      
*-----------------------------------------------------------
BUILD_EA_TREE   ;BUILDS THE BINARY EA TREE FOR COMPARISONS
            
            MOVE.L  #M_DR,(A5)+
            MOVE.L  #M_AR,(A5)+
            MOVE.L  #M_DIR_A,(A5)+
            MOVE.L  #M_API,(A5)+
            MOVE.L  #M_APD,(A5)+
            MOVE.L  #M_IA,(A5)+
            MOVE.L  #M_ALA,(A5)+
            MOVE.L  #M_AWA,(A5)+
            
*-----------------------------------------------------------          
CHK_EA_SOURCE     ;COMPARES A SOURCE MODE FROM THE OPCODE TO THE EA TREE
            CLR.L   D4
            CLR.L   D5
            CLR.L   D6
            MOVE.B  #3,D4
            MOVE.B  #6,D6
EA_SOURCE_LOOP    
            BTST    D4,D3
            BNE     SET_BIT
EA_SOURCE_BACK
            ADDI.B  #1,D4
            CMP     D6,D4
            BLT     EA_SOURCE_LOOP   
            
            LSR.L   #$3,D5
            
            CMP.B   #$7,D5
            BEQ     IS_ABS_IMM
            
            MULU.W  #$4,D5
            ADDI.W  #$2000,D5
            MOVEA.L D5,A5
            MOVEA.L (A5),A6
            JSR     (A6)
;ADD CODE TO PULL THE REGISTER NUMBER HERE
            LEA     P_COMMA,A1
            MOVE    #14,D0
            TRAP    #15

            MOVE.L  #$8,D4
            
            JMP     CHK_EA_DEST

SET_BIT  
            BSET    D4,D5
            BRA     EA_SOURCE_BACK
                        
*-----------------------------------------------------------
CHK_EA_DEST       ;COMPARES A DESTINATION MODE FROM THE OPCODE TO THE EA TREE
            BTST    D6,D3
            
            
            LEA     NXT_LINE,A1
            MOVE    #14,D0
            TRAP    #15
            
            JMP     DONE    ;TEMP INSTRUCTION DURRING TESTING         
*-----------------------------------------------------------
IS_ABS_IMM                           

*-----------------------------------------------------------    
M_DR    ;IF MODE IS A DATA REGISTER Dn
            
            LEA     P_D,A1
            MOVE.B  #14,D0    
            TRAP    #15 
            
            RTS
*-----------------------------------------------------------            
M_AR    ;IF MODE IS AN ADDRESS REGISTER An

            LEA     P_A,A1
            MOVE.B  #14,D0    
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
            
            LEA     P_CLOSE_PAR,A1
            MOVE.B  #14,D0    
            TRAP    #15
            
            RTS  
*-----------------------------------------------------------
M_IA    ;IF MODE IS IMMIDIATE ADDRESSING #IMM

            LEA     P_HASH,A1
            MOVE.B  #14,D0    
            TRAP    #15 

            RTS
*-----------------------------------------------------------
M_ALA   ;IF MODE IS AN ABSOLUTE LONG ADDRESS (xxx).L

            LEA     P_HEX,A1
            MOVE.B  #14,D0    
            TRAP    #15 

            RTS  
*-----------------------------------------------------------
M_AWA   ;IF MODE IS AN ABSOLUTE WORD ADDRESS (xxx).W

            LEA     P_HEX,A1
            MOVE.B  #14,D0    
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
