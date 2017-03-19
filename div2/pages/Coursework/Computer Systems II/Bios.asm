.Code
	COPY %G0 0x00001000	;start of bus controller/scan pointer
	COPY %G4 0		;initialize as 0 for comparison - ROM address
	COPY %G5 0		;initialize as 0 for comparison - RAM address
scan:	
	ADD %G0 %G0 0x0000000c	;don't care about first entry (it's the bus controller)
	BEQ +fndrom *%G0 2	;found the ROM?
	BNEQ +scan *%G0 3	;found the RAM?

	ADD %G5 %G0 4		;record RAM base location
	BGT +boot %G4 1		;have we also found the second ROM?
	;;%G4 is either 0, 1, or the address of kernel (which is assuredly greater than 1)
	JUMP +scan		;otherwise keep looking
fndrom:
	ADD %G4 %G4 1		;inc ROM counter
	BEQ +scan %G4 1		;if this is only the first ROM, keep looking
	ADD %G4 %G0 4		;record kernel base location
	BEQ +scan %G5 0		;if we haven't found the RAM, keep searching
;;; no need to jump from fndrom, we'd be jumping here anyway
boot:
	SUB %G0 *0x00001008 12	;grab DMA location
	COPY *%G0 *%G4		;copy ROM base to src
	ADD %G0 %G0 4		;DMA dest location
	COPY *%G0 *%G5		;copy RAM base to dest
	ADD %G0 %G0 4 		;DMA length location?
	ADD %G3 %G4 4		;record kernel limit location
	SUB %G1 *%G3 *%G4	;sub limit from base (length)
	COPY *%G0 %G1
	JUMP *%G5		;jump to kernel!