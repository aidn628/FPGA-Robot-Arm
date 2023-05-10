nop
nop
nop

super_top:


addi $28, $0, 0
addi $29, $0, 3600

nop
clear_loop:
nop
nop
bne $28, $29, clear_loop_continue
nop
nop
j flop
nop
nop
clear_loop_continue:
nop
nop
addi $28, $28, 1
nop
nop
sw $0 0($28)
nop
nop
j clear_loop

nop
nop

flop:

nop
nop
addi $15, $0, 1  #for branch comparisons to 1

addi $9, $0, 0  #start motors at 0 degrees
addi $10, $0, 0
addi $11, $0, 0

addi $13, $0, 0 #counter

addi $16, $0, 0 #initialize value saves to 0
addi $17, $0, 0
addi $18, $0, 0
addi $19, $0, 0
addi $20, $0, 0
addi $21, $0, 0

addi $22, $0, 0      #initialize adress saves to 0
addi $23, $0, 600   
addi $24, $0, 1200  
addi $25, $0, 1800  
addi $26, $0, 2400  
addi $27, $0, 3000


nop
nop


top:   

nop
nop
bne $2, $0, super_bottom                         #value saves are 16-21, adress saves are 22-27
nop
nop

nop
addi $13, $13, 1

#---------base---------
#--------record-------
nop
nop
bne $3, $16, base_a_record   #jump to record section of value saved is different than current button value
nop
nop
base_a_return:              #return from record section and execut normal procedure
#-------normal---------
nop
nop
bne $3, $15, base_a
nop
nop
addi $9, $9, 1
nop
nop
wait 10000
nop
nop
base_a:

#--------record-------
nop
nop
bne $4, $17, base_b_record   #jump to record section of value saved is different than current button value
nop
nop
base_b_return:              #return from record section and execut normal procedure
#-------normal---------
nop
nop
bne $4, $15, base_b
nop
nop 
addi $9, $9, -1
nop
nop
wait 10000
nop
nop
base_b:
nop
nop

#shoulder
#--------record-------
nop
nop
bne $5, $18, shoulder_a_record   #jump to record section of value saved is different than current button value
nop
nop
shoulder_a_return:              #return from record section and execut normal procedure
#-------normal---------
nop
nop
bne $5, $15, shoulder_a
nop
nop
addi $10, $10, 1
nop
nop
wait 10000
nop
nop
shoulder_a:

#--------record-------
nop
nop
bne $6, $19, shoulder_b_record   #jump to record section of value saved is different than current button value
nop
nop
shoulder_b_return:              #return from record section and execut normal procedure
#-------normal---------
nop
nop
bne $6, $15, shoulder_b
nop
nop 
addi $10, $10, -1
nop
nop
wait 10000
nop
nop
shoulder_b:
nop
nop

#elbow
#--------record-------
nop
nop
bne $7, $20, elbow_a_record   #jump to record section of value saved is different than current button value
nop
nop
elbow_a_return:              #return from record section and execut normal procedure
#-------normal---------
nop
nop
bne $7, $15, elbow_a
nop
nop
addi $11, $11, 1
nop
nop
wait 10000
nop
nop
elbow_a:

#--------record-------
nop
nop
bne $8, $21, elbow_b_record   #jump to record section of value saved is different than current button value
nop
nop
elbow_b_return:              #return from record section and execut normal procedure
#-------normal---------
nop
nop
bne $8, $15, elbow_b
nop
nop 
addi $11, $11, -1
nop
nop
wait 10000
nop
nop
elbow_b:
nop
nop


j top


#--------record section------------------------------------------------------------------------------------
base_a_record:
nop
nop
sw $13, 0($22)       #stor current time in given button's memory section
nop
nop
addi $22, $22, 1      #increment memory adress for next value
add $16, $0, $3      #change current value to match with button state
nop
nop
j base_a_return      #return to normal procedure

base_b_record:
nop
nop
sw $13, 0($23)       #stor current time in given button's memory section
nop
nop
addi $23, $23, 1      #increment memory adress for next value
add $17, $0, $4      #change current value to match with button state
nop
nop
j base_b_return      #return to normal procedure

shoulder_a_record:
nop
nop
sw $13, 0($24)       #stor current time in given button's memory section
nop
nop
addi $24, $24, 1      #increment memory adress for next value
add $18, $0, $5      #change current value to match with button state
nop
nop
j shoulder_a_return      #return to normal procedure

shoulder_b_record:
nop
nop
sw $13, 0($25)       #stor current time in given button's memory section
nop
nop
addi $25, $25, 1      #increment memory adress for next value
add $19, $0, $6      #change current value to match with button state
nop
nop
j shoulder_b_return      #return to normal procedure

elbow_a_record:
nop
nop
sw $13, 0($26)       #stor current time in given button's memory section
nop
nop
addi $26, $26, 1      #increment memory adress for next value
add $20, $0, $7      #change current value to match with button state
nop
nop
j elbow_a_return      #return to normal procedure

elbow_b_record:
nop
nop
sw $13, 0($27)       #stor current time in given button's memory section
nop
nop
addi $27, $27, 1      #increment memory adress for next value
add $21, $0, $8      #change current value to match with button state
nop
nop
j elbow_b_return      #return to normal procedure


#-----------------play back-------------------------------------------------------------------------
nop
nop
super_bottom:
nop
nop

addi $13, $0, 0
addi $15, $0, 1

nop
nop
lw $16, 0($0)  #now will instead contain the counter number we are looking for
nop
nop
lw $17, 600($0)  
nop
nop
lw $18, 1200($0)  
nop
nop
lw $19, 1800($0)  
nop
nop
lw $20, 2400($0) 
nop
nop 
lw $21, 3000($0)  
nop
nop      

#will now contain a 1 or 0 for on and off (fullfill role of input signal from before)
addi $22, $0, 0    # base a #will now contain a 1 or 0 for on and off (fullfill role of input signal from before)
addi $23, $0, 0
addi $24, $0, 0
addi $25, $0, 0
addi $26, $0, 0
addi $27, $0, 0

addi $12, $0, 0    #will be using these to stor where in each sepcific secion of memory each button is, using literally ever reg lol, not quite nessesary but idc
addi $14, $0, 0
addi $28, $0, 0
addi $29, $0, 0
addi $30, $0, 0
addi $31, $0, 0

addi $9, $0, 0  #start motors at 0 degrees
addi $10, $0, 0
addi $11, $0, 0

nop
nop
wait 3125000
nop
nop

top_z:

nop
nop
bne $1, $0, super_top
nop
nop

nop
addi $13, $13, 1

#base_a
nop
nop
bne $13, $16, base_a_start   #check if we have reached the point in counter where we want to change from off to on or visa versa
nop
nop
bne $22, $0, base_a_not_o  #check whether to change from one to zero or zero to one
nop
nop
addi $22, $0, 1
addi $12, $12, 1
nop
nop
lw $16, 0($12)
nop
nop
j base_a_start
nop
nop
base_a_not_o:
nop
nop
addi $22, $0, 0
addi $12, $12, 1
nop
nop
lw $16, 0($12)
nop
nop
#---------------------------
base_a_start:
nop
nop
bne $22, $15, base_az
nop
nop
addi $9, $9, 1
nop
nop
wait 10000
nop
nop
base_az:



#base_b
nop
nop
bne $13, $17, base_b_start   #check if we have reached the point in counter where we want to change from off to on or visa versa
nop
nop
bne $23, $0, base_b_not_o  #check whether to change from one to zero or zero to one
nop
nop
addi $23, $0, 1
addi $14, $14, 1
nop
nop
lw $17, 600($14)
nop
nop
j base_b_start
nop
nop
base_b_not_o:
nop
nop
addi $23, $0, 0
addi $14, $14, 1
nop
nop
lw $17, 600($14)
nop
nop
#---------------------------
base_b_start:
nop
nop
bne $23, $15, base_bz
nop
nop 
addi $9, $9, -1
nop
nop
wait 10000
nop
nop
base_bz:
nop
nop


#shoulder_a
nop
nop
bne $13, $18, shoulder_a_start   #check if we have reached the point in counter where we want to change from off to on or visa versa
nop
nop
bne $24, $0, shoulder_a_not_o  #check whether to change from one to zero or zero to one
nop
nop
addi $24, $0, 1
addi $28, $28, 1
nop
nop
lw $18, 1200($28)
nop
nop
j shoulder_a_start
nop
nop
shoulder_a_not_o:
nop
nop
addi $24, $0, 0
addi $28, $28, 1
nop
nop
lw $18, 1200($28)
nop
nop
#---------------------------
shoulder_a_start:
nop
nop
bne $24, $15, shoulder_az
nop
nop
addi $10, $10, 1
nop
nop
wait 10000
nop
nop
shoulder_az:



#shoulder_b
nop
nop
bne $13, $19, shoulder_b_start   #check if we have reached the point in counter where we want to change from off to on or visa versa
nop
nop
bne $25, $0, shoulder_b_not_o  #check whether to change from one to zero or zero to one
nop
nop
addi $25, $0, 1
addi $29, $29, 1
nop
nop
lw $19, 1800($29)
nop
nop
j shoulder_b_start
nop
nop
shoulder_b_not_o:
nop
nop
addi $25, $0, 0
addi $29, $29, 1
nop
nop
lw $19, 1800($29)
nop
nop
#---------------------------
shoulder_b_start:
nop
nop
bne $25, $15, shoulder_bz
nop
nop 
addi $10, $10, -1
nop
nop
wait 10000
nop
nop
shoulder_bz:
nop
nop

#elbow_a
nop
nop
bne $13, $20, elbow_a_start   #check if we have reached the point in counter where we want to change from off to on or visa versa
nop
nop
bne $26, $0, elbow_a_not_o  #check whether to change from one to zero or zero to one
nop
nop
addi $26, $0, 1
addi $30, $30, 1
nop
nop
lw $20, 2400($30)
nop
nop
j elbow_a_start
nop
nop
elbow_a_not_o:
nop
nop
addi $26, $0, 0
addi $30, $30, 1
nop
nop
lw $20, 2400($30)
nop
nop
#---------------------------
elbow_a_start:
nop
nop
bne $26, $15, elbow_az
nop
nop
addi $11, $11, 1
nop
nop
wait 10000
nop
nop
elbow_az:



#elbow_b
nop
nop
bne $13, $21, elbow_b_start   #check if we have reached the point in counter where we want to change from off to on or visa versa
nop
nop
bne $27, $0, elbow_b_not_o  #check whether to change from one to zero or zero to one
nop
nop
addi $27, $0, 1
addi $31, $31, 1
nop
nop
lw $21, 3000($31)
nop
nop
j elbow_b_start
nop
nop
elbow_b_not_o:
nop
nop
addi $27, $0, 0
addi $31, $31, 1
nop
nop
lw $21, 3000($31)
nop
nop
#---------------------------
elbow_b_start:
nop
nop
bne $27, $15, elbow_bz
nop
nop 
addi $11, $11, -1
nop
nop
wait 10000
nop
nop
elbow_bz:
nop
nop


j top_z
