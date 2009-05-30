title Program
.model small
.stack 100h
.data
    aByte db 0ACh
    tester db 00000001b
.code
main proc
    mov ax,@data
    mov ds,ax

    mov cx,8
Loop1:
    mov al,aByte
    test al,tester
    jz Zero
    mov dl,'1'
    jmp Continue
Zero:
    mov dl,'0'
Continue:
    mov ah,2
    int 21h
    shl tester,1
    loop Loop1
    
    mov ax,4C00h
    int 21h

main endp
end main
