;;; Loop process to initiate further ROMs.
;;; NB: CREATE system call adds 3 to the ROM number, so this will call 1, 2, 3, etc
;;; this is mostly to prevent processes from creating another instance of the bios, kernel, etc
	.Code

	COPY		%SP		%FP
	SUBUS		%SP		%SP		8	 ;create space on stack for rv
	COPY		*%SP		0x00000001		 ;push SYSC onto stack
	SYSC
;;; %SP: OPCODE, rv
	ADDUS		%SP		%SP		4
	COPY		%G0		*%SP			 ;grab rv (ROM count)
	BEQ		exit		%G0		0
	COPY		%G1		1
	SUBUS		%SP		%SP		8	 
	COPY		*%SP		0xffffffff	 	 ;opcode on stack (doing this first so we can loop more cleanly/there's no need to include this in the loop)
;;; begin loop: copy in rom #, create, check for more processes to run
loop:	ADDUS		%SP		%SP		4
	COPY		*%SP		%G0			 ;rom # to fetch
	SUBUS		%SP		%SP		4
	SYSC
	ADDUS		%G1		%G1		1
	BGTE		loop		%G0		%G1
	;; fall through
exit:
	COPY		*%SP		0x00000000
	SYSC						 	 ;EXIT