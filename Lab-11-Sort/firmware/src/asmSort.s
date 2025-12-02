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
		MOV 		R4, R0
		/*R4 baseAddr, R5 V1, R6 V2*/

		/* sign, size */
		MOV		R7, R1
		MOV 	R8, R2

		CMP 	R8, 1
		BEQ 	load_byte
		CMP 	R8, 2
		BEQ 	load_half

		load_word:
			LDR		R5, [R4]
			LDR		R6, [R4, 4]
			B 	 	sign_ext

		load_byte:
			LDRB	R5, [R4]
			LDRB	R6, [R4, 4]
			B 	 	sign_ext

		load_half:
			LDRH	R5, [R4]
			LDRH	R6, [R4, 4]
			B 	 	sign_ext

		sign_ext:
			CMP 	R7, 1
			BNE 	compare_values   /* skip extension */

			/* SIGN EXTEND */
			CMP 	R8, 1
			BEQ 	sign_ext_byte
			CMP 	R8, 2
			BEQ 	sign_ext_half
			B   compare_values   /* else skip, size = 4 -> can skip */

		sign_ext_byte:
			LSL R5, R5, 24
			ASR R5, R5, 24
			LSL R6, R6, 24
			ASR R6, R6, 24
			B compare_values

		sign_ext_half:
			LSL R5, R5, 16
			ASR R5, R5, 16
			LSL R6, R6, 16
			ASR R6, R6, 16
			B compare_values

		/* returns */
		compare_values:
			CMP 	R5, 0
			BEQ 	return_neg1
			CMP 	R6, 0
			BEQ 	return_neg1

			CMP R5, R6
			BGT do_swap

		return_no_swap:
			MOV R0, 0
			B end

		do_swap:
			/* write only elementSize bytes */
			CMP			R8, 1
			BEQ			swap_byte
			CMP			R8, 2
			BEQ			swap_half

		swap_word:
			STR			R6, [R4]
			STR			R5, [R4, 4]
			MOV			R0, 1
			B    		end

		swap_byte:
			STRB		R6, [R4]
			STRB		R5, [R4, 4]
			MOV			R0, 1
			B			end

		swap_half:
			STRH 		R6, [R4]
			STRH 		R5, [R4, 4]
			MOV			R0, 1
			B			end

		return_neg1:
			MOV			R0, -1


		end:

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
    PUSH {R4-R11, LR}

    /* init */
    MOV 	R4, R0      /* baseAddr*/
    MOV 	R5, R1      /* signed flag */
    MOV 	R6, R2      /* elementSize */
    MOV 	R7, 0      /* swapCount */

	outer_loop:
		MOV 	R8, 0      /* reset/init madeSwap = 0 */
		MOV 	R9, R4      /* ptr = startAddr */

	inner_loop:
		CMP		R6, 1
		BEQ 	sort_load_byte
		CMP		R6, 2
		BEQ 	sort_load_half

	sort_load_word:
		LDR 	R10, [R9]
		B     	check_v1

	sort_load_byte:
		LDRB	R10, [R9]
		B     	check_v1

	sort_load_half:
		LDRH	R10, [R9]

	check_v1:
		CMP		R10, 0
		BEQ 	end_of_pass

		/* asmSwap(pointer, signed, size) */
		MOV 	R0, R9           /* pointer */
		MOV 	R1, R5           /* signed flag */
		MOV 	R2, R6           /* element size */
		BL    	asmSwap

		/* check return value*/
		CMP		R0, -1
		BEQ 	finish           /* sort completed */

		CMP		R0, 0
		BEQ		increment_pointer      /* no swap */

		/* swap happened */
		ADD   	R7, R7, 1       /* swapCount++ */
		MOV 	R8, 1           /* madeSwap = 1 */

	increment_pointer:
		ADD		R9, R9, 4
		B		inner_loop

	end_of_pass:
		CMP		R8, 0
		BEQ 	finish           /* no swap this pass -> sorted */

		/* else, another pass needed */
		B     	outer_loop

	finish:
		MOV 	R0, R7           /* return swapCount */

		POP {R4-R11, LR}
		BX LR
	/* YOUR asmSort CODE ABOVE THIS LINE! ^^^^^^^^^^^^^^^^^^^^^  */

   

/**********************************************************************/   
.end  /* The assembler will not process anything after this directive!!! */
		   




