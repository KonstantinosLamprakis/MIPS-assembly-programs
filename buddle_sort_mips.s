
# Comments:

# Description: This program implements bubble-sort algorithm to sort 20 integers.

# Pseudocode is written at C.

# Author: 
#  Konstantinos Lamprakis, koslamprakis@gmail.com

# Date: 23/03/2018 

#-------------------------------------------------------
# MIPS:

# data declaration.
.data
array: .word 3, 6, 1, 9, 1, 5, 12, 87, 26, 41, 43, 58, 2, 60, 33, 45, 94, 12, 11, 66 # array stores 20 numbers for sort.
description_str: .asciiz "\n\nThis program use bubble-sort to sort an array with numbers."
arrayPrint_str: .asciiz "\n\nCurrent state of array is:\n"
space_str: .asciiz " "
execution_str: .asciiz "\n\nExecute bubble-sort algorithm."
exit_str: .asciiz "\n\nProgram ends successfully."

# Commands.
.text
.globl main
 
# main:
# code in C:
# 
# 	// bubble-sort:
#
#   int i, j;
# 
#   for (i = 0; i < n-1; i++){ // for each element in array
#   
#       for (j = 0; j < n-i-1; j++){ // for each element which it doesn't has been placed properly yet.
# 		
# 			if (arr[j] > arr[j+1]){
# 				// swap elements.
# 				int temp = arr[j];
# 				arr[j] = arr[j+1];
# 				arr[j+1] = temp;
# 			}
#  		}
# 	}     


# Registers:
# t0: holds array's  address, which contains numbers for sorting.
# t1: used as counter for first for-loop at bubble-sort iteration.
# t2: used as counter for second for-loop at bubble-sort iteration.
# t3: holds the number of array's elements(the length of array) and used in first loop condition.
# t4: holds the number of array's elements(the length of array), which haven't sorted yet and used in second loop condition.
# t5: holds the address of current element in bubble-sort and used as iterator in for_loop. 
# t6: used temporary for swapping array's elements.
# t7: used temporary for swapping array's elements.
# s0, s1: used temporary for swapping condition.

main:

	# print description.
	la $a0, description_str
	li $v0, 4
	syscall
	
	la $t0, array 						# load address of array to $t0 register (not to $a0, because it used for syscalls).
	addi $t3, $t3, 20 					# t3 = 20; (t3 = n = array length)

	# print array.
	la $a0, arrayPrint_str
	li $v0, 4
	syscall
	
	add $t1, $zero, $zero 				# t1 = 0; (i=0)
	la $t5, array 						# use t5 as iterator.
first_print:
	bge $t1, $t3, exit_first_print 	# if (i >= array.length()) exit loop. 
	
	# print space.
	la $a0, space_str
	li $v0, 4
	syscall
	
	# print number.
	lw $a0, 0($t5)
	li $v0, 1
	syscall
	
	addi $t1, $t1, 1 				# t1++; 
	addi $t5, $t5, 4				# move t5 to next number.
	j first_print					# return and continue with next iteration.
exit_first_print:
	
	
	# print execution message.
	la $a0, execution_str
	li $v0, 4
	syscall
	
# begins bubble-sort
add $t1, $zero, $zero 				# t1 = 0; (i=0)
first_loop:
	bge $t1, $t3, exit_first_loop 	# if (i >= array.length()) exit loop. 
	
	add $t2, $zero, $zero 			# t2 = 0; (j=0)
	sub $t4, $t3, $t1 				# t4 = n-1-i; (t4 = t3-t1)	
	la $t5, array 					# use t5 as iterator.
second_loop:
	bge $t2, $t4, exit_second_loop  # if (j >= t4) exit loop. 	

	lw  $s0, 0($t5)					# temporary for the next statement
	lw  $s1, 4($t5)					# temporary for the next statement
	ble $s0, $s1, after_swap		# if(array[j] <= array[j+1]) goto after_swap;
									# swap array[t5] and array[t5+1] elements
	lw  $t6 0($t5)					# t6 = array[t5];
	lw  $t7 4($t5)					# t7 = array[t5+1];
	sw  $t6 4($t5)					# array[t5+1] = t6;
	sw  $t7 0($t5)					# array[t5] = t5;
	
after_swap:
	
	addi $t2, $t2, 1 				# t2++; 
	addi $t5, $t5, 4				# move t5 to next number.
	
	j second_loop					# return and continue with next iteration.
exit_second_loop:

	addi $t1, $t1, 1 				# t1++; 
	
	j first_loop					# return and continue with next iteration.
exit_first_loop:


	# print array.
	la $a0, arrayPrint_str
	li $v0, 4
	syscall
	
	add $t1, $zero, $zero 				# t1 = 0; (i=0)
	la $t5, array 	
	
second_print:
	bge $t1, $t3, exit_second_print 	# if (i >= array.length()) exit loop. 
	
	# print space.
	la $a0, space_str
	li $v0, 4
	syscall
	
	# print number.
	lw $a0, 0($t5)
	li $v0, 1
	syscall
	
	addi $t1, $t1, 1 				# t1++; 
	addi $t5, $t5, 4				# move t5 to next number.
	j second_print					# return and continue with next iteration.
exit_second_print:
	
# exit from program.
exit:
	# print exit message.
	la $a0, exit_str
	li $v0, 4
	syscall
	
	li $v0, 10
	syscall