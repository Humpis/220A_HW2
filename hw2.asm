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
    #Define your code here
    li $v0, 0
    li $v1, 0
    
    jr $ra

##############################
# PART 2 FUNCTIONS 
##############################    
            
decodeRun:
    #Define your code here
    li $v0, 0
    li $v1, 0
    
    jr $ra

decodedLength:
    #Define your code here
    li $v0, 0
    li $v1, 0
    
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
