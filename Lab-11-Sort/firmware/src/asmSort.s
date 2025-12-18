/*** asmSort.s   ***/
.syntax unified

/* Declare the following to be in data memory */
.data
.align    

/* Define the globals so that the C code can access them */
/* define and initialize global variables that C can access */
/* create a string */
.global nameStr
.type nameStr,%gnu_unique_object
	
/*** STUDENTS: Change the next line to your name!  **/
nameStr: .asciz "Ben Phan"  

.align   /* realign so that next mem allocations are on word boundaries */
 
/* initialize a global variable that C can access to print the nameStr */
.global nameStrPtr
.type nameStrPtr,%gnu_unique_object
nameStrPtr: .word nameStr   /* Assign the mem loc of nameStr to nameStrPtr */

/* Tell the assembler that what follows is in instruction memory     */
.text
.align

/********************************************************************
function name: asmSwap(inpAddr,signed,elementSize)
function description:
	Checks magnitude of each of two input values 
	v1 and v2 that are stored in adjacent in 32bit memory words.
	v1 is located in memory location (inpAddr)
	v2 is located at mem location (inpAddr + M4 word size)
	
	If v1 or v2 is 0, this function immediately
	places -1 in r0 and returns to the caller.
	
	Else, if v1 <= v2, this function 
	does not modify memory, and returns 0 in r0. 

	Else, if v1 > v2, this function 
	swaps the values and returns 1 in r0

Inputs: r0: inpAddr: Address of v1 to be examined. 
				 Address of v2 is: inpAddr + M4 word size
	r1: signed: 1 indicates values are signed, 
				0 indicates values are unsigned
	r2: size: number of bytes for each input value.
				  Valid values: 1, 2, 4
				  The values v1 and v2 are stored in
				  the least significant bits at locations
				  inpAddr and (inpAddr + M4 word size).
				  Any bits not used in the word may be
				  set to random values. They should be ignored
				  and must not be modified.
Outputs: r0 returns: -1 If either v1 or v2 is 0
					  0 If neither v1 or v2 is 0, 
						and a swap WAS NOT made
					  1 If neither v1 or v2 is 0, 
						and a swap WAS made             
			 
		 Memory: if v1>v2:
			swap v1 and v2.
				 Else, if v1 == 0 OR v2 == 0 OR if v1 <= v2:
			DO NOT swap values in memory.

NOTE: definitions: "greater than" means most positive number
********************************************************************/     
.global asmSwap
.type asmSwap,%function     
asmSwap:

	/* REMEMBER TO FOLLOW THE ARM CALLING CONVENTION!            */

	/* YOUR asmSwap CODE BELOW THIS LINE! VVVVVVVVVVVVVVVVVVVVV  */
	PUSH {R4 - R11, LR}
		/* Init values */
		/*change structure a bit*/
		MOV 	R4, R0		/*base address*/
		MOV	R5, R1		/* signed flag */
		MOV 	R6, R2		/*element size */

	check_element_size:
		CMP 	R6, 1
		BEQ 	load_byte
		CMP 	R6, 2
		BEQ 	load_half
		B 	 load_word


	load_byte:
		CMP 	R5, 1
		BEQ 	load_byte_signed
		LDRB	R1, [R4]
		LDRB	R2, [R4, 4]
		B 	 check_zero
	load_byte_signed:
		LDRSB 	R1, [R4]
		LDRSB 	R2, [R4, 4]
		B 	check_zero


	load_half:
		CMP 	R5, 1
		BEQ 	load_half_signed
		LDRH 	R1, [R4]
		LDRH 	R2, [R4, 4]
		B 	check_zero
	load_half_signed:
		LDRSH 	R1, [R4]
		LDRSH 	R2, [R4, 4]
		B 	check_zero


	load_word:
		LDR 	R1, [R4]
		LDR 	R2, [R4, 4]
		B 	check_zero
	check_zero:
		CMP 	R1, 0
		BEQ 	return_neg1
		CMP 	R2, 0
		BEQ 	return_neg1

		CMP 	R1, R2
		BLE 	return_no_swap


	do_swap:
		CMP 	R6, 1
		BEQ 	swap_byte
		CMP 	R6, 2
		BEQ 	swap_half

	swap_word:
		STR 	R2, [R4]
		STR 	R1, [R4, 4]
		MOV 	R0, 1
		B 	end_swap

	swap_byte:
		STRB 	R2, [R4]
		STRB 	R1, [R4, 4]
		MOV 	R0, 1
		B 	end_swap

	swap_half:
		STRH 	R2, [R4]
		STRH 	R1, [R4, 4]
		MOV 	R0, 1
		B 	end_swap

	return_no_swap:
		MOV 	R0, 0
		B 	end_swap

	return_neg1:
		MOV 	R0, -1
	end_swap:
	POP {R4 - R11, LR}
	BX LR
	/* YOUR asmSwap CODE ABOVE THIS LINE! ^^^^^^^^^^^^^^^^^^^^^  */
	
	
/********************************************************************
function name: asmSort(startAddr,signed,elementSize)
function description:
	Sorts value in an array from lowest to highest.
	The end of the input array is marked by a value
	of 0.
	The values are sorted "in-place" (i.e. upon returning
	to the caller, the first element of the sorted array 
	is located at the original startAddr)
	The function returns the total number of swaps that were
	required to put the array in order in r0. 
	
		 
Inputs: r0: startAddr: address of first value in array.
			  Next element will be located at:
						  inpAddr + M4 word size
	r1: signed: 1 indicates values are signed, 
				0 indicates values are unsigned
	r2: elementSize: number of bytes for each input value.
						  Valid values: 1, 2, 4
Outputs: r0: number of swaps required to sort the array
		 Memory: The original input values will be
				 sorted and stored in memory starting
		 at mem location startAddr
NOTE: definitions: "greater than" means most positive number    
********************************************************************/     
.global asmSort
.type asmSort,%function
asmSort:   

	/* REMEMBER TO FOLLOW THE ARM CALLING CONVENTION! GOT IT!!!*/

	/* YOUR asmSort CODE BELOW THIS LINE! VVVVVVVVVVVVVVVVVVVVV  */
	PUSH {R4-R11, lr}

	/* Init values */
	MOV R4, R0      /* base address */
	MOV R5, R1      /* signed */
	MOV r6, R2      /* elementSize */
	MOV R7, 0      /* swapCount */
	MOV R8, 0      /* madeSwap */
	MOV R9, R4      /* pointer */

	sort_loop:
		MOV R0, R9	
		MOV R1, R5
		MOV R2, r6
		BL asmSwap

		CMP R0, -1	
		BEQ end_of_arr

		CMP R0, 1	
		BEQ did_swap
		
	no_swap: /*asmSort returned 0*/
		ADD R9, R9, 4
		B sort_loop

	did_swap:
		ADD R7, R7, 1
		MOV R8, 1
		ADD R9, R9, 4
		B sort_loop

	end_of_arr:
		CMP R8, 1
		BEQ last_pass
		B   sort_done
		
	last_pass: /* made sure the array is fully sorted */
		MOV R8, 0
		MOV R9, R4
		B sort_loop
		
	sort_done:
		MOV 	R0, R7           /* return swapCount */

		POP {R4-R11, LR}
		BX LR
	/* YOUR asmSort CODE ABOVE THIS LINE! ^^^^^^^^^^^^^^^^^^^^^  */

   

/**********************************************************************/   
.end  /* The assembler will not process anything after this directive!!! */