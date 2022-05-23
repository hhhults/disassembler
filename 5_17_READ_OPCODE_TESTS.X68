*-----------------------------------------------------------
* Title      : EARLY DECOMPOSITION TESTS
* Written by : CAMAS COLLINS
* Date       : 5/17/2022
* Description:  EARLY TESTS FOR 422 FINAL PROJECT FOCUSING ON OPCODE RECOGNITION
*-----------------------------------------------------------
CR          EQU $0D
LF          EQU $0A

;OPCODES STORED FOR COMPARISON
C_RTSBRA    EQU %0100111001110101
C_NOP       EQU %0100111001110001
C_LSL       EQU %1110001111
C_MOVEQ     EQU %0111
C_SUB       EQU %1001

;MESSAGES TO PRING WHEN OPCODE IS IDENTIFIED
P_RTSBRA    DC.B    'RTS OR BRA',CR,LF
P_NOP       DC.B    'NOP',CR,LF
P_LSL       DC.B    'LSL',CR,LF
P_MOVEQ     DC.B    'MOVEQ',CR,LF
P_SUB       DC.B    'SUB',CR,LF
P_INVAL     DC.B    'NOT A VALID OPCODE HERE',CR,LF



    ORG    $1000
START:                  

    MOVEA.L #$00005000,A3               ;LOCATION OF INSTRUCTIONS TO BE DECOMPOSED
    
    MOVE.W  #%0100111001110101,(A3)+    ;RTS & BRA INSTRUCTION OPCODE
    MOVE.W  #%0100111001110001,(A3)+    ;NOP INSTRUCTION OPCODE
    MOVE.W  #%1110001111000000,(A3)+    ;LSL INSTRUCTION OPCODE
    MOVE.B  #%01110000,(A3)+            ;MOVEQ INSTRUCTION OPCODE
    MOVE.B  #%10010000,(A3)+            ;SUB INSTRUCTION OPCODE
    
    MOVE.W  #$FCFA,(A3)                 ;TERMINATION CODE
    
    MOVEA.L #$00005000,A3               ;RESETING A3 TO THE START OF THE INSTRUCTIONS
   


 
LOOP                                    ;PRIMARY LOOP TO READ MEMORY
    MOVE.W  (A3),D2
    
    CMP.W   #$FCFA,D2
    BEQ     DONE
    
    BRA     CMP_RTSBRA
  
    
    
CMP_RTSBRA                              ;COMPARING PULLED OPCODE TO RTS AND BRA OPCODES
    CMP.W   C_RTSBRA,D2
    BNE     CMP_NOP
    
    ADDA.W  #$02,A3
    LEA     P_RTSBRA,A1
    MOVE.B  #14,D0
    TRAP    #15
    BRA LOOP
CMP_NOP                                 ;COMPARING PULLED OPCODE TO NOP OPCODES
    CMP.W   C_NOP,D2
    BNE     CMP_LSL
    
    LEA     P_NOP,A1
    MOVE.B  #14,D0
    TRAP    #15
    BRA LOOP
CMP_LSL                                 ;COMPARING PULLED OPCODE TO LSL OPCODES
    CMP.W   C_LSL,D2
    BNE     CMP_MOVEQ
    
    LEA     P_LSL,A1
    MOVE.B  #14,D0
    TRAP    #15
    BRA LOOP
CMP_MOVEQ                               ;COMPARING PULLED OPCODE TO MOVEQ OPCODES
    CMP.W   C_MOVEQ,D2
    BNE     CMP_SUB
    
    LEA     P_MOVEQ,A1
    MOVE.B  #14,D0
    TRAP    #15
    BRA LOOP
CMP_SUB                                 ;COMPARING PULLED OPCODE TO SUB OPCODES
    CMP.W   C_SUB,D2
    BNE     INVAL
    
    LEA     P_SUB,A1
    MOVE.B  #14,D0
    TRAP    #15
    BRA LOOP
INVAL
    LEA     P_INVAL,A1
    MOVE.B  #14,D0
    TRAP    #15
    BRA LOOP
    
DONE                                    ;PROGRAM TERMINATION
    MOVE.B  #9,D0
    TRAP    #15

    END    $1000        

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
