.data
test_1_s: .string "listen"
test_1_t: .string "silent"
test_2_s: .string "allergy"
test_2_t: .string "gallery"
correct_1: .string "test_1: correct"
not_correct_1: .string "test_1: not correct"
correct_2: .string "test_2: correct"
not_correct_2: .string "test_2: not correct"
.text
main:
 addi a7, x0, 4 # System call code for printing
 la a0, test_1_s # Load address of test_1_s into a0
 la a1, test_1_t # Load address of test_1_t into a1
 jal ra, isAnagram # Jump and link to isAnagram function
 bnez a0, TRUE_1 # Branch if isAnagram returns non-zero (true)
 la a0, not_correct_1 # Load address of not_correct_1 into a0
 ecall # Print the string at address in a0
 j TEST_2 # Jump to TEST_2
TRUE_1:
 la a0, correct_1 # Load address of correct_1 into a0
 ecall # Print the string at address in a0
 j TEST_2 # Jump to TEST_2
TEST_2:
 la a0, test_2_s # Load address of test_2_s into a0
 la a1, test_2_t # Load address of test_2_t into a1
 jal ra, isAnagram # Jump and link to isAnagram function
 bnez a0, TRUE_2 # Branch if isAnagram returns non-zero (true)
 la a0, not_correct_2 # Load address of not_correct_2 into a0
 ecall # Print the string at address in a0
 j EXIT # Jump to EXIT
TRUE_2:
 la a0, correct_2 # Load address of correct_2 into a0
 ecall # Print the string at address in a0
 j EXIT # Jump to EXIT
EXIT:
 addi a7, x0, 10 # System call code for program exit
 ecall # Exit the program
isAnagram: # Function to check if two strings are anagrams
 addi sp, sp, 100 # Allocate space on the stack for variables
 addi t0, sp, 0 # t0 points to the beginning of the space
 addi t1, x0, 0 # t1 is the loop counter
 li t2, 26 # t2 is the length of the alphabet
LOOP1:
 beq t1, t2, GET_FREQ_s # If the loop counter equals the alphabet length, go to GET_FREQ_s
 sw x0, 0(t0) # Initialize each element of the frequency array to 0
 addi t1, t1, 1 # Increment the loop counter
 addi t0, t0, 4 # Move to the next element in the frequency array
 j LOOP1 # Jump back to the beginning of the loop
GET_FREQ_s:
 addi t0, sp, 0 # Reset t0 to point to the beginning of the frequency array
 addi t1, a0, 0 # t1 points to the first character of the first string
 addi t2, x0, 0 # t2 is the loop counter for the first string
LOOP2:
 add t3, t1, t2 # t3 points to the current character in the first string
 lb t5, (0)t3 # Load the current character
 beqz t5, GET_FREQ_F # If the character is null, go to GET_FREQ_F
 addi t5, t5, -97 # Convert the character to an index (0-25)
 slli t5, t5, 2 # Multiply the index by 4 to get the offset in the frequency array
 add t5, t5, t0 # t5 points to the frequency of the current character in the array
 lw t3, 0(t5) # Load the current frequency
 addi t3, t3, 1 # Increment the frequency
 sw t3, 0(t5) # Store the updated frequency
 addi t2, t2, 1 # Increment the loop counter
 j LOOP2 # Jump back to the beginning of the loop
GET_FREQ_F:
 addi t0, sp, 0 # Reset t0 to point to the beginning of the frequency array
 addi t1, a1, 0 # t1 points to the first character of the second string
 addi t2, x0, 0 # t2 is the loop counter for the second string
LOOP3:
 add t3, t1, t2 # t3 points to the current character in the second string
 lb t5, (0)t3 # Load the current character
 beqz t5, CHECK # If the character is null, go to CHECK
 addi t5, t5, -97 # Convert the character to an index (0-25)
 slli t5, t5, 2 # Multiply the index by 4 to get the offset in the frequency array
 add t5, t5, t0 # t5 points to the frequency of the current character in the array
 lw t3, 0(t5) # Load the current frequency
 addi t3, t3, -1 # Decrement the frequency
 sw t3, 0(t5) # Store the updated frequency
 addi t2, t2, 1 # Increment the loop counter
 j LOOP3 # Jump back to the beginning of the loop
CHECK:
 addi t0, sp, 0 # Reset t0 to point to the beginning of the frequency array
 addi t1, x0, 0 # t1 is the loop counter
 li t2, 26 # t2 is the length of the alphabet
LOOP4:
 beq t1, t2, TRUE # If the loop counter equals the alphabet length, go to TRUE
 lw t3, 0(t0) # Load the current frequency
 bnez t3, FALSE # If the frequency is non-zero, go to FALSE
 addi t1, t1, 1 # Increment the loop counter
 addi t0, t0, 4 # Move to the next element in the frequency array
 j LOOP4 # Jump back to the beginning of the loop
FALSE:
 addi a0, x0, 0 # Set the return value to false
 j EXIT_F # Jump to EXIT_F
TRUE:
 addi a0, x0, 1 # Set the return value to true
EXIT_F:
 jr ra # Jump back to the return address
