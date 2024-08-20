.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:
    # Error checks
    ble a1, x0, invalid0
    ble a2, x0, invalid0
    ble a4, x0, invalid1
    ble a5, x0, invalid1
    bne a2, a4, invalid2

    # Prologue
    addi sp, sp, -12
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    mv s0, a6
outer_loop_start:
    beq a1, x0, outer_loop_end
    mv s1, a5
    mv s2, a3
inner_loop_start:
    beq a5, x0, inner_loop_end
    addi sp, sp, -32
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)
    sw a2, 12(sp)
    sw a3, 16(sp)
    sw a4, 20(sp)
    sw a6, 24(sp)
    sw a5, 28(sp)

    mv a1, a3
    mv a4, s1
    li a3, 1
    jal dot
    lw a6, 24(sp)
    sw a0, 0(a6)

    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)
    lw a2, 12(sp)
    lw a3, 16(sp)
    lw a4, 20(sp)
    lw a5, 28(sp)
    addi sp, sp, 32

    addi a6, a6, 4
    addi a5, a5, -1
    addi a3, a3, 4
    j inner_loop_start
inner_loop_end:
    li t0, 1
    mul t0, t0, a2
    slli t0, t0, 2
    add a0, a0, t0
    addi a1, a1, -1
    mv a5, s1
    mv a3, s2
    j outer_loop_start
outer_loop_end:
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    addi sp, sp, 12
    ret

invalid0:
    li a1, 72
    jal exit2

invalid1:
    li a1, 73
    jal exit2
    
invalid2:
    li a1, 74
    jal exit2