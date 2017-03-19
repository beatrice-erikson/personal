;;; ================================================================================================================================
;;; kernel-stub.asm
;;; Scott F. H. Kaplan -- sfkaplan@cs.amherst.edu
;;;
;;; The assembly core that perform the basic initialization of the kernel, bootstrapping the installation of trap handlers and
;;; configuring the kernel's memory space.
;;;
;;; Revision 0 : 2010-09-06
;;; ================================================================================================================================


;;; ================================================================================================================================
	.Code
;;; ================================================================================================================================



;;; ================================================================================================================================
;;; Entry point.

__start:	

	;; Find RAM.  Start the search at the beginning of the device table.
	COPY		%G0			*+_static_device_table_base
	
RAM_search_loop_top:

	;; End the search with failure if we've reached the end of the table without finding RAM.
	BEQ		+RAM_search_failure	*%G0		*+_static_none_device_code

	;; If this entry is RAM, then end the loop successfully.
	BEQ		+RAM_found		*%G0		*+_static_RAM_device_code

	;; This entry is not RAM, so advance to the next entry.
	ADDUS		%G0			%G0		*+_static_dt_entry_size	; %G0 = &dt[RAM]
	JUMP		+RAM_search_loop_top

RAM_search_failure:

	;; Record a code to indicate the error, and then halt.
	COPY		%G5		*+_static_kernel_error_RAM_not_found
	HALT

RAM_found:
	
	;; RAM has been found.  If it is big enough, create a stack.
	ADDUS		%G1		%G0		*+_static_dt_base_offset  ; %G1 = &RAM[base]
	COPY		%G1		*%G1 					  ; %G1 = RAM[base]
	ADDUS		%G2		%G0		*+_static_dt_limit_offset ; %G2 = &RAM[limit]
	COPY		%G2		*%G2 					  ; %G2 = RAM[limit]
	SUB		%G0		%G2		%G1 			  ; %G0 = |RAM|
	MULUS		%G4		*+_static_min_RAM_KB	 *+_static_bytes_per_KB ; %G4 = |min_RAM|
	BLT		+RAM_too_small	%G0		%G4
	MULUS		%G4		*+_static_kernel_KB_size *+_static_bytes_per_KB ; %G4 = |kmem|
	ADDUS		%SP		%G1		%G4  			  ; %SP = kernel[base] + |kmem| = kernel[limit]
	COPY		%FP		%SP 					  ; Initialize %FP

	;; Get DMA base (src) location and copy to static space
	SUBUS		*+_static_DMA_base		*0x00001008		12
	;; Copy the RAM and kernel bases and limits to statically allocated spaces.
	COPY		*+_static_RAM_base		%G1
	COPY		*+_static_RAM_limit		%G2
	COPY		*+_static_kernel_base		%G1
	COPY		*+_static_kernel_limit		%SP

	;; With the stack initialized, call main() to begin booting proper.
	SUBUS		%SP		%SP		12		 ; Push pFP / ra / rv
	COPY		*%SP		%FP		  		 ; pFP = %FP
	COPY		%FP		%SP				 ; Update FP.
	ADDUS		%G5		%FP		4		 ; %G5 = &ra
	CALL		+_procedure_main		*%G5

	;; We should never be here, but wrap it up properly.
	COPY		%FP		*%FP
	ADDUS		%SP		%SP		12               ; Pop pFP / args[0] / ra / rv
	COPY		%G5		*+_static_kernel_error_main_returned
	HALT

RAM_too_small:
	;; Set an error code and halt.
	COPY		%G5		*+_static_kernel_error_small_RAM
	HALT

;;;========================================================================================
_procedure_main:
	;; initialize trap table
	SUB		%SP		%SP		48
	SETIBR		%SP
	COPY		*+_&IB		%SP
	ADD		%SP		%SP		8
	SETTBR		%SP
	COPY		*%SP		+_invalid_address
	ADD		%SP		%SP		4
	COPY		*%SP		+_invalid_register
	ADD		%SP		%SP		4
	COPY		*%SP		+_bus_error
	ADD		%SP		%SP		4
	COPY		*%SP		+_clock_alarm
	ADD		%SP		%SP		4
	COPY		*%SP		+_divide_by_zero
	ADD		%SP		%SP		4
	COPY		*%SP		+_overflow
	ADD		%SP		%SP		4
	COPY		*%SP		+_invalid_instruction
	ADD		%SP		%SP		4
	COPY		*%SP		+_permission_violation
	ADD		%SP		%SP		4
	COPY		*%SP		+_invalid_shift_amount
	ADD		%SP		%SP		4
	COPY		*%SP		+_system_call
	SUB		%SP		%SP		48

;;; initialize process table
	COPY		*+_pt_base	%SP
	COPY		*%SP		0
	MULUS		%G5		*+_pt_entry_size	20	 ; make space for entries
	SUBUS		%SP		%SP		%G5

;;; prologue for finding device (3rd ROM, init.vmx
	SUBUS		%SP		%SP		12		 ; Push pFP / ra / rv
	COPY		*%SP		%FP		  		 ; pFP = %FP
	COPY		%FP		%SP				 ; Update FP.
	ADDUS		%G5		%FP		4		 ; %G5 = &ra
	SUBUS		%FP		%FP		4		 ; push device instance
	COPY		*%FP		3				 ; finding rom #3
	SUBUS		%FP		%FP		4		 ; push device type
	COPY		*%FP		2				 ; ROM device type
	COPY		%SP		%FP				 ; update %SP
	CALL		+_procedure_find_device		*%G5
;;; epilogue
	ADDUS		%SP		%SP		8		 ; pop args
	COPY		%FP		*%SP				 ; %FP = pFP
	ADDUS		%SP		%SP		8		 ; pop pFP / ra
	COPY		%G0		*%SP				 ; %G0 = pointer to init.vmx dt entry
	ADDUS		%SP		%SP		4		 ; pop rv
	
;;; DMA init.vmx into RAM
	ADD		%G1		%G0		4		;loc of base of 3rd ROM
	COPY		%G2		*+_static_DMA_base		;DMA src
	COPY		*%G2		*%G1				;base of 3rd ROM -> DMA src
	ADD		%G2		%G2		4		;DMA dest
	ADD		%G4		*+_static_kernel_limit	224
	COPY		*%G2		%G4				;end of kernel -> DMA dest
	SETBS		%G4
	SUBUS		%G3		*+_pt_base	4		;pt position for pBS
	COPY		*%G3		%G4		  		;copy base into pt entry base spot
	ADD		%G2		%G2		4		;DMA len
	ADD		%G3		%G1		4		;loc of limit of 3rd ROM
	SUB		%G3		*%G3		*%G1		;len init.vmx
	ADD		%G5		%G3		%G4
	ADD		%G5		%G5		128
	SETLM		%G5
	SUBUS		%G1		*+_pt_base	8		;pt position for pLM
	COPY		*%G1		%G5
	SUBUS		%G1		%G1		4
	COPY		*%G1		0
	SUBUS		%G4		%G5		%G4		;virtual limit
	SUBUS		%G1		%G1		4
	COPY		*%G1		%G4
	SUBUS		%G1		%G1		4
	COPY		*%G1		%G4
	COPY		*%G2		%G3				;len -> DMA len
	COPY		*+_pt_entry_count		1
;;; prelude (not trusting non-kernel processes to (re)store registers)
	SUBUS		%SP		%SP		4		 ; Push pFP
	COPY		*%SP		%FP		  		 ; pFP = %FP
	SUBUS		%SP		%SP		4
	COPY		*%SP		%G0
	SUBUS		%SP		%SP		4
	COPY		*%SP		%G1
	SUBUS		%SP		%SP		4
	COPY		*%SP		%G2
	SUBUS		%SP		%SP		4
	COPY		*%SP		%G3
	SUBUS		%SP		%SP		4
	COPY		*%SP		%G4
	SUBUS		%SP		%SP		4
	COPY		*%SP		%G5
	COPY		*+_pSP		%SP				 ; preserve %SP for return from process call
	COPY		%FP		%G4				 ; %FP = top of virtual address space
	JUMPMD		0x00000000	0x00000006
_shutdown:
	HALT
	;; maybe print _string_done_msg if i have time to get print working

;;; ================================================================================================================================	
;;; Procedure: find_device
;;; Callee preserved registers:
;;;   [%FP - 4]:  G0
;;;   [%FP - 8]:  G1
;;;   [%FP - 12]: G2
;;;   [%FP - 16]: G4
;;; Parameters:
;;;   [%FP + 0]: The device type to find.
;;;   [%FP + 4]: The instance of the given device type to find (e.g., the 3rd ROM).
;;; Caller preserved registers:
;;;   [%FP + 8]:  FP
;;; Return address:
;;;   [%FP + 12]
;;; Return value:
;;;   [%FP + 16]: If found, a pointer to the correct device table entry; otherwise, null.
;;; Locals:
;;;   %G0: The device type to find (taken from parameter for convenience).
;;;   %G1: The instance of the given device type to find. (from parameter).
;;;   %G2: The current pointer into the device table.


_procedure_find_device:

	;; Prologue: Preserve the registers used on the stack.
	SUBUS		%SP		%SP		4
	COPY		*%SP		%G0
	SUBUS		%SP		%SP		4
	COPY		*%SP		%G1
	SUBUS		%SP		%SP		4
	COPY		*%SP		%G2
	SUBUS		%SP		%SP		4
	COPY		*%SP		%G4
	
	;; Initialize the locals.
	COPY		%G0		*%FP
	ADDUS		%G1		%FP		4
	COPY		%G1		*%G1
	COPY		%G2		*+_static_device_table_base
	
find_device_loop_top:

	;; End the search with failure if we've reached the end of the table without finding the device.
	BEQ		+find_device_loop_failure	*%G2		*+_static_none_device_code

	;; If this entry matches the device type we seek, then decrement the instance count.  If the instance count hits zero, then
	;; the search ends successfully.
	BNEQ		+find_device_continue_loop	*%G2		%G0
	SUB		%G1				%G1		1
	BEQ		+find_device_loop_success	%G1		0
	
find_device_continue_loop:	

	;; Advance to the next entry.
	ADDUS		%G2			%G2		*+_static_dt_entry_size
	JUMP		+find_device_loop_top

find_device_loop_failure:

	;; Set the return value to a null pointer.
	ADDUS		%G4			%FP		16 	; %G4 = &rv
	COPY		*%G4			0			; rv = null
	JUMP		+find_device_return

find_device_loop_success:

	;; Set the return pointer into the device table that currently points to the given iteration of the given type.
	ADDUS		%G4			%FP		16 	; %G4 = &rv
	COPY		*%G4			%G2			; rv = &dt[<device>]
	;; Fall through...
	
find_device_return:

	;; Epilogue: Restore preserved registers, then return.
	COPY		%G4		*%SP
	ADDUS		%SP		%SP		4
	COPY		%G2		*%SP
	ADDUS		%SP		%SP		4
	COPY		%G1		*%SP
	ADDUS		%SP		%SP		4
	COPY		%G0		*%SP
	ADDUS		%SP		%SP		4
	ADDUS		%G5		%FP		12 	; %G5 = &ra
	JUMP		*%G5
;;; ================================================================================================================================



;;; ================================================================================================================================
;;; Procedure: print
;;; Callee preserved registers:
;;;   [%FP - 4]: G0
;;;   [%FP - 8]: G3
;;;   [%FP - 12]: G4
;;; Parameters:
;;;   [%FP + 0]: A pointer to the beginning of a null-terminated string.
;;; Caller preserved registers:
;;;   [%FP + 4]: FP
;;; Return address:
;;;   [%FP + 8]
;;; Return value:
;;;   <none>
;;; Locals:
;;;   %G0: Pointer to the current position in the string.
	
_procedure_print:

	;; Prologue: Push preserved registers.
	SUBUS		%SP		%SP		4
	COPY		*%SP		%G0
	SUBUS		%SP		%SP		4
	COPY		*%SP		%G3
	SUBUS		%SP		%SP		4
	COPY		*%SP		%G4

	;; If not yet initialized, set the console base/limit statics.
	BNEQ		+print_init_loop	*+_static_console_base		0
	SUBUS		%SP		%SP		12		; Push pfp / ra / rv
	COPY		*%SP		%FP				; pFP = %FP
	SUBUS		%SP		%SP		4 		; Push arg[1]
	COPY		*%SP		1				; Find the 1st device of the given type.
	SUBUS		%SP		%SP		4		; Push arg[0]
	COPY		*%SP		*+_static_console_device_code	; Find a console device.
	COPY		%FP		%SP				; Update %FP
	ADDUS		%G5		%SP		12		; %G5 = &ra
	CALL		+_procedure_find_device		*%G5
	ADDUS		%SP		%SP		8 		; Pop arg[0,1]
	COPY		%FP		*%SP 				; %FP = pfp
	ADDUS		%SP		%SP		8		; Pop pfp / ra
	COPY		%G4		*%SP				; %G4 = &dt[console]
	ADDUS		%SP		%SP		4		; Pop rv

	;; Panic if the console was not found.
	BNEQ		+print_found_console	%G4		0
	COPY		%G5		*+_static_kernel_error_console_not_found
	HALT
	
print_found_console:	
	ADDUS		%G3		%G4		*+_static_dt_base_offset  ; %G3 = &console[base]
	COPY		*+_static_console_base		*%G3			  ; Store static console[base]
	ADDUS		%G3		%G4		*+_static_dt_limit_offset ; %G3 = &console[limit]
	COPY		*+_static_console_limit		*%G3			  ; Store static console[limit]
	
print_init_loop:	

	;; Loop through the characters of the given string until the null character is found.
	COPY		%G0		*%FP 				; %G0 = str_ptr
print_loop_top:
	COPYB		%G4		*%G0 				; %G4 = current_char

	;; The loop should end if this is a null character
	BEQ		+print_loop_end	%G4		0

	;; Scroll without copying the character if this is a newline.
	COPY		%G3		*+_static_newline_char		; %G3 = <newline>
	BEQ		+print_scroll_call	%G4	%G3

	;; Assume that the cursor is in a valid location.  Copy the current character into it.
	;; The cursor position c maps to buffer location: console[limit] - width + c
	SUBUS		%G3		*+_static_console_limit	*+_static_console_width	   ; %G3 = console[limit] - width
	ADDUS		%G3		%G3		*+_static_cursor_column		   ; %G3 = console[limit] - width + c
	COPYB		*%G3		%G4						   ; &(height - 1, c) = current_char
	
	;; Advance the cursor, scrolling if necessary.
	ADD		*+_static_cursor_column	*+_static_cursor_column		1	; c = c + 1
	BLT		+print_scroll_end	*+_static_cursor_column	*+_static_console_width	; Skip scrolling if c < width
	;; Fall through...
	
print_scroll_call:	
	SUBUS		%SP		%SP		8				; Push pfp / ra
	COPY		*%SP		%FP						; pfp = %FP
	COPY		%FP		%SP						; %FP = %SP
	ADDUS		%G5		%FP		4				; %G5 = &ra
	CALL		+_procedure_scroll_console	*%G5
	COPY		%FP		*%SP 						; %FP = pfp
	ADDUS		%SP		%SP		8				; Pop pfp / ra

print_scroll_end:
	;; Place the cursor character in its new position.
	SUBUS		%G3		*+_static_console_limit		*+_static_console_width ; %G3 = console[limit] - width
	ADDUS		%G3		%G3		*+_static_cursor_column	        ; %G3 = console[limit] - width + c	
	COPY		%G4		*+_static_cursor_char				        ; %G4 = <cursor>
	COPYB		*%G3		%G4					        ; console@cursor = <cursor>
	
	;; Iterate by advancing to the next character in the string.
	ADDUS		%G0		%G0		1
	JUMP		+print_loop_top

print_loop_end:
	;; Epilogue: Pop and restore preserved registers, then return.
	COPY		%G4		*%SP
	ADDUS		%SP		%SP		4
	COPY		%G3		*%SP
	ADDUS		%SP		%SP		4
	COPY		%G0		*%SP
	ADDUS		%SP		%SP		4
	ADDUS		%G5		%FP		8 		; %G5 = &ra
	JUMP		*%G5
;;; ================================================================================================================================


;;; ================================================================================================================================
;;; Procedure: scroll_console
;;; Description: Scroll the console and reset the cursor at the 0th column.
;;; Callee reserved registers:
;;;   [%FP - 4]:  G0
;;;   [%FP - 8]:  G1
;;;   [%FP - 12]: G4
;;; Parameters:
;;;   <none>
;;; Caller preserved registers:
;;;   [%FP + 0]:  FP
;;; Return address:
;;;   [%FP + 4]
;;; Return value:
;;;   <none>
;;; Locals:
;;;   %G0:  The current destination address.
;;;   %G1:  The current source address.

_procedure_scroll_console:

	;; Prologue: Push preserved registers.
	SUBUS		%SP		%SP		4
	COPY		*%SP		%G0
	SUBUS		%SP		%SP		4
	COPY		*%SP		%G1
	SUBUS		%SP		%SP		4
	COPY		*%SP		%G4

	;; Initialize locals.
	COPY		%G0		*+_static_console_base			   ; %G0 = console[base]
	ADDUS		%G1		%G0		*+_static_console_width	   ; %G1 = console[base] + width

	;; Clear the cursor.
	SUBUS		%G4		*+_static_console_limit		*+_static_console_width ; %G4 = console[limit] - width
	ADDUS		%G4		%G4		*+_static_cursor_column			; %G4 = console[limit] - width + c
	COPYB		*%G4		*+_static_space_char					; Clear cursor.

	;; Copy from the source to the destination.
	;;   %G3 = DMA portal
	;;   %G4 = DMA transfer length
	ADDUS		%G3		8		*+_static_device_table_base ; %G3 = &controller[limit]
	SUBUS		%G3		*%G3		12                          ; %G3 = controller[limit] - 3*|word| = &DMA_portal
	SUBUS		%G4		*+_static_console_limit	%G0 		    ; %G4 = console[base] - console[limit] = |console|
	SUBUS		%G4		%G4		*+_static_console_width     ; %G4 = |console| - width

	;; Copy the source, destination, and length into the portal.  The last step triggers the DMA copy.
	COPY		*%G3		%G1 					; DMA[source] = console[base] + width
	ADDUS		%G3		%G3		4 			; %G3 = &DMA[destination]
	COPY		*%G3		%G0 					; DMA[destination] = console[base]
	ADDUS		%G3		%G3		4 			; %G3 = &DMA[length]
	COPY		*%G3		%G4 					; DMA[length] = |console| - width; DMA trigger

	;; Perform a DMA transfer to blank the last line with spaces.
	SUBUS		%G3		%G3		8 			; %G3 = &DMA_portal
	COPY		*%G3		+_string_blank_line			; DMA[source] = &blank_line
	ADDUS		%G3		%G3		4 			; %G3 = &DMA[destination]
	SUBUS		*%G3		*+_static_console_limit	*+_static_console_width	; DMA[destination] = console[limit] - width
	ADDUS		%G3		%G3		4 			; %G3 = &DMA[length]
	COPY		*%G3		*+_static_console_width			; DMA[length] = width; DMA trigger
	
	;; Reset the cursor position.
	COPY		*+_static_cursor_column		0			                ; c = 0
	SUBUS		%G4		*+_static_console_limit		*+_static_console_width ; %G4 = console[limit] - width
	COPYB		*%G4		*+_static_cursor_char				   	; Set cursor.
	
	;; Epilogue: Pop and restore preserved registers, then return.
	COPY		%G4		*%SP
	ADDUS		%SP		%SP		4
	COPY		%G1		*%SP
	ADDUS		%SP		%SP		4
	COPY		%G0		*%SP
	ADDUS		%SP		%SP		4
	ADDUS		%G5		%FP		4 		; %G5 = &ra
	JUMP		*%G5
;;; ================================================================================================================================
	
_clock_alarm:	HALT		;switch process. do if there's time.
_invalid_address:
_invalid_register:
_bus_error:
_divide_by_zero:
_overflow:
_invalid_instruction:
_permission_violation:	
_invalid_shift_amount:	JUMP		+__SYSC_EXIT
_system_call:
;;; SYSC procedure:
	;; Store opcode at %SP
	;; Store any args, followed by rv spot, at %SP + 4
;;;OPCODE
	;;0x00000000:	EXIT
	;;0x00000001:	GET ROM COUNT	(will return rom count -3. See CREATE comments)
	;; 		srcA = &ra
	;;0x00000002:	PRINT
	;; 		srcA = &string
	;;0xffffffff:	CREATE
	;; 		srcA = ROM # (-3; will add 3 to this #. processes should not be able to run the BIOS, kernel, or init)

;;; get pt entry
	COPY		*+_temp		%G0 				 ; free up %G0 to use as pt entry pointer
	MULUS		%G0		*+_current_PID	*+_pt_entry_size
	SUBUS		%G0		*+_pt_base	%G0
	SUBUS		%G0		%G0		20		 ; pSP spot in pt entry
;;; store stack pointer + use as pt entry pointer
	COPY		*%G0		%SP				 ; pSP = SP
	COPY		%SP		%G0				 ; SP = pt entry pointor (currently -> pSP)
	COPY		%G0		*%SP				 ; store pSP in G0, for ease of later use
	SUBUS		%SP		%SP		4
	COPY		*%SP		*+_temp
	SUBUS		%SP		%SP		4
	COPY		*%SP		%G1
	ADDUS		%SP		%SP		24		 ; &pBS
	COPY		%G1		*%SP				 ; %G1 = pBS
	ADDUS		%G0		%G0		%G1		 ; %G0 = physical SP interrupted process (opcode)
	BEQ		+__SYSC_EXIT	*%G0		0x00000000	 ; EXIT - no need to preserve registers

	SUBUS		%SP		%SP		8		 ; &pIP
	COPY		%G1		*+_&IB
	ADDUS		*%SP		*%G1 		16		 ; & to vector back into process 
	
	SUBUS		%SP		%SP		20
	COPY		*%SP		%G2
	ADDUS		%SP		%SP		28
	COPY		%G2		*%SP				 ; pBS
	SUBUS		%SP		%SP		32
	COPY		*%SP		%G3
	SUBUS		%SP		%SP		4
	COPY		*%SP		%G4
	SUBUS		%SP		%SP		4
	COPY		*%SP		%G5
	COPY		%SP		*+_pSP
	BEQ		+__SYSC_GETROM	*%G0		0x00000001
	BEQ		+__SYSC_PRINT	*%G0		0x00000002
	BEQ		+__SYSC_CREATE	*%G0		0xffffffff
	JUMP		+__SYSC_RET
	
	
__SYSC_EXIT:
	ADDUS		*+_current_PID	*+_current_PID	1		 ; i'm being incredibly lazy and building the world's most useless OS. maybe make this better if time permits
	BGTE		+_shutdown	*+_current_PID	*+_pt_entry_count
;; run next process
	;; get pt entry
	MULUS		%G0		*+_current_PID	*+_pt_entry_size
	SUBUS		%G0		*+_pt_base	%G0
	SUBUS		%G0		%G0		4
	SETBS		*%G0
	SUBUS		%G0		%G0		4
	SETLM		*%G0
	SUBUS		%G0		%G0		8
	COPY		%FP		*%G0
	SUBUS		%G0		%G0		4
	COPY		%SP		*%G0
	ADDUS		%G0		%G0		8
	JUMPMD		*%G0		0x00000006

	
__SYSC_GETROM:
	ADDUS		%G1		*+_static_device_table_base *+_static_dt_entry_size ;first entry is dt itself. no need to check it.
	COPY		%G2		0
_getrom_loop:
	BEQ		+_getrom_ret	*%G1		*+_static_none_device_code ;if we've gone through the whole table, return

	;; If this entry is a ROM, then increment the instance count
	BNEQ		+_getrom_cont	*%G1		*+_static_ROM_device_code
	ADDUS		%G2		%G2		1
_getrom_cont:	
	;; Advance to the next entry.
	ADDUS		%G1			%G1		*+_static_dt_entry_size
	JUMP		+_getrom_loop
_getrom_ret:
	ADDUS		%G0		%G0		4 		;&rv
	SUB		*%G0		%G2		3		;subtract bios, kernel, init from count + store at &rv
	JUMP		+__SYSC_RET
;;; -------------------------------------------------------------------------------------------------------------------------------
__SYSC_PRINT:	;;; Procedure: print
	ADDUS		%G4		%G0		4		 ; %G4 = &&string(virtual)
	ADDUS		%G4		*%G4		%G2		 ; &&string(physical)
	SUBUS		%SP		%SP		8		 ; Push pFP / ra
	COPY		*%SP		%FP		  		 ; pFP = %FP
	SUBUS		%SP		%SP		4		 ; push &string
	COPY		*%SP		%G4		 		 ; copy in &string
	COPY		%FP		%SP				 ; Update FP
	ADDUS		%G5		%FP		8		 ; %G5 = &ra
	COPY		%SP		%FP				 ; update %SP
	CALL		+_procedure_print		*%G5
	;; epilogue
	ADDUS		%SP		%SP		4		 ; pop &string
	COPY		%FP		*%SP				 ; %FP = pFP
	ADDUS		%SP		%SP		8		 ; pop pFP / ra

	JUMP		+__SYSC_RET
;;; --------------------------------------------------------------------------------------------------------------------------------
__SYSC_CREATE:
	MULUS		%G1		*+_pt_entry_count	48
	SUBUS		%G1		*+_pt_base	%G1
	ADDUS		%G2		%G1		40		 ; previous entry's limit
	COPY		*%G1		*+_pt_entry_count
	SUBUS		%G1		%G1		4
	ADDUS		*%G1		*%G2		32		 ; set base
	ADDUS		%G0		%G0		4		 ; $ROM # (-3)
	ADDUS		%G0		*%G0		3		 ; %G0 = ROM # to create

;;; prologue for finding ROM
	SUBUS		%SP		%SP		12		 ; Push pFP / ra / rv
	COPY		*%SP		%FP		  		 ; pFP = %FP
	COPY		%FP		%SP				 ; Update FP.
	ADDUS		%G5		%FP		4		 ; %G5 = &ra
	SUBUS		%FP		%FP		4		 ; push device instance
	COPY		*%FP		%G0				 ; rom # to find
	SUBUS		%FP		%FP		4		 ; push device type
	COPY		*%FP		2				 ; ROM device type
	COPY		%SP		%FP				 ; update %SP
	CALL		+_procedure_find_device		*%G5
;;; epilogue
	ADDUS		%SP		%SP		8		 ; pop args
	COPY		%FP		*%SP				 ; %FP = pFP
	ADDUS		%SP		%SP		8		 ; pop pFP / ra
	BEQ		+__SYSC_RET	*%SP		0		 ; ROM not found
	COPY		%G0		*%SP				 ; %G0 = pointer ROM entry in dt
	ADDUS		%SP		%SP		4		 ; pop rv

;;; DMA ROM into RAM
	ADD		%G0		%G0		4		;loc of base of ROM
	COPY		%G5		*+_static_DMA_base		;DMA src
	COPY		*%G5		*%G0				;base of ROM -> DMA src
	ADD		%G5		%G5		4		;DMA dest
	ADD		%G4		*%G2		224
	
	COPY		*%G5		%G4				;end of kernel -> DMA dest
	ADD		%G2		%G5		4		;DMA len
	ADD		%G3		%G0		4		;loc of limit of ROM
	SUB		%G3		*%G3		*%G0		;len of ROM
	ADD		%G5		%G3		%G4
	ADD		%G5		%G5		128
	SUBUS		%G1		%G1		4
	COPY		*%G1		%G5 				;set limit
	SUBUS		%G4		%G5		%G4		;virtual limit
	COPY		*%G2		%G3				;len -> DMA len

	SUBUS		%G1		%G1		4
	COPY		*%G1		0
	SUBUS		%G1		%G1		4
	COPY		*%G1		%G4
	SUBUS		%G1		%G1		4
	COPY		*%G1		%G4
	ADDUS		*+_pt_entry_count	*+_pt_entry_count	1
	JUMP		+__SYSC_RET

__SYSC_RET:			;epilogue for SYSC
	COPY		*+_pSP		%SP
	MULUS		%SP		*+_current_PID	*+_pt_entry_size
	SUBUS		%SP		*+_pt_base	%SP
	;; Restore registers
	SUBUS		%SP		%SP		44
	COPY		%G5		*%SP
	ADDUS		%SP		%SP		4
	COPY		%G4		*%SP
	ADDUS		%SP		%SP		4
	COPY		%G3		*%SP
	ADDUS		%SP		%SP		4
	COPY		%G2		*%SP
	ADDUS		%SP		%SP		4
	COPY		%G1		*%SP
	ADDUS		%SP		%SP		4
	COPY		%G0		*%SP
	ADDUS		%SP		%SP		8
	COPY		%FP		*%SP
	ADDUS		%SP		%SP		4
	COPY		*+_temp		*%SP 				 ; pIP
	ADDUS		%SP		%SP		4
	SETLM		*%SP
	ADDUS		%SP		%SP		4
	SETBS		*%SP
	SUBUS		%SP		%SP		16
	COPY		%SP		*%SP
	JUMPMD		*+_temp		0x00000006 			 ; jump back into process
	
;;; ================================================================================================================================
	.Numeric

	;; A special marker that indicates the beginning of the statics.  The value is just a magic cookie, in case any code wants
	;; to check that this is the correct location (with high probability).
_static_statics_start_marker:	0xdeadcafe

_pSP:			0
_temp:			0
	;; Device table location and codes.
_static_device_table_base:	0x00001000
_static_dt_entry_size:		12
_static_dt_base_offset:		4
_static_dt_limit_offset:	8
_static_none_device_code:	0
_static_controller_device_code:	1
_static_ROM_device_code:	2
_static_RAM_device_code:	3
_static_console_device_code:	4

	;; process table location and codes
_pt_base:			0
_pt_entry_count:		0
_pt_entry_size:			48
_current_PID:			0
;;; process table entry:
;;; PID	| base	| limit	| pIP	| pFP	| pSP	| pG0	| ... | pG5

	;; Error codes.
_static_kernel_error_RAM_not_found:	0xffff0001
_static_kernel_error_main_returned:	0xffff0002
_static_kernel_error_small_RAM:		0xffff0003	
_static_kernel_error_console_not_found:	0xffff0004
	
	;; Constants for printing and console management.
_static_console_width:		80
_static_console_height:		24
_static_space_char:		0x20202020 ; Four copies for faster scrolling.  If used with COPYB, only the low byte is used.
_static_cursor_char:		0x5f
_static_newline_char:		0x0a
	
	;; Other constants.
_static_min_RAM_KB:		64
_static_bytes_per_KB:		1024
_static_bytes_per_page:		4096	; 4 KB/page
_static_kernel_KB_size:		32	; KB taken by the kernel.

	;; Statically allocated variables.
_static_cursor_column:		0	; The column position of the cursor (always on the last row).
_static_RAM_base:		0
_static_RAM_limit:		0
_static_console_base:		0
_static_console_limit:		0
_static_kernel_base:		0
_static_kernel_limit:		0
_static_DMA_base:		0
_&IB:				0
;;; ================================================================================================================================



;;; ================================================================================================================================
	.Text

_string_banner_msg:	"k-System kernel r0 2010-06-25\n"
_string_copyright_msg:	"(c) Scott F. H. Kaplan / sfkaplan@cs.amherst.edu\n"
_string_done_msg:	"done.\n"
_string_abort_msg:	"failed!  Halting now.\n"
_string_blank_line:	"                                                                                "
;;; ================================================================================================================================