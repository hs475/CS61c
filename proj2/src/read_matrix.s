.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -28
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw ra, 12(sp)
    sw s3, 16(sp)
    sw s6, 20(sp)
    sw s7, 24(sp)

    mv s6, a1
    mv s7, a2

    mv s0, a1
    mv a1, a0
    li a2, 0

    jal fopen
    li t0, -1
    beq a0, t0, fopen_failed
    mv s0, a0
    li a0, 8
    jal malloc
    beq a0, x0, malloc_failed
    mv a1, s0
    mv a2, a0
    mv s3, a0
    li a3, 8
    addi sp, sp, -4
    sw a2, 0(sp)
    jal fread
    li t0, -1
    beq a0, t0, fread_fail
    lw a2, 0(sp)
    addi sp, sp, 4

    lw s1, 0(a2)
    lw s2, 4(a2)
    sw s1, 0(s6)
    sw s2, 0(s7)

    mul t0, s1, s2
    slli t0, t0, 2
    add a3, x0, t0
    mv a0, a3
    jal malloc
    beq a0, x0, malloc_failed
    mv a1, s0
    mv a2, a0
    addi sp, sp, -4
    sw a2, 0(sp)
    jal fread
    li t0, -1
    beq a0, t0, fread_fail
    lw a2, 0(sp)
    addi sp, sp, 4

    # Epilogue
    mv a0, a2
    mv s1, a0
    mv a0, s0
    jal fclose
    li t0, -1
    beq a0, t0, fclose_fail
    mv a0, s1
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw ra, 12(sp)
    lw s3, 16(sp)
    lw s6, 20(sp)
    lw s7, 34(sp)
    addi sp, sp, 28
    ret

malloc_failed:
    li a1, 88
    jal exit2

fopen_failed:
    li a1, 90
    jal exit2

fread_fail:
    li a1, 91
    jal exit2

fclose_fail:
    li a1, 92
    jal exit2