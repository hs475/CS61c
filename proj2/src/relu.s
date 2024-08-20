.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    # Prologue
    addi sp, sp, -4
    sw s0, 0(sp)
    li s0, 1
    bge a1, s0, loop_start
    li a1, 78
    jal exit2
loop_start:
    beq a1, x0, loop_end
    lw s0, 0(a0)
    bge s0, x0, loop_continue
    mv s0, x0
loop_continue:
    sw s0, 0(a0)
    addi a0, a0, 4
    addi a1, a1, -1
    j loop_start
loop_end:
    # Epilogue
    lw s0, 0(sp)
    addi sp, sp, 4 
	ret
