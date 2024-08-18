.globl factorial

.data
n: .word 7

.text
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, factorial

    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

factorial:
    # YOUR CODE HERE
    addi sp, sp, -4
    sw s0, 0(sp)
    addi s0, x0, 1
    j Loop
    lw, s0, 0(sp)
    addi sp, sp, 8
Loop:
    bge x0, a0, Done
    mul s0, s0, a0
    addi a0, a0, -1  
    j Loop
Done:
    mv a0, s0
    ret
        
        
    
    
    
    
    
  
    