INCLUDE 'EMU8086.INC'                 ;Include the 'EMU8086.INC' Library

.model small                          ;Create a SMALL model for the program

.data                                 ;Start of the DATA segment

    ;-----------------------------------------
    ;Array of 9 integers (Shows the price values of items that are to be prioritized)
    arr dw 3h,9h,1h,4h,2h,7h,0h,5h,6h,8h          
    ;-----------------------------------------

    i   dw  ? 
    j   dw  ?
    p   dw  0                         ;Array index starting from value 0
    r   dw  10                        ;Array index ending at the value (Array length - 1)
    q   dw  ?
    x   dw  ?

.stack                                ;Start of the STACK segment

    stk db  100  dup(0)               ;Create stack of space 100 with filled with 0 values
    top equ 100                       ;Initialization of Top of Stack to the 100th position of Stack

.code                                 ;Start of the CODE segment
    start:                            

        ;INITIALIZE DATA SEGMENT
        
        mov  ax, @data ;Allocating the instruction address for Data segment to AX register
        mov  ds, ax    ;Moving value of AX register to Data Segment(DS) Register
        mov  ax, stack ;Allocating the instruction address for Stack segment to AX register
        mov  ss, ax    ;Moving value of AX register to Stack Segment (SS) Register
        mov  sp, top   ;Allocating the address of Top of Stack to Stack Pointer (SP)
                           
        ;CALL QUICKSORT(A, 0, A.LENGTH-1)
        call quicksort
        
        
        
        ;DISPLAYING THE PRIORITIZED ITEM LIST ON THE OUTPUT CONSOLE
        printn        
        print "The prioritized item values are as follows:"                ;Print String "Output" on the Console
        printn
        
        mov cx,10                     ;Assign the immediate value 8 to the CX register for counting
 
         
        mov si,offset arr + '0'       ;Provide the Offset value of the provided array to Source Index (SI) Register
                                      ;Add string value '0' to the offset so as to retain the ascii value to 0 
       
                           
        l1:                           ;Create a label l1
           mov ah,2                   ;Interrupt to write character to standard output
           mov dx,arr[si]             ;Write the value stored at index si in the given array to DX register, so as to display it on screen
           printn
           int 21h
           
           
           inc si                     ;Increment the value in Source Index (SI) Register
           loop l1                    ;Repeat loop until all values of array are printed (i.e. SI == CX)
        
        ;WAIT FOR ANY KEY.
        mov  ah, 7                    ;Interrupt to cause input of character without echoing it on console
        int  21h

        ;FINISH PROGRAM.
        mov  ax, 4c00h                ;Interrupt to terminate the program by returning control to the Operating System (OS)
        int  21h
        
        ;PSEUDOCODE FOR THE QUICKSORT ALGORITHM
        ;-----------------------------------------
        ;QUICKSORT(A, p, r)
        ;    if p < r
        ;        q = PARTITION(A, p, r)
        ;        QUICKSORT(A, p, q-1)
        ;        QUICKSORT(A, q+1, r)
        
        
        ;IMPLEMENTING THE QUICKSORT PSUEDOCODE AS A PROCEDURE
        quicksort proc                  ;Create a standard procedure function "Quicksort"

            ;COMPARE P WITH R.
            mov  ax, p 
            cmp  ax, r                  ;Compare the values p and r
            jge  bigger1                ;If p and r are equal to each other, jump to bigger else continue

            ;CALL PARTITION(A, P, R).
            call partition              ;Partitioning the given array on the basis of p and r values

            ;GET Q = PARTITION(A, P, R).
            mov  q, ax                  ;Initialize the variable Q with the returned partioned array

            ;PUSH Q+1, R INTO STACK FOR LATER USAGE.
            inc  ax                     ;Increment the AX register
            push ax                     ;Push the value of AX to stack
            push r                      ;Push the value r to stack

            ;CALL QUICKSORT(A, P, Q-1).
            mov  ax, q                  
            mov  r, ax                  ;Move the partioned value q to r
            dec  r                      ;Decrement the value of r
            call quicksort              ;Apply quick sort on the given array for the value p and r

            ;CALL QUICKSORT(A, Q+1, R).
            pop  r                      ;Pop the value r from the stack
            pop  p                      ;Pop the value p from the stack
            call quicksort              ;Apply quick sort on the given arra for the value p and r
             

            ;WHEN SORT IS DONE.
            bigger1:                     
                ret                     ;If p > r is satisfied, return the result

        quicksort endp                  ;End the procedure "Quicksort"
        
        ;PSEUDOCODE FOR THE PARTIONING OF ARRAY 
        ;-----------------------------------------
        ;PARTITION(A, p, r)
        ;    x = A[r]
        ;    i = p - 1
        ;    for j = p to r-1
        ;        if A[j] <= x
        ;            i = i + 1
        ;            exchange A[i] with A[j]
        ;    exchange A[i+1] with A[r]
        ;    return i+1
        
        ;IMPLEMENTING THE PSEUDOCODE FOR PARTIONING AS A PROCEDURE
        partition proc

            ;GET X = ARR[ R ].
            mov  si, offset arr         ;Provide the offset value of the provided array to Source Index (SI) Register
            mov  ax, r                  ;Copy the value stored in variable r to AX register
            shl  ax, 1                  ;Perform shift operand left by 1 since every counter is 2 bytes
            add  si, ax                 ;Add the obtained AX register value to the Source Index
            mov  ax, [ si ]             ;Copy the value stored at the rth index of given array to AX register
            mov  x,  ax                 ;X = ARR[ R ].

            ;GET I = P - 1.
            mov  ax, p                  ;Copy the immediate value p into AX register
            mov  i,  ax                 ;Copy the value of AX register to the variable i
            dec  i                      ;Decrement the value of variable i

            ;INITIALISE J WITH P.
            mov  ax, p                  ;Copy the variable value p to the AX register
            mov  j,  ax                 ;Copy the value of AX register to variable j

            ;LOOP J FROM P TO R-1.
            for_j:                      ;Applying a for loop

                ;GET ARR[ J ].
                mov  si, offset arr     ;Provide the offset value of the provided array to Source Index (SI) Register
                mov  ax, j              ;Copy the variable value j into the AX register
                shl  ax, 1              ;Perform shift operand left by 1 since every counter is 2 bytes
                add  si, ax             ;Copy the value stored at the jth index of given array to SI register
                mov  ax, [ si ]         ;AX = ARR[ J ]

                ;COMPARE A[ J ] WITH X.
                cmp  ax, x              ;Compare value X with stored in AX register(ARR[ J ])
                jg   bigger             ;If A[ J ] > X , then jump to the label "bigger" else continue

                ;GET I = I + 1.
                inc  i                  ;Increment value of variable i
                
                ;GET ARR[ I ].
                mov  di, offset arr     ;Provide the offset value of the provided array to the Destination Index (DI) Register
                mov  cx, i              ;Copy the variable value i to the CX register
                shl  cx, 1              ;Perform shift operand left by 1 since every counter is 2 bytes
                add  di, cx             ;Add the obtained CX register value to the Destination Index
                mov  cx, [ di ]         ;CX = ARR[ I ].

                ;EXCHANGE ARR[ I ] WITH ARR[ J ].
                mov  [ di ], ax         ;Copy the value stored in AX register to the ith index
                mov  [ si ], cx         ;Copy the value stored in CX register to the jth index
            
                ;GET NEXT J.
                bigger:                 ;Defining the label "bigger"
                    inc  j              ;Incrementing the variable j
                    mov  ax, r          ;Copy the variable value r to the AX register
                    cmp  j,  ax         ;Compare the values j and r
                    jl   for_j          ;If J = R - 1 then continue the loop else break it

            ;GET ARR[ i+1 ].
            inc  i                      ;Increment the value of vairable i
            mov  si, offset arr         ;Provide the offset value of the provided array to the Source Index (SI) Register
            mov  ax, i                  ;Copy the variable value 
            shl  ax, 1                  ;Perform shift operand left by 1 since every counter is 2 bytes
            add  si, ax                 ;Copy the value stored in AX register to SI register
            mov  ax, [ si ]             ;AX = ARR[ I+1 ].

            ;GET ARR[ R ].
            mov  di, offset arr         ;Provide the offset value of the provided array to the Destnation Index (DI) Register
            mov  cx, r                  ;Copy the value of variable r into CX register
            shl  cx, 1                  ;Perform shift operand left by 1 since every counter is 2 bytes
            add  di, cx                 ;Add the obtained CX register value to the Destination Index
            mov  cx, [ di ]             ;CX = ARR[ R ].

            ;EXCHANGE ARR[ I+1 ] WITH ARR[ R ].
            mov  [ di ], ax             ;Copy the value stored in AX register to the i+1th index
            mov  [ si ], cx             ;Copy the value stored in CX register to the rth index

            ;RETURN I+1.
            mov  ax, i                  ;Copy the value stored in variable i to AX register
            ret                         ;Return the value of AX register (pivot value for partition)

        partition endp                  ;End the partition procedure
                  
    ends ;End of Code Program
    
end start