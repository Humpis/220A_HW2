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
# (char[], int) decodeRun(char letter, int runLength, char[] output)        
decodeRun:
	blt $a1, 1, decodeRun_error		# runlength less than 1
	lb $t0, ($a0)				# letter to repeat
	blt $t0, 'A', decodeRun_error		
	bgt $t0, 'z', decodeRun_error
	ble $t0, 'Z', decodeRun_loop
	bge $t0, 'a', decodeRun_loop
	j decodeRun_error			# is not aphabet letter
	
decodeRun_loop:
	beqz $a1, decodeRun_done		# done
	sb $t0, ($a2)				# store letter
	addi $a2, $a2, 1			# increment
	addi $a1, $a1, -1			# incvrement
	j decodeRun_loop
	
decodeRun_error:
	move $v0, $a2				# output adress
	li $v1, 0				# fsailed
	jr $ra	

decodeRun_done:
	move $v0, $a2
	li $v1, 1    
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
	lb $t2, ($a0)				# char
	beqz $t2, decodedLength_error		# char is /0
	
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
	addi $s1, $s1, 1			# add 1 for /0
	move $v0, $s1
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12			# load back
	jr $ra
    
# int runLengthDecode(char[] input, char[] output, int outputSize, char runFlag)   
runLengthDecode:
	addi $sp, $sp, -12				# save 
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $ra, 8($sp)
	
	lb $s0, ($a3)					# char from a3
	blt $s0, '!', runLengthDecode_error		
	beq $s0, '^', runLengthDecode_weGoinIn
	bgt $s0, '*', runLengthDecode_error
	
runLengthDecode_weGoinIn:
	addi $sp, $sp, -8				# save 
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	move $a1, $a3					# runFlag
	jal decodedLength	
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	addi $sp, $sp, 8				# load 
	bgt $v0, $a2, runLengthDecode_error		# length is greaster than outputsize
	
runLengthDecode_loop:
	lb $t0, ($a0)					# char of input srting
	beqz $t0, runLengthDecode_done			# /0 reached 
	beq $t0, $s0, decodeABunch			# flag reached
	sb $t0, ($a1)					# store letter
	addi $a1, $a1, 1				# increment output
	addi $a0, $a0, 1				# increment input
	j runLengthDecode_loop
	
decodeABunch:
	addi $a0, $a0, 1				# increment to letter from flag
	la $s1, ($a0)					# string contraining letter
	addi $a0, $a0, 1				# increment to number from letter
	# get number with atoui
	jal atoui

	addi $sp, $sp, -8				# store 
	sw $a0, 0($sp)
#	sw $a1, 4($sp)					output does not need to be stored
	sw $a2, 4($sp) 
	
	# put in args and call decodeRun
	move $a0, $s1					# char letter
	move $a2, $a1					# output
	move $a1, $v0					# number of letters

	jal decodeRun
	move $a1, $v0					# new output[]
	
	lw $a0, 0($sp)					# load
#	lw $a1, 4($sp)
	lw $a2, 4($sp) 
	addi $sp, $sp, 8
	
	#addi $a0, $a0, 1				# move to next char in input
	j runLengthDecode_loop

runLengthDecode_error:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12			# load back
	li $v0, 0
	jr $ra
	
runLengthDecode_done:
	li $t0, '\0'					# null term
	sb $t0, ($a1)					# store null term
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12			# load back
	li $v0, 1
	jr $ra


##############################
# PART 3 FUNCTIONS 
##############################
                
encodeRun:
	addi $sp, $sp, -12				# save 
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $ra, 8($sp)
	
	blt $a1, 1, encodeRun_error		# runlength less than 1
	lb $t0, ($a0)				# letter to repeat
	blt $t0, 'A', encodeRun_error		
	bgt $t0, 'z', encodeRun_error
	ble $t0, 'Z', encodeRun_alphabet
	bge $t0, 'a', encodeRun_alphabet
	j encodeRun_error			# is not aphabet letter
	
encodeRun_alphabet:
	lb $t1, ($a3)					# runFlag from a3
	blt $t1, '!', encodeRun_error		
	beq $t1, '^', encodeRun_weGoinIn
	bgt $t1, '*', encodeRun_error
	
encodeRun_weGoinIn:
	ble $a1, 3, encodeRun_small			# runLength < 3, then runLength copies of letter are written into output
	sb $t1, ($a2)					# store signfier
	addi $a2, $a2, 1				# inc output
	sb $t0, ($a2)					# store letter
	addi $a2, $a2, 1				# inc output
	# call uitoa and shizzzzz for ukwhat

	move $a0, $a1					# runlength
	move $a1, $a2					# output
	li $a2, 10					# outputsize
	jal uitoa
	move $a2, $v0					# output from uitoa
	j encodeRun_done
	
encodeRun_small:
	beqz $a1, encodeRun_done			# all letters written
	sb $t0, ($a2)					# store letter
	addi $a2, $a2, 1				# inc output
	addi $a1, $a1, -1				# dec num left
	j encodeRun_small 	
	
encodeRun_error:
	move $v0, $a2					# adress
	li $v1, 0					# failed
		
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12				# load 
	jr $ra
	
encodeRun_done:
	move $v0, $a2					# adress
	li $v1, 1					# success 
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12				# laod
	jr $ra

encodedLength:
	li $t0, 0				# counter
	lb $t1, ($a0)				# letter
	beqz $t1, encodedLength_error		# /0 reached
	addi $a0, $a0, 1			# increment
	addi $t0, $t0, 1			# counter++
	
encodedLength_loop:
	#beqz $t1, encodedLength_done		# /0 reached
	lb $t2, ($a0)
	beqz $t2, encodedLength_done		# /0 reached
	beq $t1, $t2, encodedLength_repeat	# letter repeats
	addi $t0, $t0, 1			# counter++ becuase new letter
	move $t1, $t2				# letter 1 = letter 2
	addi $a0, $a0, 1			# increment input
	j encodedLength_loop
	
encodedLength_repeat:
	addi $t0, $t0, 1			# counter increment for ! or letter depending
	li $t3, 2				# repeat counter
	# number of letters
	
encodedLength_repeatLoop:
	addi $a0, $a0, 1			# increment input
	lb $t1, ($a0)				
    	bne $t1, $t2, encodedLength_doneRepeat
    	addi $t3, $t3, 1			# repeatOCunter++
    	j encodedLength_repeatLoop
    
encodedLength_doneRepeat:
	move $t1, $t2				# put old char in t1
	#addi $a0, $a0, -1			# input--
	#addi $t0, $t0, 1			# next char is already read
	blt $t3, 3, encodedLength_loop		# 2 
	addi $t0, $t0, 1			# less than 10
	blt $t3, 10, encodedLength_loop
	addi $t0, $t0, 1			# less than 100
	blt $t3, 100, encodedLength_loop
	addi $t0, $t0, 1			# less than 1000
	blt $t3, 1000, encodedLength_loop
	addi $t0, $t0, 1			# less than 10000
	blt $t3, 10000, encodedLength_loop
	addi $t0, $t0, 1			# greater than than 10000
	j encodedLength_loop	
	
encodedLength_error:
	move $v0, $t0				# counter in v0
	jr $ra  
	
encodedLength_done:
	addi $t0, $t0, 1			# null term
	move $v0, $t0				# counter in v0
	jr $ra       

runLengthEncode:
	addi $sp, $sp, -12				# save 
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $ra, 8($sp)
	
	lb $s0, ($a3)					# char from a3
	blt $s0, '!', runLengthEncode_error		
	beq $s0, '^', runLengthEncode_weGoinIn
	bgt $s0, '*', runLengthEncode_error
	
runLengthEncode_weGoinIn:
	addi $sp, $sp, -4				# save 
	sw $a0, 0($sp)
	jal encodedLength				
	lw $a0, 0($sp)
	addi $sp, $sp, 4				# load 
	blt $a2, $v0, runLengthEncode_error		# output not big enough
	lb $t0, ($a0)					# first char
	beqz $t0, runLengthEncode_error
	addi $a0, $a0, 1				# incrmemnt input
	#sb $t0, ($a1)					# store first letter, to be possibly removed
	li $t3, 1					# counter 
		 
runLengthEncode_loop:
	lb $t1, ($a0)					# load a char
	bne $t0, $t1, runLengthEncode_repeatDone	# repeat done
	beqz $t1, runLengthEncode_done			# \0 reached

	#addi $a1, $a1, 1				# inc output
	#sb $t0, ($a1)					# store letter
	addi $a0, $a0, 1				# inc input
	move $t0, $t1					# put new into old
	addi $t3, $t3, 1				# counter++
	j runLengthEncode_loop
	
runLengthEncode_repeatDone:
	addi $sp, $sp, -8				# save 
	sw $a0, 0($sp)
	sw $t1, 4($sp)

	addi $a0, $a0, -1				# letter to repeat
	move $a2, $a1					# output
	move $a1, $t3					# runlegnth
	jal encodeRun
	move $a1, $v0					# output
	
	
	lw $a0, 0($sp)
	lw $t1, 4($sp)
	addi $sp, $sp, 8
	addi $a0, $a0, 1				# inc input
	
	beqz $t1, runLengthEncode_done			# \0 reached
	
	move $t0, $t1					# put the new letter in old
	
	
	li $t3, 1					# reset counter
	
	j runLengthEncode_loop

runLengthEncode_error:
    	li $v0, 0
    	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12				# load 
	jr $ra

runLengthEncode_done:
	li $t4, '\0'
	sb $t4, ($a1)
	
	
    	li $v0, 1
    	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12				# load 
	jr $ra
    


.data 
.align 2
