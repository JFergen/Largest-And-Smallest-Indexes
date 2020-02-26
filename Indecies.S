	.data
	.type	v, %object
	.type	i, %object
	.type	n, %object
	.size	v, 6
	.size   n, 1
n:
	.xword 6
v:
	.xword	57, 61, 25, 7, 39, 18    // 64-bit values

	.text
	.global	main
	.global find_smallest_index
	.global find_largest_index
	.global find_sum
	.arch armv8-a+fp+simd
	.type find_smallest_index, %function
	.type find_largest_index, %function
	.type find_sum, %function
	.type	main, %function

find_smallest_index:
	// X0 contains address of a; X1 contains n,
	// X2 will contain smallest value returned
	// X3 will contain the index of smallest value returned

	// Make room on stack and store variables
	SUB SP, SP, #16
    STUR X1, [SP, #8]
    STUR X0, [SP, #0]

    LDUR X1, [X1, #0]	// Get n
    LDUR X2, [X0, #0]	// Smallest = A[0]
    SUB X3, X3, X3		// Index = 0
    SUB X4, X4, X4		// i = 0
loopSmall:
	LDUR X5, [X0, #0]	// a[i]
	SUBS X6, X5, X2		// X6 = a[i] - a[0]
	B.GT elseSmall		// If a[i] < a[0]
	LDUR X2, [X0, #0]	// Change smallest = a[i]
	SUB X3, X3, X3
	ADD X3, X3, X4		// Index = i
elseSmall:				// else
	ADD X4, X4, #1		// i = i + 1
	ADD X0, X0, #8		// Next array element
	SUB X5, X4, X1
	CBNZ X5, loopSmall	// If i < n, loop again

	// Load back variables
	LDUR X0, [SP, #0]
	LDUR X1, [SP, #8]
	ADD SP, SP, #16

	MOV X8, X3	// Move index of smallest number to be in X8
	BR X30

find_largest_index:
	// X0 contains address of a; X1 contains n,
	// X2 will contain largest value returned
	// X3 will contain the index of largest value returned

	// Make room on stack and store variables
	SUB SP, SP, #16
    STUR X1, [SP, #8]
    STUR X0, [SP, #0]

    LDUR X1, [X1, #0]	// Get n
    LDUR X2, [X0, #0]	// Largest = A[0]
    SUB X3, X3, X3		// Index = 0
    SUB X4, X4, X4		// i = 0
loopLarge:
	LDUR X5, [X0, #0]	// a[i]
	SUBS X6, X5, X2		// X6 = a[i] - a[0]
	B.LT elseLarge		// If a[i] > a[0]
	LDUR X2, [X0, #0]	// Change largest = a[i]
	SUB X3, X3, X3
	ADD X3, X3, X4		// Index = i
elseLarge:				// else
	ADD X4, X4, #1		// i = i + 1
	ADD X0, X0, #8		// Next array element
	SUB X5, X4, X1
	CBNZ X5, loopLarge		// If i < n, loop again

	// Load back variables
	LDUR X0, [SP, #0]
	LDUR X1, [SP, #8]
	ADD SP, SP, #16

	MOV X7, X3	// Move index of largest number to be in X7
	BR X30

find_sum:
	// X0 contains address of a; X1 contains n,
	// X2 will contain sum returned

	// Make room on stack and store variables
	SUB SP, SP, #16
    STUR X1, [SP, #8]
    STUR X0, [SP, #0]

    LDUR X1, [X1, #0]	// Get n
    SUB X2, X2, X2		// sum = 0
    SUB X3, X3, X3		// i = 0
loopSum:
	LDUR X4, [X0, #0]	// a[i]
	ADD X2, X2, X4		// sum = sum + a[i]
	ADD X3, X3, #1		// i = i + 1
	ADD X0, X0, #8		// Next array element
	SUB X5, X3, X1
	CBNZ X5, loopSum	// If i < n, loop again

	// Load back variables
	LDUR X0, [SP, #0]
	LDUR X1, [SP, #8]
	ADD SP, SP, #16

	MOV X6, X2	// Move sum to be in X2
	BR X30

find_values:
        SUB SP, SP, #16		// Make room on stack
        STUR X30, [SP, #8]	// Save return address

        BL find_smallest_index
        BL find_largest_index
        BL find_sum

        LDUR X30, [SP, #8]	// Load back return address
        ADD SP, SP, #16		// Reset stack pointer
        BR X30

main:
	ADRP X0, v           	// Load the array address to X0
	ADD X0, X0, :lo12:v
	ADRP X1, n           	// Address of n
	ADD X1, X1, :lo12:n

	BL find_values	// Call find_values
exit:
