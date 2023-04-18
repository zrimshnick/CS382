.text
.global _start

// Zachary Rimshnick
// I pledge my honor that I have abided by the Stevens Honor System.

_start:
    
       ADR  X23, src_str   // loads src_str starting string into X23
       ADR  X24, dst_str   // loads dst_str destination string into X24
       MOV  X1, 0          // X1 will contain the value of i which starts as 0

Begin:                       // starts copy

       LDRB   W20, [X23,X1]  // *(str+i) loaded into X20
       STRB   W20, [X24,X1]  // stores it back into memory
       CBZ    W20, After     // Checks if array at index is empty
       ADD    X1, X1, 1      // increments index i by 1
       B      Begin          // runs loop again

After:                       // program all done

	MOV  X0, 0         /* status :=0 */
	MOV  X8, 93        /* exit is syscall #1 */
	SVC  0             /* invoke syscall */
    

.data
    src_str: .string  "zack" // source string

.bss
    dst_str: .skip  100      // destination string
    