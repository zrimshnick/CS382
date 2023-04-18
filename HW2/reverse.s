.text
.global _start

// Zachary Rimshnick
// I pledge my honor that I have abided by the Stevens Honor System.

_start:                    // this will flip the order of a nibble
    
       ADR  X1,  arr       // Loads address of arr into x1
       ADR  X23, length    // Loads address of length into X25
       MOV  X24, 4         // X26 contains length of integer
       LDR  W21, [X23]     // loads num of elements in arr to X21
       ADD  X21, X21, 1    // needed for later

       
StartNibble:              // starts flipping nibbles
       MOV  X20, 0        // counter reset to 0
       SUB  X21, X21, 1   // removes the add from line 14
       LSL  X25, X21, 2   // multiplies # of elem by 4 (len of int), X25 becomes 12 
       SUB  X25, X25, 4   // X25 subtracted by 4 to get furthest right, X25 is 12-4

       CMP  X25, 0        // check if index has gone below 0
       B.GE    DoNibble   // actually does the nibble loop

       MOV  X25, 0        // sets x25 as 0
       ADR  X15, length   // gets num of elems again
       LDR  W16, [X15]    // loads num of elems into x16
       LSL  X26, X16, 2   // Multiplies rightmost index by 4
       SUB  X26, X26, 4   // Rightmost index - 4 

       B  SwappingWords   // otherwise branch to done

DoNibble:                 // swaps nibbles
       LDRB W2, [X1,X25]  // loads first nibble of arr into w2
       LSR  W3, W2, 4     // right shift 4 to get left element
       LSL  W4, W2, 28    // left shift 28 to get right element back
       LSR  W4, W4, 28    // right shift 28 gets second digit
       LSL  W5, W4, 4     // left shift 4 removes the 0s from right
       ORR  W5, W5, W3    // logical OR to combine the two into a nibble
       STRB  W5, [X1,X25] // stores flipped nibble in its old place
       
       ADD  X25, X25, 1    // increment the index
       ADD  X20, X20, 1    // increment counter
       SUB  X19, X24, X20  // check if counter is at 4 yet
       CBNZ  X19, DoNibble  // if counter-4 is 0, then do next nibble

       //// SWAP FIRST AND LAST AND MIDDLE TWO NIBBLES

       SUB  X25, X25, 1    // de increment
       LDRB W6, [X1,X25]   // load front nibble into temp W6
       SUB  X25, X25, 3    // goes from front index to back
       LDRB W7, [X1,X25]   // load back nibble into temp W7
       STRB W6, [X1,X25]   // stores old front in back
       ADD  X25, X25, 3    // goes from back index to front
       STRB W7, [X1,X25]   // stores old back into front
       ADD  X25, X25, 1    // gives X25 back its 1

       SUB  X25, X25, 2    // get index to middle index
       LDRB W8, [X1,X25]   // Load middle1 nibble to temp W8
       SUB  X25, X25, 1    // goes to next middle index
       LDRB W9, [X1,X25]   // loads middle2 nibble to temp W9
       STRB W8, [X1,X25]   // stores old middle1 in middle2
       ADD  X25, X25, 1    // get back to other middle index
       STRB W9, [X1,X25]   // stroes old middle2 in middle1
       ADD  X25, X25, 2    // gets back to max index to continue loop

       B    StartNibble    // Does DoNibble again

SwappingWords:            // swaps words

       CMP   X16, 1       // If # of words left is 1, then done
       B.EQ  Done         // if # of words is = 1, then done

       CMP   X16, 0       // if # of words left is 0, then done
       B.EQ  Done         // if # of words is = 0, then done

       LDR  W11, [X1,X25] // loads index leftmost of array to temp x11
       LDR  W12, [X1,X26] // loads index rightmost of array to temp x12
       STR  W11, [X1,X26] // stores old outerleft in new outerright
       STR  W12, [X1,X25] // stores old outerright in new outerleft

       SUB  X16, X16, 2   // takes away the 2 swapped from the total # elems
       ADD  X25, X25, 4   // add 4 more to X25
       SUB  X26, X26, 4   // take away 4 from X26

       B   SwappingWords  // loops back and does again
        
Done:                        // program all done
	   MOV  X0, 0         /* status :=0 */
	   MOV  X8, 93        /* exit is syscall #1 */
	   SVC  0             /* invoke syscall */
    

.data
    arr:    .word  0x12BFDA09, 0x9089CDBA, 0x56788910  // source int array
    //should get:  0x01988765  0xABDC9809  0x90ADFB21  
    length: .word  3                                   // length of array

    