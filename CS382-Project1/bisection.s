.text
.global _start
.extern printf

// Zachary Rimshnick
// I pledge my honor that I have abided by the Stevens Honor System.

Proc:                   // main procedure starts 
    SUB  SP, SP, 8      // set stack pointer by size
    STR  LR, [SP]       // store LR on the stack


getfA:                    // procedure to get the LOWER BOUND a y value f(a)
    LDR    D1, [X1, X7]   // loads current index (coefficient) into d1

    FMUL   D1, D1, D17    // coefficient*x

    FADD   D13, D13, D1   // puts product into the D13 f(a)

    ADD    X7, X7, 8      // incremments index by 8
    FMUL   D17, D17, D3   // increments the x by f(a)
    ADD    X20, X20, 1    // incrememnt counter by 1

    CMP    X20, X2        // counter and highest power
    B.LE   getfA          // while counter less than, do getfA again

    MOV    X7, 0          // decrement back to 0
    FMOV   D17, D18       // decrement back to 1
    MOV    X20, 0         // decrement back to 0
 

getfB:                   // procedure to get the UPPER BOUND b y value f(b) 
    LDR    D1, [X1, X7]   // loads current index (coefficient) into d1

    FMUL   D1, D1, D17    // coefficient*x

    FADD   D14, D14, D1   // puts product into the D13 f(a)

    ADD    X7, X7, 8      // incremments index by 8
    FMUL   D17, D17, D4   // increments the x by f(a)
    ADD    X20, X20, 1    // incrememnt counter by 1

    CMP    X20, X2        // counter and highest power
    B.LE   getfB          // while counter less than, do getfB again

    MOV    X7, 0          // decrement back to 0
    FMOV   D17, D18       // decrement back to 1
    MOV    X20, 0         // decrement back to 0

getC:                    // just gets the midpoint x value
    FADD  D5, D3, D4      // adds a and b x values
    FDIV  D5, D5, D22     // divides (a+b) by 2


getfC:                   // procedure to get the MIDPOINT c y value f(C)
    LDR    D1, [X1, X7]   // loads current index (coefficient) into d1

    FMUL   D1, D1, D17    // coefficient*x

    FADD   D15, D15, D1   // puts product into the D13 f(a)

    ADD    X7, X7, 8      // incremments index by 8
    FMUL   D17, D17, D5   // increments the x by f(a)
    ADD    X20, X20, 1    // incrememnt counter by 1

    CMP    X20, X2        // counter and highest power
    B.LE   getfC          // while counter less than, do getfC again

    MOV    X7, 0          // decrement back to 0
    FMOV   D17, D18       // decrement back to 1
    MOV    X20, 0         // decrement back to 0

/////// check if were done  

    FCMP   D26, D15       // compares negative tolerance and f(c)
    B.LE   skip           // if -t < f(c), then gotta check next
    B      chooseBounds   //  else, skip to chooseBounds

skip:                    // skip
    FCMP   D15, D6        // compares f(c) and tolerance
    B.LE   Done           // if f(c) < t, then done
    B      chooseBounds   //  else, skip to chooseBounds


/////// NOW NEED TO CHECK WHICH TO USE EITHER f(a) and f(b) or f(b) and f(c)  
chooseBounds:            // label to check/choose bounds
    FCMP   D15, D19       // Compares midpoint f(c) and 0 to check if we are at root (unlikely) 
    B.EQ   Done           // if equal, then go to Done

    FCMP   D13, D19       // Compares f(a) and 0
    B.EQ   Done           // if f(a) = 0, then Done

    FCMP   D14, D19       // Compares f(b) and 0
    B.EQ   Done           // if f(b) = 0, then Done

    FCMP   D13, D19       // Compares f(a) and 0
    B.GT   fApos          // if f(a) > 0, then check midpoint f(c)

    B      fAneg          // if f(a) < 0, then go to fAneg

fApos:                   // f(a) is positive
    FCMP   D15, D19       // Compares f(c) and 0
    B.LT   gotAandC       // if f(c) < 0, then that means f(a) is + and f(c) is - and we gotBounds
    
    FCMP   D14, D19       // Compares f(b) and 0
    B.LT   gotBandC       // if f(b) < 0, and f(c) is > 0, then gotBounds  

fAneg:                   // f(a) is negative
    FCMP   D15, D19       // Compares f(c) and 0
    B.GT   gotAandC       // if f(c) > 0, and f(a) < 0, then gotBounds

    B      gotBandC       // since f(c) < 0 and f(a) < 0, it must be b and c

gotAandC:                // got bounds A and C
    FMOV   D3, D3         // copy a to a
    FMOV   D4, D5         // copy c to b
    
    FMOV   D13, D19       // copies 0 to reset f(a)
    FMOV   D14, D19       // copies 0 to reset f(b)
    FMOV   D15, D19       // copies 0 to reset f(c)

    B      getfA          // now that we have our new a and b, do again

gotBandC:                // got bounds B and C
    FMOV   D3, D5         // copy c to a
    FMOV   D4, D4         // copy b to b

    FMOV   D13, D19       // copies 0 to reset f(a)
    FMOV   D14, D19       // copies 0 to reset f(b)
    FMOV   D15, D19       // copies 0 to reset f(c)

    B      getfA          // now that we have our new a and b, do again

Done:                     // Label for when done with program
    FMOV   D0, D5         // copies c to d0 for printing root
    FMOV   D1, D15        // copies f(c) to d1 for printing y value

    BL     printf         // prints
    
    LDR  LR, [SP]         // loads LR from stack pointer
    ADD  SP, SP, 8        // sets stack pointer by size

    RET                   // return end

_start:                // starts program
    ADR  X0, msg       // loads string into x0
    ADR  X1, coeff     // loads array of coefficients into x1
    ADR  X2, N         // loads the highest power of x into x2
    ADR  X3, a         // loads the lower bound into x3
    ADR  X4, b         // loads the upper bound into x4
    ADR  X6, t         // loads the tolerance into x6
    ADR  X26, neg      // loads -1 into x26

    LDR  X2, [X2]      // loads highest power into x2
    LDR  D3, [X3]      // loads lower bound into x3
    LDR  D4, [X4]      // loads upper bound into x4
    LDR  D6, [X6]      // loads tolerance into x6
    LDR  D26,[X26]     // loads -1 into x6
    FMUL D26, D26, D6  // gets negative tolerance 

    MOV   X5, 0        // C value initialize
    MOV   X7, 0        // INDEX
    MOV   X8, 8        // loads 0 into x5 for the midpoint
    MOV   X13, 0       // initializes x13 f(a)
    MOV   X14, 0       // initializes x14 f(b)
    MOV   X15, 0       // initializes x15 f(c)
    MOV   X16, X2      // moves high power to make temp high power
    MOV   X17, 1       // current value reg that starts at 1
    MOV   X18, 1       // WILL STAY AS 1
    MOV   X19, 0       // WILL STAY AS 0
    MOV   X20, 0       // COUNTER
    MOV   X22, 2       // WILL STAY AS 2

    SCVTF D2, X2       // converts x2 (coefficient) into a double in d2
    SCVTF D5, X5       // converts c to double
    SCVTF D8, X8       // coneverts 1 to a double in d5
    SCVTF D13, X13     // converts f(a) to double 
    SCVTF D14, X14     // converts f(b) to double
    SCVTF D15, X15     // converts f(c) to double
    SCVTF D16, X16     // converts temp high power to double
    SCVTF D17, X17     // converts x17 into a doulbe in d17
    SCVTF D18, X18     // converts 1 to double
    SCVTF D19, X19     // converts 0 to double 
    SCVTF D22, X22     // converts 2 to double


    BL  Proc           // calls procedure


	MOV  X0, 0         /* status :=0 */
	MOV  X8, 93        /* exit is syscall #1 */
	SVC  0             /* invoke syscall */
    

.data
    coeff:  .double   0.2, 3.1, -0.3, 1.9, 0.2  // coefficients
    N:      .dword    4    // degree/highest power of x
    a:      .double   -1   // lower x bound
    b:      .double   1    // upper x bound
    t:      .double   .01  // tolerance must be double
    neg:    .double   -1   // negative 1
    msg:    .string  "root = %lf, function value = %lf \n"  // string for return
