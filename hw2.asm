##############################################################
# Homework #2
# name: Vidar Minkovsky
# sbuid: 109756598
##############################################################
.text

##############################
# PART 1 FUNCTIONS 
##############################

atoui:
	li $v0, 0			# sum
	
atoui_loop:
	lb $t1, ($a0)			# char at position in t0
	beqz $t1, atoui_done		# end of string
	blt $t1, '0', atoui_done	# less than 0
	bgt $t1, '9', atoui_done	# greater than 9
	li $t3, 10			# for mult
	mult $v0, $t3
	mflo $v0			# sum = sum*10
	li $t4, '0'		
	sub $t3, $t1, $t4		# char - 0
	add $v0, $v0, $t3		# sum = sum + ^^
	addi $a0, $a0, 1		# increent string
	j atoui_loop
	
atoui_done:			
	jr $ra

uitoa:
	li $t0, 1  			# biggest storeable number + 1
	blez $a0, uitoa_error		# if 0 or less
	
power_loop:
	beqz $a2, power_done	
	li $t1, 10			# for mult/div by 10
	mult $t0, $t1
	mflo $t0
	addi $a2, $a2, -1
	j power_loop
		
power_done:
	bge $a0, $t0, uitoa_error
	li $t0, 0			# number of nums converted
	
convert_loop:
	div $a0, $t1			# number/10
	mfhi $t2			# remainder
	mflo $a0 			# quotient
	addi $t2, $t2, 48		# remainder + '0'
	addi $sp, $sp, -1		# stack
	sb $t2, 0($sp)			# store letter on the stack
	addi $t0, $t0, 1		# num nums coverted++
	beqz $a0, store_loop
	j convert_loop
	
store_loop:
	beqz $t0, uitoa_done		# all chars stored
	lb $t1, ($sp)			# load number
	addi $sp, $sp, 1		# reset stack up
	sb $t1, ($a1)			# store number
	addi $a1, $a1, 1		# increment storage location
	addi $t0, $t0, -1		# numb to store--
	j store_loop
	
	
uitoa_error:
	move $v0, $a1			# return adress
	li $v1, 0			# return failed
	jr $ra

uitoa_done:
	move $v0, $a1
	li $v1, 1
    	jr $ra

##############################
# PART 2 FUNCTIONS 
##############################    
            
decodeRun:

decodeRun_done:
    li $v0, 0
    li $v1, 0
    
    jr $ra

decodedLength:
	addi $sp, $sp, -12			# save 
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $ra, 8($sp)
	
	lb $s0, ($a1)				# char from a1
	blt $s0, '!', decodedLength_error
	beq $s0, '^', decodedLength_weGoinIn
	bgt $s0, '*', decodedLength_error

decodedLength_weGoinIn:
	li $s1, 0				# length
	
decodedLength_loop:
	lb $t2, ($a0)				# char
	beqz $t2, decodedLength_done		# char is /0
	beq $t2, $s0, itsAlot			# special cahr foudn
	addi $s1, $s1, 1			# legnth++
	addi $a0, $a0, 1			# increment
	j decodedLength_loop
	
itsAlot:
	addi $a0, $a0, 2			# increment to number
	jal atoui
	add $s1, $s1, $v0			# add num of letters
	j decodedLength_loop
	

decodedLength_error:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12			# load back
	li $v0, 0
	jr $ra

decodedLength_done:	
	move $v0, $s1

	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12			# load back
	jr $ra
         
runLengthDecode:
    #Define your code here
    li $v0, 0
    
    jr $ra


##############################
# PART 3 FUNCTIONS 
##############################
                
encodeRun:
    #Define your code here
    li $v0, 0
    li $v1, 0
    
    jr $ra

encodedLength:
    #Define your code here
    li $v0, 0
    
    jr $ra        

runLengthEncode:
    #Define your code here
    li $v0, 0
    
    jr $ra
    


.data 
.align 2
