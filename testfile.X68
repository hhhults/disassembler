*-----------------------------------------------------------
* Title      :test file
* Written by :Harper Hults
* Date       :5/23
* Description:has a couple instructions to load into memory for the disassembler
*-----------------------------------------------------------
    ORG    $5000
START:                  ; NEED Bcc TESTS *************************************** <--- *|||||

   NOP
   BRA  TEST_BRA
   
TEST_BACK
    MOVEA.L  #$00005000,A4
    MOVEA.L  #$00009000,A2
    ;MOVE INSTRUCTION TESTS
   MOVE.L   #$00201010,D4
   MOVE.L   D4,D5
   MOVE.W   #$0005,D1
   MOVE.W   D1,D2
   MOVE.B   #$05,D4
   MOVE.B   D1,D4
   MOVEA.L  #$00005000,A4
   MOVE.L   (A4),D4
   MOVE.L   -(A4),D4
   MOVE.L   (A4)+,D4
   MOVE.L   $00005000,D4
   MOVE.W   (A4),D4
   MOVE.W   -(A4),D4
   MOVE.W   (A4)+,D4
   MOVE.W   $5000,D4
   MOVE.L   A4,D4
   MOVE.L   #$A5A5A5A5,(A2)
   MOVE.L   #$A5A5A5A5,(A2)+
   MOVE.L   #$A5A5A5A5,-(A2)
   MOVE.W   #$A5A5,(A2)
   MOVE.W   #$A5A5,-(A2)
   MOVE.W   #$A5A5,(A2)+
   ;MOVEA INSTRUCTION TESTS
    MOVEA.L  #$00005000,A4
    MOVEA.L  D4,A4 
    MOVEA.L  (A4),A5
    MOVEA.L  -(A4),A5
    MOVEA.L  (A4)+,A5
    MOVEA.W  D4,A6
    MOVEA.W  #$5000,A6
    MOVEA.W  (A4),A5
    MOVEA.W  -(A4),A5
    MOVEA.W  (A4)+,A5 
    ;MOVEQ INSTRUCTION TESTS
    MOVEQ   #$07,D4
    MOVEQ   #$01,D4
    ;NOT INSTRUCTION TESTS
    NOT.B   D1
    NOT.B   (A4)
    NOT.B   (A4)+
    NOT.B   -(A4)
    NOT.B   $00009000
    NOT.W   D1
    NOT.W   (A4)
    NOT.W   (A4)+
    NOT.W   -(A4)
    NOT.W   $00009000
    NOT.L   D1
    NOT.L   (A4)
    NOT.L   (A4)+
    NOT.L   -(A4)
    NOT.L   $00009000
    ;OR INSTRUCTION TESTS
    OR.B    D1,$9000
    OR.B    $00009000,D1
    OR.B    D1,$00009000
    OR.B    $9000,D1
    OR.B    D1,(A4)
    OR.B    D1,-(A4)
    OR.B    D1,(A4)+
    OR.W    D1,$9000
    OR.W    $00009000,D1
    OR.W    D1,$00009000
    OR.W    $9000,D1
    OR.W    D1,(A4)
    OR.W    D1,-(A4)
    OR.W    D1,(A4)+
    OR.L    D1,$9000
    OR.L    $00009000,D1
    OR.L    D1,$00009000
    OR.L    $9000,D1
    OR.L    D1,(A4)
    OR.L    D1,-(A4)
    OR.L    D1,(A4)+
    ;SUB INSTRUCTION TESTS 
    MOVE.L  #$02,D1
    SUB.L   D1,D2
    SUB.L   D1,(A2) 
    SUB.L   D1,-(A2)
    SUB.L   D1,(A2)+
    SUB.L   #$00010002,D1
    SUB.L   #$00010002,(A2)
    SUB.L   #$00010002,-(A2)
    SUB.L   #$00010002,(A2)+
    SUB.W   D1,D2
    SUB.W   D1,(A2) 
    SUB.W   D1,-(A2)
    SUB.W   D1,(A2)+
    SUB.W   #$0002,D1
    SUB.W   #$0002,(A2)
    SUB.W   #$0002,-(A2)
    SUB.W   #$0002,(A2)+
    SUB.B   D1,D2
    SUB.B   D1,(A2) 
    SUB.B   D1,-(A2)
    SUB.B   D1,(A2)+
    SUB.B   #$02,D1
    SUB.B   #$02,(A2)
    SUB.B   #$02,-(A2)
    SUB.B   #$02,(A2)+
    SUB.L    D2,$9000
    SUB.L    $9000,D2
    SUB.W    D2,$9000
    SUB.W    $9000,D2
    SUB.B    D2,$9000
    SUB.B    $9000,D2
    ;ADD INSTRUCTION TESTS
    MOVE.L  #$02,D1
    ADD.L   D1,D2
    ADD.L   D1,(A2) 
    ADD.L   D1,-(A2)
    ADD.L   D1,(A2)+
    ADD.L   #$F0000002,D1
    ADD.L   #$F0000002,(A2)
    ADD.L   #$F0000002,-(A2)
    ADD.L   #$F0000002,(A2)+
    ADD.W   D1,D2
    ADD.W   D1,(A2) 
    ADD.W   D1,-(A2)
    ADD.W   D1,(A2)+
    ADD.W   #$F002,D1
    ADD.W   #$F002,(A2)
    ADD.W   #$F002,-(A2)
    ADD.W   #$F002,(A2)+
    ADD.B   D1,D2
    ADD.B   D1,(A2) 
    ADD.B   D1,-(A2)
    ADD.B   D1,(A2)+
    ADD.B   #$F2,D1
    ADD.B   #$F2,(A2)
    ADD.B   #$F2,-(A2)
    ADD.B   #$F2,(A2)+
    ADD.L    D5,$9000
    ADD.L    $9000,D5
    ADD.W    D5,$9000
    ADD.W    $9000,D5
    ADD.B    D5,$9000
    ADD.B    $9000,D5
    ;AND INSTRUCTION TESTS
    AND.B    D1,$9000
    AND.B    $00009000,D1
    AND.B    D1,$00009000
    AND.B    $9000,D1
    AND.B    D1,(A4)
    AND.B    D1,-(A4)
    AND.B    D1,(A4)+
    AND.W    D1,$9000
    AND.W    $00009000,D1
    AND.W    D1,$00009000
    AND.W    $9000,D1
    AND.W    D1,(A4)
    AND.W    D1,-(A4)
    AND.W    D1,(A4)+
    AND.L    D1,$9000
    AND.L    $00009000,D1
    AND.L    D1,$00009000
    AND.L    $9000,D1
    AND.L    D1,(A4)
    AND.L    D1,-(A4)
    AND.L    D1,(A4)+
    ;ADDA INSTRUCTION TESTS
    ADDA.L   D5,A6
    ADDA.W   D5,A6
   ;ROd,ASd/LSd INSTRUCTION TESTS
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
   
    NOT D0
    NOP
    LEA DONE,A1
    JSR DONE
    SIMHALT             ; halt simulator

TEST_BRA
    
    BRA TEST_BACK
DONE MOVE.B #$F,D0
     RTS           
* Put variables and constants here

    END    START        ; last line of source










*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
