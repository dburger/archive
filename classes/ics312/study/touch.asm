title touch
.model small
.386
.stack 100h
.data
    MAX_FILE_NAME EQU 100
    filespec db MAX_FILE_NAME dup(0)
    dta db 43 dup(0)
    msg db "touch utility 0.9, by David J. Burger",'$'
    CRLF db 0Dh,0Ah,'$'
    fileHandle dw ?
    year dw ?
    month db ?
    day db ?
    hour db ?
    minutes db ?
    seconds db ?
    filenameOffset dw ?
.code
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
    
    ;find the last \ in the filespec if it exists
    ;point at the last character in filespec
    mov ax,seg filespec
    mov es,ax
    mov di,offset filespec + (MAX_FILE_NAME - 1)
    mov cx,MAX_FILE_NAME    ;maximum checks
    mov al,'\'              ;character looking for
    std                     ;direction = back
    repne scasb
    jnz InCurrentDirectory  ;if \ not found
    
    ;set di to the location where a filename
    ;could be concatenated with the path
    add cx,1
    mov filenameOffset,cx
    jmp SetUpDTA
    
InCurrentDirectory:
    mov filenameOffset,0
    
SetUpDTA:
    mov ah,1Ah
    mov dx,offset dta
    int 21h
    
    ;store todays date
    mov ah,2Ah
    int 21h
    sub cx,1980
    mov year,cx
    mov month,dh
    mov day,dl
    
    ;store the time
    mov ah,2Ch
    int 21h
    mov hour,ch
    mov minutes,cl
    mov seconds,dh
    
    ;find the first file
    mov ah,4Eh
    mov cx,0 ;normal files
    mov dx,offset filespec
    int 21h
    jc Exit
    
Loop1:

    ;copy the filename into the filespec
    ;concatenating with the correct path
    mov cx,13
    cld ;direction up
    mov si,offset dta + 30 ;where the filename is in the dta
    mov di,offset filespec
    add di,filenameOffset
    rep movsb    
    
    ;open the file
    mov ah,3Dh
    mov al,0
    ;using the filespec with the filename copied in
    mov dx,offset filespec
    int 21h
    jc Exit
    mov fileHandle,ax
    
    ;set up the date in dx
    mov ax,0
    mov bx,0
    mov dx,0
    mov al,day
    mov bl,month
    shl bx,5
    mov dx,year
    shl dx,9
    or dx,ax
    or dx,bx
    
    ;set up the time in cx
    mov ax,0
    mov bx,0
    mov cx,0
    mov al,seconds
    mov bl,minutes
    shl bx,5
    mov cl,hour
    shl cx,11
    or cx,ax
    or cx,bx
    
    ;set the files date/time
    mov al,1
    mov ah,57h
    mov bx,fileHandle
    int 21h
    
    ;close the file
    mov ah,3Eh
    mov bx,fileHandle
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
    
