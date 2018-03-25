
# Comments:

# Description: This is the 3nd task of Computer Systems Organization. 
# This program shows a menu, creates and maintains a classified list of integers. 

# Pseudocode is written at C++,  but contains (intentional)some syntax errors because the 
# purpose is to be similar with assembly code(not to create this program at C++).
# I choose C++ as language, because it supports pointers(instead of java)
# and memory allocation as well. Also, C++ is popular, powerful and high-level language. 
#
# I don't free memory allocated by sbrk, because we have only the ability to free
# the last bytes of allocated memory(not intermediate). This is not a problem, because
# we have only few data(from user). But if its required by program, we could find a way
# to free this memory(e.x we could store all elements continuing after removing an element
# and free the last bytes).
#
# I don't make input control for user input, because doesn't required. Its simple
# but exams begins and time is restricted.
#
# At some points we could do more reuse of same code but we didn't because at these points
# code was very short and doesn't worthwhile. (e.x. check if list is empty could be as
# function but instead, we use it at 3 different points, because its short).

# Authors: 
#	Lamprakis Konstantinos, koslamprakis@gmail.com

# Date: 09/01/2018



# Registers:
#	s0 = number of current nodes at list.
#	s1 = pointer to head of list.
#	s3 = operation number(menu).

# MIPS:

# data declaration.
.data
description_str: .asciiz "\nThis program shows a menu, creates and maintains a classified list of integers."
menu_str: .asciiz "\n\nPlease enter the number of operation to execute:\n1. Insert an integer at list.\n2. Remove an integer from list.\n3. Print list at ascending order.\n4. Print list at descending order.\n5. Exit.\n\n>> "
enter_int_str: .asciiz "\nPlease enter the integer which you want to add.\n\n>> "
exit_str: .asciiz "\n\nProgram ends successfully."
empty_list_str: .asciiz "\n List is empty."
blank_str: .asciiz "  "
remove_prompt_str: .asciiz "\nPlease enter the integer which you would like to remove from the list.\n\n>> "
not_found_str: .asciiz "\nThis integer not exists."
found_str: .asciiz "\nRemove Successful."

# Commands.
.text
.globl main
 
# main:
# code at C++:
#
# // print welcome message with the description of program.
# string description_str = "\nThis program shows a menu, creates and maintains a classified list of integers.";
# cout << description_str << endl;
# int s0 = 0; // counts number of nodes.
# int * s1 = nullptr; // pointer to the beginning of list.
# string menu_str = "\n\nPlease enter the number of operation to execute:\n1. Insert an integer at list.\n2. Remove an integer from list.\n3. Print list at ascending order.\n4. Print list at descending order.\n5. Exit.\n\n>> ";
# while (true){
#	cout << menu_str << endl; // print menu
#	int s3; // stores the operation number of user.
#	cin >> s3;
#	if (s3 == 1) operation_insert_func();
#	if (s3 == 2) operation_remove_func();
#	if (s3 == 3) operation_print_ascending_order_func();
#	if (s3 == 4) operation_print_descending_order_func();
#	if (s3 == 5) exit(0);
# }

main:
	
	# print a message to describe the application functionality.
	la $a0, description_str
	li $v0, 4
	syscall
	
	li $s0, 0 # $s0 counts number of list's nodes.
	li $s1, 0 # $s1 is a pointer to head of list. At the beginning is zero.
	
print_menu:	
	
	# print menu.
	la $a0, menu_str
	li $v0, 4
	syscall
	
	# read operation number.
	li $v0, 5
	syscall
	move $s3, $v0 # $s3 stores number of operation.
	
	# if operation number is equal to 1, then insert new integer to list.
	bne $s3, 1, after_operation_insert
	jal operation_insert_func

after_operation_insert:

	# if operation number is equal to 2, then remove an integer from list.
	bne $s3, 2, after_operation_remove
	jal operation_remove_func
	
after_operation_remove:

	# if operation number is equal to 3, then print list at ascending order.
	bne $s3, 3, after_operation_print_ascending_order
	jal operation_print_ascending_order_func
	
after_operation_print_ascending_order:
	
	# if operation number is equal to 4, then print list at descending order.
	bne $s3, 4, after_print_desc_order
	
	# if list is empty, show proper message and return to menu.
	bne $s0,0, not_empty
	la $a0,empty_list_str
	li $v0,4
	syscall
	j print_menu
	
not_empty:
	move $a1, $s1
	jal operation_print_descending_order_func

after_print_desc_order:
	# if operation number is equal to 5, then exit.
	beq $s3, 5, exit 
	
	# return to menu.
	j print_menu
	
# ---------------------------- 
# code at C++:
# private void operation_insert_func(){
# 	int node[2] = new int[2]; // allocate two continuing memory cells with size of integer.
# 	cin >> node[0];
# 	if (s0==0){ // list is empty, so we add new node at head.
#		// insert at head:
# 		node[1] = s1; // = nullptr, new node -> 0
# 		s1 = &node[1] // head -> new node
# 		s0++;
#		return;
# 	}
#
# 	int t0 = s1; // t0 -> head(first element)
#	int t1 = &node[1]; // t1 -> new node
# 	int t2 = *t0; // t2 -> second element
#	while(true){
# 		if (t2 == nullptr){ //insert at the end, because new node is the bigger number.
#			// insert at the end:
#	 		t0 = &t1;
#	 		t1 = nullptr;
#	 		s0++;
#			return;
#  		}
#  		// *(ti-1) is the integer data of node i.
#  		if(*(t1-1) < *(t2-1)){ // insert t1 between t0 and t2
#			// swap:
#			t1 = &t2;
#   		t0 = &t1; // before t0 -> t2, now t0 -> t1 -> t2
#			s0++
#			return;
#  		}
#		t0 = *(t0);
#		t2 = *(t2);
#	}
# }

#inserts new node and keep the list at ascending order.	
operation_insert_func:
		
	# Registers:
	# t0 = last node lesser than t1(and first node before t2)
	# t1 = new node
  	# t2 = first node greater than t1(and first node after t0)
	# t3, t4 = temporary for operations 
	
	# make space for two integers.
	li $a0, 8
	li $v0, 9
	syscall
	move $t1, $v0 # t1 = pointer to new space.
	
	# print prompt message.
	la $a0, enter_int_str
	li $v0, 4
	syscall
	
	# read integer and store it at the first 4 bytes of new space.
	li $v0, 5 
	syscall
	sw $v0, ($t1)
	
	# insert node at proper position to keep list sorted.
	
	la $t1, 4($t1) # make t1 compatible with t0, t2 so t1 = pointer of t1 and -4(t1) = data of t1.
	
	# if list is empty, then go to swap_head.
	beq $s0, 0, swap_head	
	
	# if current node(t1) < head node(s1), swap them
	lw $t3,-4($t1)
	lw $t4,-4($s1)
	blt $t3, $t4, swap_head

	move $t0, $s1 # t0 = head
	lw $t2,($t0) # t2 = t0.next = second node
	
sort_loop:
	
	beq $t2, $zero, insert_at_end # if t2 = zero(t0 = last node), then should insert t1 at the end of list.
	
	# if current node(t1) < t2, should insert it between t0 and t2.
	lw $t3,-4($t1)
	lw $t4,-4($t2)
	blt $t3,$t4,swap
	
	lw $t0,($t0) # move to the next node.
	lw $t2,($t2) # move to the next node.
	
	j sort_loop # repeat.
	
swap_head:	
	sw $s1, ($t1) # t1 pointer -> head. If list is empty t1 pointer -> zero
	la $s1, ($t1) # head pointer -> t1
	addi $s0, $s0, 1 # increase number of current nodes.
	jr $ra
	
insert_at_end:	
	sw $t1,($t0) # previous last node pointer -> t1
	sw $zero,($t1) # t1 pointer -> zero
	addi $s0, $s0, 1 # increase number of current nodes.
	jr $ra
	
swap:	
	sw $t2,($t1) # t1 pointer -> t2
	sw $t1,($t0) # t0 pointer -> t1
	addi $s0, $s0, 1 # increase number of current nodes.
	jr $ra


# ---------------------------- 
# Code at C++:
# private void operation_remove_func(){
#	if (s0 == 0){ // check if list is empty.
#		cout << empty_list_str << endl;
#		return;
#	}
#	cout << remove_prompt_str << endl; // print prompt to take an integer from user.
#	int t0; // t0 is the integer which is going to removed.
#	cin >> t0; 
#	int t1 = s1 // t1 = head(first element of list).
#	int t2 = *t1 // t2 = second element.
#	if (*(t1-1) == t0){
#		// remove first node.
#		s1 = *s1 // s1 -> second element
#		s0--;// decrease number of nodes
#		cout << found_str << endl; // print proper message.
#		return;
#	}
#	while(true){
#		if (t2 == nullptr){
#			// not found, unsuccessful remove.
#			cout << not_found_str << endl;
#			return;
#		}
#		if(*(t2-1) == t0){
#			// remove element
#			*t1 = *t2; // t1 points to the next pointer of t2 pointer.(so t2 is deleted)
#			s0--;// decrease number of nodes
#			cout << found_str << endl; // print proper message.
#			return;
#			
#		}
#		
#		t1 = *t1;
#		t2 = *t2;
#	}
#
# }

# finds and removes the proper node. The ascending order doesn't affected.
operation_remove_func:

	# Registers:
	# t0 = integer which is going to remove.
	# t1 = node before iterator.
	# t2 = iterator for list.
	# t3 = temporary for calculation.
	
	# if list is empty, show proper message and return to menu.
	bne $s0,0, not_empty_for_remove
	la $a0,empty_list_str
	li $v0,4
	syscall
	jr $ra

not_empty_for_remove:

	# print prompt for remove process.
	la $a0,remove_prompt_str
	li $v0,4
	syscall 
	
	# read integer which is going to remove.
	li $v0,5
	syscall
	move $t0, $v0 # t0 = integer, which is going to remove.
	
	move $t1,$s1 # t1 = head of list.
	lw $t2,($t1) # t2 = second node of the list.
	
	# if t1 == t0 (first element = key), then remove first element.
	lw $t3,-4($t1)
	beq $t0,$t3, remove_first

search_loop:
	
	beq $t2, $zero, not_found # if t2 = zero, then search finished unsuccessfully.
	lw $t3,-4($t2)
	beq $t3, $t0, remove_element # if current node = key, remove this node. 
	
	lw $t1,($t1)  # move to the next node.
	lw $t2,($t2)  # move to the next node.

	j search_loop

remove_element:

	# print proper message for successful remove.
	la $a0, found_str
	li $v0, 4
	syscall

	lw $t3,($t2)
	sw $t3,($t1) # t1 pointer = t2 pointer(so t2 has deleted).
	addi $s0, $s0, -1 # decrease number of current nodes.
	
	jr $ra # return to program.
	
remove_first:
	lw $s1, ($s1) # s1 pointer -> second node(or zero if list contains only one element)
	addi $s0,$s0,-1 # decrease number of current nodes. 
	
	# print proper message for successful remove.
	la $a0, found_str
	li $v0,4
	syscall
	
	jr $ra # return to program.
	
not_found:
	# print proper message for unsuccessful remove.
	la $a0, not_found_str
	li $v0, 4
	syscall
	
	jr $ra # return to program.
	
# ---------------------------- 
# C++ code:
#private void operation_print_ascending_order_func(){
#	int *t0 = s1; // t0 = head(first element of list).
#	if (s0 == 0){ //check if list is empty.
#		cout << empty_list_str << endl;
#		return;
#	}
#	while(true){
#		if(t0 == nullptr) return; // if this is the last node, return.
#		cout << *(t0-1) << " " // print integer data of current node.
#		t0 = *t0; // move to the next node.
#	}
# }

# prints the list from the beginning to the end(at ascending order).
operation_print_ascending_order_func:
	
	# Registers:
	# t0 = iterator for list.
	
	# initialization.
	move $t0, $s1 # $t0 is an iterator for list.
	
	# if list is empty, show proper message and return to menu.
	bne $s0, 0, print_loop
	la $a0, empty_list_str
	li $v0, 4
	syscall
	jr $ra # return to program.
	
print_loop:
		
	beq $t0,$zero, return_from_print # if pointer is zero then the current node is the last one and iteration should stop.
	
	# print the integer(data) of each node.
	lw $a0,-4($t0)
	li $v0,1
	syscall
	
	# print " "
	la $a0,blank_str
	li $v0,4
	syscall
	
	lw $t0, ($t0) # move to the next node.
	
	j print_loop # repeat.

return_from_print:
	jr $ra # return to program.
	
# ---------------------------- 
# C++ code:
#private void operation_print_descending_order_func(int * a1){
#	// a1 is a pointer to an element of list, the first time is equal to s1.
#	int a2 = *a1; // a2 is the next node of a1.
#	if (!a2 == nullptr){
#		operation_print_descending_order_func(a2); // call recursively.
#	}
#	cout << *(a1-1) << " "; // print current element.
#	return;
#}

# prints recursively the list from end to beginning(at descending order).  
operation_print_descending_order_func:

	# Registers:
 	# $a1 contains a link at the current node(as iteration). At the beginning contains a link to head of list.
	
	# store at stack the return address and current node of $a1.
	addi $sp, $sp, -8
	sw $a1, 4($sp) # store $a1.
	sw $ra, 0($sp) # store $ra, because this function call itself.
	
	lw $a1, ($a1) # move to the next node
	beq $a1, $zero, after_jal # if $a1 is zero, then the previous was the last node, so return to previous.	
	
	jal operation_print_descending_order_func # call recursively.

after_jal:

	# restore registers from stack.
	lw $ra, 0($sp)
	lw $a1, 4($sp)
	addi $sp, $sp, 8
	
	# print current node.
	lw $a0,-4($a1) # move  to #a0, the integer data of the current node. 
	li $v0, 1
	syscall
	
	# print " "
	la $a0,blank_str
	li $v0,4
	syscall
	
	jr $ra

# ----------------------------
# C++ code:
# string exit_str = "\n\nProgram ends successfully.";
# cout << exit_str << endl;
# exit(0);

# exit from program.
exit:
	# print exit message.
	la $a0, exit_str
	li $v0, 4
	syscall
	
	li $v0, 10
	syscall


