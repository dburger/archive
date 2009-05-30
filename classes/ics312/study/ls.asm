title touch
.model small
.386
.stack 100h
.data
    MAX_FILE_NAME EQU 100
    filespec db MAX_FILE_NAME dup(0)
    ;note that I make this 44 bytes instead of the dta
    ;43 bytes so I always have room to add a null char
    ;after the filename so I don't have to handle special
    ;cases
    dta db 44 dup(0)
    msg db "ls utility 0.9, by David J. Burger",'$'
    CRLF db 0Dh,0Ah,'$'
    DASH db "-",'$'
    SPACE db ' ','$'
    allFiles db "*.*",0
    dateStamp dw ?
    year dw ?
    month db ?
    day db ?
    hour db ?
    minutes db ?
    seconds db ?
.code
extrn Writeint:proc
main proc

    ;mov PSP to bx for Get_Commandtail
    mov bx,ds
    
    ;set up the data segments
    mov ax,@data
    mov ds,ax
    mov es,ax
    
    ;put command tail in filespec
    mov dx,offset filespec
    call Get_Commandtail
    
SetUpDTA:
    mov ah,1Ah
    mov dx,offset dta
    int 21h
        
    ;find the first file
    mov ah,4Eh
    mov cx,0 ;normal files
    mov dx,offset filespec
    mov si,offset filespec
    ;we see if they typed in a filespec
    cmp byte ptr [si],0
    ;if not, set the filespec to *.*
    jne FindFirst
    mov dx,offset allFiles
FindFirst:
    int 21h
    jc Exit
    
Loop1:

    mov di,seg dta
    mov es,di
    mov di,offset dta + 30 ;start of filename
    mov al,0               ;looking for the null
    mov cx,13              ;search count
    cld                    ;direction up
    repne scasb            ;repeat not equal
    sub di,1
    mov byte ptr [di],'$'
    
    mov si,offset dta + 24
    mov ax, word ptr [si]
    mov dateStamp, ax
    
    and ax,0000000000011111b
    mov bx,10
    call Writeint
    
    mov ah,9h
    mov dx,offset DASH
    int 21h
    
    mov ax,dateStamp
    and ax,0000000111100000b
    shr ax,5
    call Writeint
    
    mov ah,9h
    mov dx,offset DASH
    int 21h
    
    mov ax,dateStamp
    shr ax,9
    add ax,1980
    call Writeint
    
    mov ah,9h
    mov dx,offset SPACE
    int 21h
            
    mov ah,9h
    mov dx,offset dta + 30
    int 21h
    
    mov ah,9h
    mov dx,offset SPACE
    int 21h

    mov ax,offset dta + 26
    call Writeint
    
    mov ah,9h
    mov dx,offset CRLF
    int 21h
                
    ;find the next file
    mov ah,4fh
    int 21h
    jc Exit
    jmp Loop1
    
Exit:
    mov ax,4C00h
    int 21h
main endp

Get_Commandtail proc
    pusha
    mov es,bx
    mov si,dx
    mov di,81h
    mov cx,0
    mov cl,es:[di-1]
    cmp cx,0
    je L2
    mov al,20h
    repz scasb
    jz L2
    dec di
    inc cx    
    
L1: mov al,es:[di]
    mov [si],al
    inc si
    inc di
    loop L1
    clc
    jmp L3
    
L2: stc
L3: popa
    ret
Get_Commandtail endp

end main
    
