# CSE 220 Programming Project #2
# Vivian Yee
# VIYEE
# 112145534

#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################

.text

strlen:
    addi $sp, $sp, -4
    sw $s0, 0($sp)
    move $s0, $a0 #
    li $t0, 0 # Counter
    strlen_loop:
        lbu $t1, 0($s0)
        beqz $t1, strlen_endloop
        addi $s0, $s0, 1
        addi $t0, $t0, 1
        j strlen_loop
    strlen_endloop:
        lw $s0, 0($sp)
        addi $sp, $sp, 4
        move $v0, $t0
        jr $ra


index_of:
    addi $sp, $sp, -16
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    move $s0, $a0 # list
    move $s1, $a1 # char
    li $s2, 0 # Counter
    index_of_loop:
        lbu $s3, 0($s0)
        beqz $s3, index_of_no_endloop
        beq $s3, $s1, index_of_endloop
        addi $s0, $s0, 1
        addi $s2, $s2, 1
        j index_of_loop
    index_of_no_endloop:
        lw $s0, 0($sp)
        lw $s1, 4($sp)
        lw $s2, 8($sp)
        lw $s3, 12($sp)
        addi $sp, $sp, 16
        li $v0, -1
        jr $ra
    index_of_endloop:
        move $v0, $s2
        lw $s0, 0($sp)
        lw $s1, 4($sp)
        lw $s2, 8($sp)
        lw $s3, 12($sp)
        addi $sp, $sp, 16
        jr $ra


bytecopy:
    addi $sp, $sp, -28
    sw $s0, 4($sp) # first array
    sw $s1, 8($sp) # first array index
    sw $s2, 12($sp) # second array
    sw $s3, 16($sp) # second array index
    sw $s4, 20($sp)
    sw $s5, 24($sp)
    move $s0, $a0 # 
    move $s1, $a1 # 
    move $s2, $a2 # 
    move $s3, $a3 # 
    blez $t0, NAN_bytecopy
    bltz $s1, NAN_bytecopy
    bltz $s3, NAN_bytecopy
    li $s4, 0
    add $s0, $s0, $s1 # starting of first array
    add $s2, $s2, $s3 # starting of second array
    bytecopy_loop_first_array:
        beq $s4, $t0, bytecopy_loop_second_array
        lb $s5, 0($s0) # t2 holds ASCII letter
        sb $s5, 0($s2)
        addi $s4, $s4, 1
        addi $s0, $s0, 1
        addi $s2, $s2, 1
        j bytecopy_loop_first_array
    bytecopy_loop_second_array:
        move $v0, $t0
        lw $s0, 4($sp)
        lw $s1, 8($sp)
        lw $s2, 12($sp)
        lw $s3, 16($sp)
        lw $s4, 20($sp)
        lw $s5, 24($sp)
        addi $sp, $sp, 28
        jr $ra
    NAN_bytecopy:
        li $t0, -1
        move $v0, $t0
        lw $s0, 4($sp)
        lw $s1, 8($sp)
        lw $s2, 12($sp)
        lw $s3, 16($sp)
        lw $s4, 20($sp)
        lw $s5, 24($sp)
        addi $sp, $sp, 28
        jr $ra
    
    
scramble_encrypt:
    addi $sp, $sp, -12
    sw $s0, 0($sp) # ciphertext
    sw $s1, 4($sp) # plain text
    sw $s2, 8($sp) # alphabet
    move $s0, $a0 #
    move $s1, $a1 #
    move $s2, $a2 #
    li $t0, 64
    li $t1, 96
    li $t6, 0 # counter
    scramble_encrypt_loop:
        lb $t2, 0($s1)
        beqz $t2, scramble_encrypt_loop_end
        bgt $t2, $t0, scramble_encrypt_loop_check
        j scramble_encrypt_loop_other
        scramble_encrypt_loop_check:
            blt $t2, $t1, scramble_encrypt_loop_upper
            scramble_encrypt_loop_lower:
                addi $t3, $t2, -71
                j scramble_encrypt_loop_2
            scramble_encrypt_loop_upper:
                addi $t3, $t2, -65
         scramble_encrypt_loop_2:
             add $t4, $s2, $t3
             lb $t5, 0($t4)
             sb $t5, 0($s0)
             j scramble_encrypt_loop_count
         scramble_encrypt_loop_other:
             lb $t5, 0($s1)
             sb $t5, 0($s0)
             addi $t6, $t6, -1
         scramble_encrypt_loop_count:
             addi $s1, $s1, 1
             addi $s0, $s0, 1
             addi $t6, $t6, 1
             j scramble_encrypt_loop
    scramble_encrypt_loop_end:
        sb $t2, 0($s0)
        lw $s0, 0($sp)
        lw $s1, 4($sp) 
        lw $s2, 8($sp)
        addi $sp, $sp, 12
        move $v0, $t6
        jr $ra


scramble_decrypt:
    addi $sp, $sp, -16
    sw $s0, 0($sp) # plain text
    sw $s1, 4($sp) # ciphertext
    sw $s2, 8($sp) # alphabet
    sw $ra, 12($sp) # return for scramble_decrypt
    move $s0, $a0 #
    move $s1, $a1 #
    move $s2, $a2 #
    li $t0, 0 # counter
    li $t3, 52
    li $t4, 25
    li $t5, -1
    scramble_decrypt_loop:
        lb $t1, 0($s1)
        beqz $t1, scramble_decrypt_loop_end
        move $a0, $s2
        move $a1, $t1
        jal index_of
        move $t2, $v0
        ble $t2, $t4, scramble_decrypt_loop_upper
        blt $t2, $t3, scramble_decrypt_loop_lower
            scramble_decrypt_loop_other:
                sb $t1, 0($s0)
                addi $t0, $t0, -1
                j scramble_decrypt_loop_counter
            scramble_decrypt_loop_lower:
                addi $t2, $t2, 71
                sb $t2, 0($s0)
                j scramble_decrypt_loop_counter
            scramble_decrypt_loop_upper:
                beq $t2, $t5, scramble_decrypt_loop_other
                addi $t2, $t2, 65
                sb $t2, 0($s0)
        scramble_decrypt_loop_counter:
            addi $t0, $t0, 1
            addi $s0, $s0, 1
            addi $s1, $s1, 1
            j scramble_decrypt_loop
    scramble_decrypt_loop_end:
        sb $t1, 0($s0)
        lw $s0, 0($sp) # plain text
        lw $s1, 4($sp) # ciphertext
        lw $s2, 8($sp) # alphabet
        lw $ra, 12($sp)
        addi $sp, $sp, 16
        move $v0, $t0
	jr $ra


base64_encode:
    addi $sp, $sp, -12
    sw $s0, 0($sp) # encoded
    sw $s1, 4($sp) # str
    sw $s2, 8($sp) # base64_table
    move $s0, $a0
    move $s1, $a1
    move $s2, $a2
    li $t3, 3
    li $t7, 0 # counter
    base64_encode_loop:
        li $t0, 0 # holder
        base64_encode_bits:
            beq $t3, $t7, base64_encode_bits_endloop
            lb $t1, 0($s1)
            beqz $t1, base64_encode_bits_end # if str is end
            sll $t0, $t0, 8
            add $t0, $t0, $t1
            addi $t7, $t7, 1
            addi $s1, $s1, 1
            j base64_encode_bits
        base64_encode_bits_endloop:
            addi $t3, $t3, 3
            li $t4, 8
            base64_encode_bits_divide:
                li $t6, 32
                beq $t4, $t6, base64_encode_loop
                sllv $t5, $t0, $t4
                srl $t5, $t5, 26
                add $t6, $s2, $t5
                lb $t5, 0($t6)
                sb $t5, 0($s0)
                addi $t4, $t4, 6
                addi $s0, $s0, 1
                j base64_encode_bits_divide
        base64_encode_bits_end:
            move $t5, $t7
            li $t6, -1
            mul $t7, $t7, $t6
            add $t7, $t3, $t7 # how much left
            li $t2, 1
            li $t3, 2
            li $t4, 3
            beq $t4, $t7, base64_encode_bits_storeback
            beq $t2, $t7, base64_encode_bits_end_loop_twoe
            beq $t3, $t7, base64_encode_bits_end_loop_onee
            base64_encode_bits_end_loop_onee:
                li $t7, 20
                li $t2, 32
                sll $t0, $t0, 4
                base64_encode_bits_end_loop_onee1:
                    beq $t7, $t2, base64_encode_bits_end_loop_onee1e
                    sllv $t4, $t0, $t7
                    srl $t4, $t4, 26
                    add $t6, $s2, $t4                    
                    lb $t4, 0($t6)
                    sb $t4, 0($s0)
                    addi $t7, $t7, 6
                    addi $s0, $s0, 1
                    j base64_encode_bits_end_loop_onee1
                base64_encode_bits_end_loop_onee1e:
                    li $t7, '='
                    sb $t7, 0($s0)
                    addi $s0, $s0, 1
                    sb $t7, 0($s0)
                    addi $s0, $s0, 1
                    j base64_encode_bits_storeback
            base64_encode_bits_end_loop_twoe:
                li $t7, 14
                li $t2, 32
                sll $t0, $t0, 3
                base64_encode_bits_end_loop_twoe1:
                    beq $t7, $t2, base64_encode_bits_end_loop_twoe1e
                    sllv $t4, $t0, $t7
                    srl $t4, $t4, 26
                    add $t6, $s2, $t4
                    lb $t4, 0($t6)
                    sb $t4, 0($s0)
                    addi $t7, $t7, 6
                    addi $s0, $s0, 1
                    j base64_encode_bits_end_loop_twoe1
                base64_encode_bits_end_loop_twoe1e:
                    li $t7, '='
                    sb $t7, 0($s0)
                    addi $s0, $s0, 1
                    j base64_encode_bits_storeback
    base64_encode_bits_storeback:
        li $t0, 0
        sb $t0, 0($s0)
        lw $s0, 0($sp) # encoded
        lw $s1, 4($sp) # str
        lw $s2, 8($sp)
        addi $sp, $sp, 12
        move $v0, $t5
        jr $ra


base64_decode:
    addi $sp, $sp, -16
    sw $s0, 0($sp) # decoded
    sw $s1, 4($sp) # encoded
    sw $s2, 8($sp) # base_table
    sw $ra, 12($sp) # label
    move $s0, $a0
    move $s1, $a1
    move $s2, $a2
    li $t0, 0 # counter
    li $t3, 0 # holder
    li $t5, 4
    li $t7, 0 # v0
    base64_decode_loop:
        beq $t5, $t0, base64_decode_loop_end
        lb $t1, 0($s1)
        li $t2, '='
        beq $t2, $t1, base64_decode_end
        beqz $t1, base64_decode_end_it_all
        move $a0, $s2 # table
        move $a1, $t1 # character
        jal index_of
        move $t2, $v0 # index of char
        sll $t3, $t3, 6
        add $t3, $t3, $t2
        addi $t0, $t0, 1
        addi $s1, $s1, 1
        j base64_decode_loop
        base64_decode_loop_end:
            addi $t5, $t5, 4
            li $t6, 8
            li $t4, 32 # counter
            base64_decode_loop_2:
                beq $t4, $t6, base64_decode_loop
                sllv $t2, $t3, $t6
                srl $t2, $t2, 24
                sb $t2, 0($s0)
                addi $t7, $t7, 1
                addi $s0, $s0, 1
                addi $t6, $t6, 8
                j base64_decode_loop_2
        base64_decode_end:
            li $t2, -1
            mul $t4, $t0, $t2
            add $t2, $t5, $t4 # how many = there are
            li $t4, 2
            beq $t4, $t2, base64_one_letter
            li $t4, 1
            beq $t4, $t2, base64_two_letter
            base64_one_letter:
                srl $t3, $t3, 4
                sb $t3, 0($s0)
                addi $t7, $t7, 1
                addi $s0, $s0, 1
                j base64_decode_end_it_all
            base64_two_letter:
                sll $t2, $t3, 14
                srl $t2, $t2, 24
                sb $t2, 0($s0)
                addi $t7, $t7, 2
                addi $s0, $s0, 1
                sll $t2, $t3, 22
                srl $t2, $t2, 24
                sb $t2, 0($s0)
                addi $s0, $s0, 1
        base64_decode_end_it_all:
            li $t2, 0
            sb $t2, 0($s0)
            move $v0, $t7
            lw $s0, 0($sp) # decoded
            lw $s1, 4($sp) # encoded
            lw $s2, 8($sp) # base_table
            lw $ra, 12($sp)
            addi $sp, $sp, 16   
	    jr $ra


bifid_encrypt:
    lw $t0, 0($sp)
    addi $sp, $sp, -36
    sw $s0, 0($sp) # cipher
    sw $s1, 4($sp) # plain
    sw $s2, 8($sp) # key_square
    sw $s3, 12($sp) # period
    sw $ra, 16($sp)
    sw $s4, 20($sp)
    sw $s5, 24($sp)
    sw $s6, 28($sp)
    sw $s7, 32($sp)
    move $s0, $a0
    move $s1, $a1
    move $s2, $a2
    move $s3, $a3
    li $t7, 0 # counter
    move $t4, $s1
    blez $s3, bifid_encrypt_end
    lw $t0, 36($sp)
    bifid_encrypt_loop:
        lb $t1, 0($t4)
        beqz $t1, bifid_encrypt_loop2
        move $a0, $s2 # key_square
        move $a1, $t1 # char
        jal index_of
        move $t2, $v0
        li $t3, 9
        div $t2, $t3
        mflo $t3 # number of rows
        sb $t3, 0($t0)
        lb $t3, 0($t0)
        addi $t4, $t4, 1
        addi $t7, $t7, 1
        addi $t0, $t0, 1
        j bifid_encrypt_loop
    bifid_encrypt_loop2:
        lb $t1, 0($s1)
        beqz $t1, bifid_encrypt_loop2_1
        move $a0, $s2 # key_square
        move $a1, $t1 # char
        jal index_of
        move $t2, $v0
        li $t3, 9
        div $t2, $t3
        mfhi $t3 # number of columns
        sb $t3, 0($t0)
        lb $t3, 0($t0)
        addi $s1, $s1, 1
        addi $t7, $t7, 1
        addi $t0, $t0, 1
        li $s4, 1
        j bifid_encrypt_loop
        bifid_encrypt_loop2_1:
            move $t4, $t7
            li $t3, -1
            mul $t7, $t7, $t3
            add $t0, $t0, $t7
            mul $t7, $t7, $t3
            div $t7, $s3
            mflo $s5
            mfhi $s6
            li $t3, 2
            div $s6, $t3
            mflo $s6
            div $s5, $t3
            mflo $s5
            addi $s5, $s5, 1 # remainder
            div $t7, $t3
            mflo $t2 # length of row/col
            div $t7, $s3
            mflo $t5
            div $t5, $t3
            mflo $t3 # number of groups for row/column
            lw $t1, 40($sp)
            li $t7, 0 # counter
            bifid_encrypt_loop_2_1_1: # get first period
                beq $s4, $s5, bifid_encrypt_end_noncomplete
                beq $t7, $s3, bifid_encrypt_loop2_1_2
                lb $t6, 0($t0)
                lw $t4, 0($sp)
                sb $t6, 0($t1)
                addi $t1, $t1, 1
                addi $t0, $t0, 1
                addi $t7, $t7, 1
                j bifid_encrypt_loop_2_1_1
            bifid_encrypt_loop2_1_2: # get second period
                li $t6, -1
                mul $t7, $t7, $t6 # reset
                add $t0, $t0, $t7 # good
                move $t4, $t0
                add $t4, $t4, $t2
                li $t7, 0
                bifid_encrypt_3:
                    beq $t7, $s3, bifid_encrypt_3_1
                    lb $t6, 0($t4)
                    sb $t6, 0($t1)
                    addi $t1, $t1, 1
                    addi $t4, $t4, 1
                    addi $t7, $t7, 1
                    j bifid_encrypt_3
                    bifid_encrypt_3_1:
                        li $t7, -2
                        mul $t7, $s3, $t7
                        add $t1, $t1, $t7
                        li $t7, 0
                        addi $sp, $sp, -4
                        sw $t2, 0($sp)
                        add $t2, $s3, $s3
                        bifid_encrypt_3_2:
                            beq $s3, $t7, bifid_encrypt_loop_2_1_1_setup
                            lb $t4, 0($t1)
                            li $t6, 9
                            mul $t6, $t4, $t6 # row num
                            addi $t1, $t1, 1
                            lb $t4, 0($t1)
                            add $t6, $t4, $t6 # index
                            add $t5, $t6, $s2
                            move $a0, $t5
                            li $a1, 0
                            move $a2, $s0
                            li $a3, 0
                            addi $sp, $sp, -4
                            sw $t0, 0($sp)
                            li $t0, 1
                            jal bytecopy
                            lw $t0, 0($sp)
                            addi $sp, $sp, 4
                            addi $s0, $s0, 1
                            addi $t7, $t7, 1
                            addi $t1, $t1, 1
                            j bifid_encrypt_3_2
                    bifid_encrypt_loop_2_1_1_setup:
                        lw $t2, 0($sp)
                        addi $sp, $sp, 4
                        addi $s4, $s4, 1
                        add $t0, $t0, $s3
                        lw $t1, 40($sp)
                        li $t7, 0
                        j bifid_encrypt_loop_2_1_1
            bifid_encrypt_end_noncomplete:
                div $t2, $s3
                mfhi $s5
                add $t5, $t0, $s6
                li $t6, 0
                bifid_encrypt_end_noncomplete_loop:
                    beq $t6, $s5, bifid_encrypt_end_noncomplete_loop2
                    lb $t7, 0($t0)
                    sb $t7, 0($t1)
                    addi $t0, $t0, 1
                    addi $t6, $t6, 1
                    addi $t1, $t1, 1
                    j bifid_encrypt_end_noncomplete_loop
                bifid_encrypt_end_noncomplete_loop2:
                    li $t4, -1
                    mul $t4, $t6, $t4
                    add $t0, $t0, $t4
                    add $t4, $t0, $t2
                    add $t5, $t4, $s6
                    li $t6, 0
                    bifid_encrypt_end_noncomplete_loop2_1:
                        beq $t6, $s5, bifid_encrypt_end_almost
                        lb $t7, 0($t4)
                        sb $t7, 0($t1)
                        addi $t4, $t4, 1
                        addi $t1, $t1, 1
                        addi $t6, $t6, 1
                        j bifid_encrypt_end_noncomplete_loop2_1
                        bifid_encrypt_end_almost:
                            li $t5, -2
                            mul $t6, $t6, $t5
                            add $t1, $t1, $t6
                            li $t5, -1
                            mul $t6, $t6, $t5
                            add $t6, $t1, $t6
                            bifid_encrypt_end_almost1:
                                beq $t1, $t6, bifid_encrypt_end
                                lb $t5, 0($t1)
                                li $t4, 9 # how many columns
                                mul $t4, $t5, $t4
                                addi $t1, $t1, 1
                                lb $t5, 0($t1)
                                add $t4, $t4, $t5 # index
                                add $t4, $t4, $s2
                                move $a0, $t4
                                li $a1, 0
                                move $a2, $s0
                                li $a3, 0
                                addi $sp, $sp, -4
                                sw $t0, 0($sp)
                                li $t0, 1
                                jal bytecopy
                                lw $t0, 0($sp)
                                addi $sp, $sp, 4
                                addi $t1, $t1, 1
                                addi $s0, $s0, 1
                                j bifid_encrypt_end_almost1
        bifid_encrypt_end:
            li $t2, 0
            sb $t2, 0($s0)
            blez $s3, bifid_encrypt_end_2
            addi $t3, $t3, 1
            move $v0, $t3
            j bifid_encrypt_end_cont
            bifid_encrypt_end_2:
                li $t3, -1
                move $v0, $t3
            bifid_encrypt_end_cont:
            lw $s0, 0($sp) # cipher
            lw $s1, 4($sp) # plain
            lw $s2, 8($sp) # key_square
            lw $s3, 12($sp) # period
            lw $ra, 16($sp)
            lw $s4, 20($sp)
            lw $s5, 24($sp)
            lw $s6, 28($sp)
            lw $s7, 32($sp)
            addi $sp, $sp, 36
	     jr $ra


bifid_decrypt:
    lw $t0, 0($sp)
    addi $sp, $sp, -32
    sw $s0, 0($sp) # plain
    sw $s1, 4($sp) # cypher
    sw $s2, 8($sp) # key_square
    sw $s3, 12($sp) # period
    sw $ra, 16($sp)
    
    sw $s4, 20($sp)
    sw $s5, 24($sp)
    sw $s6, 28($sp)
    lw $s6, 32($sp)
    
    move $s0, $a0
    move $s1, $a1
    move $s2, $a2
    move $s3, $a3
    blez $s3, bifid_encrypt_end
    move $t3, $s1
    li $t2, 0 # length of row/col
    bifid_decrypt_count:
        lb $t1, 0($t3)
        beqz $t1, bifid_decrypt_count_done
        addi $t3, $t3, 1
        addi $t2, $t2, 1
        j bifid_decrypt_count
    bifid_decrypt_count_done:
        div $t2, $s3
        mflo $s4 # number of groups
        mfhi $s5 # remaining/2s
        li $t3, 0
    bifid_decrypt_loop:
        beq $t3, $t2, bifid_decrypt_next
        lb $t6, 0($s1)
        move $a0, $s2
        move $a1, $t6
        jal index_of
        move $t6, $v0
        li $t5, 9
        div $t6, $t5
        mflo $t4 # row
        mfhi $t5 # column
        sb $t4, 0($t0)
        addi $t0, $t0, 1
        sb $t5, 0($t0)
        addi $t0, $t0, 1
        addi $s1, $s1, 1
        addi $t3, $t3, 1
        j bifid_decrypt_loop
        bifid_decrypt_next:
            li $t3, -1
            mul $t3, $t2, $t3
            li $t6, 2
            mul $t3, $t3, $t6
            add $t0, $t0, $t3 # back
            move $t6, $t0
            li $t7, 0
            li $t3, 0 # counter i
            li $t4, 0 # counter j
            bifid_decrypt_next_loop:
                beq $t3, $s4, bifid_decrypt_next_loop_after
                bifid_decrypt_next_loop_1:
                    beq $t4, $s3, bifid_decrypt_next_loop_c
                    lb $t1, 0($t6)
                    sb $t1, 0($s6)
                    move $a0, $t1
                    addi $t7, $t7, 1
                    addi $t4, $t4, 1
                    addi $t6, $t6, 1
                    j bifid_decrypt_next_loop_1
                bifid_decrypt_next_loop_c:
                    li $t4, 0
                    addi $t3, $t3, 1
                    add $t6, $t6, $s3
                    j bifid_decrypt_next_loop
             bifid_decrypt_next_loop_after: # deals with remaining
                 li $t3, 0 # counter
                 bifid_decrypt_next_loop_rem_1:
                     beq $s5, $t3, bifid_decrypt_reset
                     lb $t1, 0($t6)
                     sb $t1, 0($s6)
                     addi $t3, $t3, 1
                     addi $t7, $t7, 1
                     addi $t6, $t6, 1
                     addi $s6, $s6, 1
                     j bifid_decrypt_next_loop_rem_1
            bifid_decrypt_reset:
                move $t6, $t0
                add $t0, $t0, $s3
                li $t3, 0 #coutner i
                li $t7, 0 #coutner j
                bifid_decrypt_reset_loop:
                   beq $t3, $s3, bifid_decrypt_reset_loop_j
                   beq $t7, $s4, bifid_decrypt_end_almost
                   li $t1, 9
                   lb $t4, 0($t6)
                   lb $t5, 0($t0)
                   mul $t1, $t4, $t1
                   add $t1, $t5, $t1
                   add $t4, $t1, $s2
                   lb $t1, 0($t4)
                   sb $t1, 0($s0)
                   addi $t3, $t3, 1
                   addi $t6, $t6, 1
                   addi $t0, $t0, 1
                   addi $s0, $s0, 1
                   j bifid_decrypt_reset_loop
                   bifid_decrypt_reset_loop_j:
                       li $t3, 0
                       addi $t7, $t7, 1
                       add $t0, $t0, $s3
                       add $t6, $t6, $s3
                       j bifid_decrypt_reset_loop
               bifid_decrypt_end_almost: # leftovers
                   move $t0, $t6
                   li $t3, 0
                   bifid_decrypt_end_almost1:
                       beq $t3, $s5, bifid_decrypt_end
                       lb $t4, 0($t0)
                       add $t0, $t0, $s5
                       lb $t5, 0($t0)
                       li $t1, 9
                       mul $t1, $t1, $t4
                       add $t1, $t1, $t5
                       add $t4, $s2, $t1
                       lb $t5, 0($t4)
                       sb $t5, 0($s0)
                       addi $s0, $s0, 1
                       addi $t0, $t0, 1
                       addi $t3, $t3, 1
                       j bifid_decrypt_end_almost1
        bifid_decrypt_end:
            li $t1, 0
            sb $t1, 0($s0)
            addi $s4, $s4, 1
            move $v0, $s4
            blez $s3, bifid_decrypt_end_2
            j bifid_decrypt_end_1
            bifid_decrypt_end_2:
                li $t3, -1
                move $v0, $t3
            bifid_decrypt_end_1:
            lw $s0, 0($sp) # plain
            lw $s1, 4($sp) # cypher
            lw $s2, 8($sp) # key_square
            lw $s3, 12($sp) # period
            lw $ra, 16($sp)
            addi $sp, $sp, 20
            jr $ra


#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
