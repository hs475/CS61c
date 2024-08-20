.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:
    li t0, 1
    blt a2, t0, exit1
    blt a3, t0, exit2t
    blt a4, t0, exit2t

    # Prologue
    addi sp, sp, -4
    sw s0, 0(sp)
    li s0, 0
    slli a3, a3, 2
    slli a4, a4, 2
loop_start:
    beq a2, x0, loop_end
    lw t0, 0(a0)
    lw t1, 0(a1)
    mul t2, t0, t1
    add s0, s0, t2
    addi a2, a2, -1
    add a0, a0, a3
    add a1, a1, a4
    j loop_start
loop_end:
    mv a0, s0
    # Epilogue
    lw s0, 0(sp)
    addi sp, sp, 4
    jr ra

exit1:
    li a1, 75
    jal exit2

exit2t:
    li a1, 76
    jal exit2
