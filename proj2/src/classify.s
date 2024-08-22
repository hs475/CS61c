.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
    li t0, 5
    bne a0, t0, args_fail

    addi sp, sp, -40
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)

    mv s0, a0
    mv s5, a1
    mv s7, a1
    mv s8, a2

	# =====================================
    # LOAD MATRICES
    # =====================================
    # Load pretrained m0, s0
    li a0, 32
    jal malloc
    ble a0, x0, malloc_fail
    mv s4, a0
    mv a1, s4
    addi a2, s4, 4
    lw a0, 4(s5)
    jal read_matrix
    mv s0, a0
    # Load pretrained m1, s1
    addi a1, s4, 8
    addi a2, s4, 12
    lw a0, 8(s5)
    jal read_matrix
    mv s1, a0
    # Load input matrix, s2
    addi a1, s4, 16
    addi a2, s4, 20
    lw a0, 12(s5)
    jal read_matrix
    mv s2, a0
    
    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    lw t1, 0(s4)
    lw t2, 20(s4)
    mul t0, t1, t2
    slli t0, t0, 2
    mv a0, t0
    jal malloc
    ble a0, x0, malloc_fail
    mv a6, a0
    mv s5, a6
    mv a0, s0
    mv a3, s2
    lw a1, 0(s4)
    lw a2, 4(s4)
    lw a4, 16(s4)
    lw a5, 20(s4)

    jal matmul
    mv a0, s5
    lw t0, 0(s4)
    lw t1, 20(s4)
    mul a1, t0, t1
    jal relu

    lw t1, 8(s4)
    lw t2, 20(s4)
    mul t0, t1, t2
    slli t0, t0, 2
    mv a0, t0
    jal malloc
    ble a0, x0, malloc_fail
    mv s6, a0

    mv a0, s1
    lw a1, 8(s4)
    lw a2, 12(s4)
    mv a3, s5
    lw a4, 0(s4)
    lw a5, 20(s4)
    mv a6, s6
    jal matmul
    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0, 16(s7)
    mv a1, s6
    lw a2, 8(s4)
    lw a3, 20(s4)
    jal write_matrix
    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    lw t1, 8(s4)
    lw t2, 20(s4)
    mul a1, t1, t2
    mv a0, s6
    jal argmax
    # Print classification
    bne s8, zero, done
    mv a1, a0
    jal print_int
    # Print newline afterwards for clarity
    li a1 '\n'
    jal print_char

done:
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    addi sp, sp, 40
    ret

args_fail:
    li a1, 89
    jal exit2

malloc_fail:
    li a1, 88
    jal exit2
