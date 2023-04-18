.text
.global _start
.extern printf

// Zachary Rimshnick
// I pledge my honor that I have abided by the Stevens Honor System.

_start:                // starts program
    
    ADR  X1, arr       // loads array address into X1
    ADR  X2, length    // loads length address into X2
    ADR  X3, target    // loads target address into X3
    LDR  X22, [X2]     // loads length of arr into X21
    LDR  X23, [X3]     // loads our target value 
    MOV  X4, 0         // x4 is LOW INDEX, of 0
    MOV  X6, X22       // sets length as HIGH INDEX

Loop:                   // main loop for binary search

    ADD  X5, X4, X6     // part 1 of MID INDEX equation
    LSR  X5, X5, 1      // part 2 of MID INDEX: right shift by 1 to divide by 2
    LSL  X10, X5, 3     // mult. # of elems by 8 (size of numbers) GET HIGH INDEX
    LDR  X8, [X1,X10]   // loads array at index MID into x8
    
    CMP  X23, X8       // compares target and X8
    B.EQ  InArray      // if equal, then done

    CMP  X4, X6        // Compare LOW and HIGH INDEX
    B.EQ  NotInArray   // if equal, then done 

    CMP  X23, X8       // compares target and X8
    B.GT  TargetGTMid  // if target is greater than MID, do GT operation branch

    SUB X6, X5, 1      // new HIGH INDEX = MID INDEX - 1
    CMP  X23, X8       // compares target and x8
    B.LT  TargetLTMid  // if target is less than MID, do LT operation branch

TargetGTMid:           // if target > MID INDEX
    ADD  X4, X5, 1     // new LOW INDEX = MID INDEX + 1

TargetLTMid:           // if target is < MID INDEX
    B    Loop          // after operation, do loop again

NotInArray:            // loop when not in array
    ADR  X0, msg2      // loads not in array message
    MOV  X1, X23       // moves target value to reg x1
    BL   printf        // prints 
    B    Done          // branches to Done, because its over

InArray:               // loop when in array
    ADR  X0, msg1      // loads in array message to x0
    MOV  X1, X23       // moves target value to reg x1
    BL   printf        // prints

Done:                  // all done

	MOV  X0, 0         /* status :=0 */
	MOV  X8, 93        /* exit is syscall #1 */
	SVC  0             /* invoke syscall */
    

.data
    arr:    .quad  -40, -25, -1, 0, 100, 300      // array
    length: .quad  6                              // # of elems
    target: .quad  -25                            // target number in array
    msg1:   .string "Target %ld is in the array.\n"     // return message 1
    msg2:   .string "Target %ld is not in the array.\n" // return message 2
