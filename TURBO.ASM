.MODEL TINY

.DATA
	TERROR	db 'USAGE: TURBO <1|0>', 10, 13, '$'
	TON db 'TURBO ON', 10, 13, '$'
	TOFF db ' TURBO OFF', 10, 13, '$'

.CODE
ORG 100h

MAIN PROC
	mov cl, DS:[080h]   ;read the number of bytes in the arguments
	cmp cl,2            ;compare 2 because (1=space 2=the value)
	jnz ERROR           ;if no cli args are provided show the usage

	mov cl, DS:[082h]   ;read the char in 082h (081h is space 082h is 1|0)
	cmp cl, '0'         ;if arg is '0' set turbo off all else turbo on
	JNZ TURBO_ON        ;else turbo onn

TURBO_OFF:
	mov al, 00h         ;load al with 0, al serves as arg for TURBO_V
	call TURBO_V        ;set the turbo off

	mov dx, offset TOFF ;DX is arg for PRINT, print turbo off mesg
	call PRINT          ;write mesage to screen

	call EXIT           ;exit program gracefully

TURBO_ON:
	mov al, 01h  	    ;load al with 1, al serves as arg for TURBO_V
	call TURBO_V        ;set the turbo on

	mov dx, offset TON  ;DX is arg for PRINFT, print turbo on mesg
	call PRINT          ;write message to screen

	call EXIT           ;exit program gracefully
ERROR:
	mov dx, offset TERROR ;dx is arg for PRINT, print TERROR message
	call PRINT          ;write message to screen
	call EXIT           ;exit program gracefully
MAIN ENDP

	;writes the value currently in al to port 0cfh
TURBO_V PROC
	mov dx, 0cfh        ;load dx with hardware port that cntrls turbo
	out dx, al          ;al is arg, and send to the port 0cfh
	ret                 ;return to caller
TURBO_V ENDP

	;prints the string where DX is pointing to
PRINT PROC
	mov ah, 09h         ;ah 09 and int 21h print msg in DX to screen
	int 021h
	ret
PRINT ENDP

	;call dos exit and close program
EXIT PROC
	mov ah, 04ch       ;ah 04c and 21h exit DOS gracefully
	int 021h
	ret
EXIT ENDP

END MAIN