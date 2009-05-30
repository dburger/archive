title string tester
.model small
.stack 100h
.data
    buffer db 20 dup (0)
    handle dw ?
    char_buffer db ?
.code
extrn Readstring:proc
main proc
  mov ax,@data
  mov ds,ax
  
  mov dx,offset buffer
  mov cx,20
  call Readstring
    
  mov ah,3Ch
  mov dx,offset buffer
  mov cx,00h
  int 21h  
  
  mov handle,ax

Loop1:
  mov ah,01h
  int 21h
  cmp al,'!'
  je Exit
  mov char_buffer,al
  mov ah,40h
  mov cx,1
  mov bx,handle
  mov dx,offset char_buffer
  int 21h
  jmp Loop1  
           
Exit:           
  mov ah,3Eh
  mov bx,handle
  int 21h
  
  mov ax,4C00h
  int 21h
  
main endp
end main
