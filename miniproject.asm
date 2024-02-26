    	list P=16F84A
PC      equ     0x02
STATUS  equ     0x03
PORTA   equ     0x05
PORTB   equ     0x06
SEND    equ     0x1A
COUNT   equ     0x1B
DIGIT1  equ     0x0C
DIGIT2  equ     0x0D
DIGIT3  equ     0x0E
DIGIT4  equ     0x0F
PD1     equ     0x3A     
PD2     equ     0x3B     
PD3     equ     0x3C     
PD4     equ     0x3D     
NC      equ     0x2A
DLY1    equ     0x12
DLY2    equ     0x13
DLY3    equ     0x14
RP0     equ     5
Z       equ     2
F       equ     1
W       equ     0
C       equ     0
                
		org 	0x000
Init        bsf     STATUS, RP0
            movlw	0x14
            movwf	PORTA
            movlw	0x01
            movwf	PORTB
            bcf     STATUS, RP0
            movlw   0x41
            movwf   PD1
            movwf   PD2
            movwf   PD3
            movwf   PD4
            movlw   .9
            movwf   NC
            clrf	PORTA
            clrf	PORTB
            movlw   0xBF
            movwf   PORTB

Main        movlw   0x2f
            call    SendData
            bsf     PORTA, 3
            bcf     PORTA, 3
            movlw   0xBF
            movwf   DIGIT1
            movwf   DIGIT2
            movwf   DIGIT3
            movwf   DIGIT4
            btfss   PORTA, 2 ;  press to set
            call    ChangeP
            btfss   PORTA, 4
            call    CheckPass
			goto	Main

CheckPass   call    InitSet
            call    Pass
            movlw   0xBF
            movwf   PORTB
            return

Pass        movf    PD1, W
            subwf   DIGIT1, W
            btfss   STATUS, Z
            return
            movf    PD2, W
            subwf   DIGIT2, W
            btfss   STATUS, Z
            return
            movf    PD3, W
            subwf   DIGIT3, W
            btfss   STATUS, Z
            return
            movf    PD4, W
            subwf   DIGIT4, W
            btfss   STATUS, Z
            return
            movlw   0x1f
            call    SendData
            bsf     PORTA, 3
            bcf     PORTA, 3
            call    DelayB
            call    DelayB
            call    DelayB
            call    DelayB
            call    DelayB
            call    DelayB
            return

ChangeP     call    InitSet
            call    NewPass
            movlw   0xBF
            movwf   PORTB
            return

NewPass     movf    PD1, W
            subwf   DIGIT1, W
            btfss   STATUS, Z
            return
            movf    PD2, W
            subwf   DIGIT2, W
            btfss   STATUS, Z
            return
            movf    PD3, W
            subwf   DIGIT3, W
            btfss   STATUS, Z
            return
            movf    PD4, W
            subwf   DIGIT4, W
            btfss   STATUS, Z
            return
            movlw   0x1f
            call    SendData
            bsf     PORTA, 3
            bcf     PORTA, 3
            call    DelayB
            call    DelayB
            call    InitSet
            movf    DIGIT1, W
            movwf   PD1
            movf    DIGIT2, W
            movwf   PD2
            movf    DIGIT3, W
            movwf   PD3
            movf    DIGIT4, W
            movwf   PD4
            movlw   0x1f
            call    SendData
            bsf     PORTA, 3
            bcf     PORTA, 3
            call    DelayB
            call    DelayB
            return


InitSet     call    DelayB
            movlw   0xBF
            movwf   DIGIT1
            movwf   DIGIT2
            movwf   DIGIT3
            movwf   DIGIT4
            movlw   0x3f;
            call    SendData
            bsf     PORTA, 3
            bcf     PORTA, 3
SetDigit1   call    Showseg
            btfsc   PORTA, 4
            goto    $+3
            call    AddNum
            movwf   DIGIT1
            btfsc   PORTB, 0
            goto    $-6
            call    ReNC
SetDigit2   call    DelayB
            call    DelayB
            call    Showseg
            btfsc   PORTA, 4
            goto    $+3
            call    AddNum
            movwf   DIGIT2
            btfsc   PORTB, 0
            goto    $-6
            call    ReNC
SetDigit3   call    DelayB
            call    DelayB
            call    Showseg
            btfsc   PORTA, 4
            goto    $+3
            call    AddNum
            movwf   DIGIT3
            btfsc   PORTB, 0
            goto    $-6
            call    ReNC
SetDigit4   call    DelayB
            call    DelayB
            call    Showseg
            btfsc   PORTA, 4
            goto    $+3
            call    AddNum
            movwf   DIGIT4
            btfsc   PORTB, 0
            goto    $-6
            call    ReNC
            return

AddNum      call    DelayB
            call    DelayB
			movf    NC, W
            call    Segment
            decf    NC, F
            btfss   NC, 7 
			return
            call    ReNC
            return

Showseg     movlw   0x30
            call    SendData
            bsf     PORTA, 3
            bcf     PORTA, 3
            movf    DIGIT1, W
            movwf   PORTB  
            movlw   0x38
            call    SendData
            bsf     PORTA, 3
            bcf     PORTA, 3
            call    DelayS
            movlw   0x30
            call    SendData
            bsf     PORTA, 3
            bcf     PORTA, 3
            movf    DIGIT2, W
            movwf   PORTB
            movlw   0x34
            call    SendData
            bsf     PORTA, 3
            bcf     PORTA, 3
            call    DelayS
            movlw   0x30
            call    SendData
            bsf     PORTA, 3
            bcf     PORTA, 3
            movf    DIGIT3, W
            movwf   PORTB
            movlw   0x32
            call    SendData
            bsf     PORTA, 3
            bcf     PORTA, 3
            call    DelayS
            movlw   0x30
            call    SendData
            bsf     PORTA, 3
            bcf     PORTA, 3
            movf    DIGIT4, W
            movwf   PORTB
            movlw   0x31
            call    SendData
            bsf     PORTA, 3
            bcf     PORTA, 3
            call    DelayS
            movlw   0x30
            call    SendData
            bsf     PORTA, 3
            bcf     PORTA, 3
            return

DelayB 	    movlw	0xff ; delay time = 196.098 mS
            movwf	DLY1
            movlw	0xff
            movwf	DLY2
			movlw	0xff
            decfsz	DLY2, F
            goto	$ - 1
            decfsz	DLY1, F
            goto	$ - 5
            return

DelayS 	    movlw	0xAE ;
            movwf	DLY1
            decfsz	DLY1, F
            goto	$ - 1
            return

SendData    movwf   SEND
            movlw   0x08
            movwf   COUNT
ChkBit      bcf     PORTA, 0
            btfsc   SEND, 7
            bsf     PORTA, 0     
Clock       bsf     PORTA, 1     
            bcf     PORTA, 1
Rotate      rlf     SEND, F
            decfsz  COUNT, F
            goto    ChkBit
            return   

ReNC        movlw   .9
            movwf   NC
            return  

Segment     addwf   PC, F
			retlw   0x09
            retlw   0x01
            retlw   0xCD
            retlw   0x21
            retlw   0x29
            retlw   0x99
            retlw   0x0D
            retlw   0x07
            retlw   0xDD
            retlw   0x41

end