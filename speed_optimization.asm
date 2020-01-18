TEXT_MAX_SIZE equ 50000
extern printf

section .bss

text: ;g_wat5
	resb TEXT_MAX_SIZE

section .data

tsc_string: 
	db "0x", 0, 0, 0, 0, 0, 0, 0, 0, 10, 0

filename_buffer: ; g_wat3
	times 50 db 0
needle: ;g_wat4
	times 50 db 0
options: ;g_wat6
	dd 0
start_index: ;g_wat7
	dd 0
end_index: ;g_wat8
	dd 0
argc:   ;_edata
	dd 0
argv:	;wat2
	dd 0
minus_f:
	db 0x2d, 0x66, 0
minus_s:
	db 0x2d, 0x73, 0
minus_e:
	db 0x2d, 0x65, 0
minus_i:
	db 0x2d, 0x69, 0

section .text

global main

syscall_wrapper:
	push   ebp	
	mov    ebp,esp
	push   esi
	push   ebx
	sub    esp,0x10
	mov    DWORD [ebp-0xc],0x0
	mov    eax,DWORD [ebp+0x8]
	mov    ebx,DWORD [ebp+0xc]
	mov    ecx,DWORD [ebp+0x10]
	mov    edx,DWORD [ebp+0x14]
	int    0x80
	mov    esi,eax
	mov    DWORD [ebp-0xc],esi
	mov    eax,DWORD [ebp-0xc]
	add    esp,0x10
	pop    ebx
	pop    esi
	pop    ebp
	ret    

do_exit:
	push   ebp
	mov    ebp,esp
	mov    eax,DWORD [ebp+0x8]
	push   0x0
	push   0x0
	push   eax
	push   0x1
	call   syscall_wrapper
	add    esp,0x10
	nop
	leave  
	ret    

do_write:
	push   ebp
	mov    ebp,esp
	mov    edx,DWORD [ebp+0x10]
	mov    eax,DWORD [ebp+0x8]
	push   edx
	push   DWORD [ebp+0xc]
	push   eax
	push   0x4
	call   syscall_wrapper
	add    esp,0x10
	leave  
	ret    

do_read:
	push   ebp
	mov    ebp,esp
	mov    edx,DWORD [ebp+0x10]
	mov    eax,DWORD [ebp+0x8]
	push   edx
	push   DWORD [ebp+0xc]
	push   eax
	push   0x3
	call   syscall_wrapper
	add    esp,0x10
	leave  
	ret    

do_open:
	push   ebp
	mov    ebp,esp
	mov    edx,DWORD [ebp+0x10]
	mov    eax,DWORD [ebp+0xc]
	push   edx
	push   eax
	push   DWORD [ebp+0x8]
	push   0x5
	call   syscall_wrapper
	add    esp,0x10
	leave  
	ret    

do_close:
	push   ebp
	mov    ebp,esp
	mov    eax,DWORD [ebp+0x8]
	push   0x0
	push   0x0
	push   eax
	push   0x6
	call   syscall_wrapper
	add    esp,0x10
	nop
	leave  
	ret    

read_from_file:
	push   ebp
	mov    ebp,esp
	sub    esp,0x10
	mov    DWORD [ebp-0x4],0x0
	push   0x0
	push   0x0
	push   DWORD [ebp+0x8]
	call   do_open
	add    esp,0xc
	mov    DWORD [ebp-0x8],eax
	cmp    DWORD [ebp-0x8],0x0
	jns    read_from_file_l1
	push   0xfffffff9
	call   do_exit
	add    esp,0x4
read_from_file_l1:
	mov    eax,DWORD [ebp+0x10]
	push   eax
	push   DWORD [ebp+0xc]
	push   DWORD [ebp-0x8]
	call   do_read
	add    esp,0xc
	mov    DWORD [ebp-0x4],eax
	push   DWORD [ebp-0x8]
	call   do_close
	add    esp,0x4
	mov    eax,DWORD [ebp-0x4]
	leave  
	ret    

print_string:
	push   ebp
	mov    ebp,esp
	sub    esp,0x18
	sub    esp,0xc
	push   DWORD [ebp+0x8]
	call   mystery1
	add    esp,0x10
	mov    DWORD [ebp-0xc],eax
	mov    eax,DWORD [ebp-0xc]
	sub    esp,0x4
	push   eax
	push   DWORD [ebp+0x8]
	push   0x1
	call   do_write
	add    esp,0x10
	nop
	leave  
	ret    

print_line:
	push   ebp
	mov    ebp,esp
	sub    esp,0x18
	mov    BYTE [ebp-0x9],0xa
	movsx  eax,BYTE [ebp-0x9]
	sub    esp,0x8
	push   eax
	push   DWORD [ebp+0x8]
	call   mystery2
	add    esp,0x10
	mov    DWORD [ebp-0x10],eax
	cmp    DWORD [ebp-0x10],0xfffffffe
	jne    print_line_l1
	sub    esp,0xc
	push   DWORD [ebp+0x8]
	call   print_string
	add    esp,0x10
	jmp    print_line_l2
print_line_l1:
	mov    eax,DWORD [ebp-0x10]
	add    eax,0x1
	sub    esp,0x4
	push   eax
	push   DWORD [ebp+0x8]
	push   0x1
	call   do_write
	add    esp,0x10
print_line_l2:
	nop
	leave  
	ret    

parse_opt:
	push   ebp
	mov    ebp,esp
	sub    esp,0x8
	sub    esp,0xc
	push   DWORD [ebp+0x8]
	call   mystery1
	add    esp,0x10
	cmp    eax,0x2
	je     parse_opt_l1
	sub    esp,0xc
	push   0xfffffffe
	call   do_exit
	add    esp,0x10
parse_opt_l1:
	sub    esp,0x4
	push   0x2
	push   minus_f
	push   DWORD [ebp+0x8]
	call   mystery3
	add    esp,0x10
	test   eax,eax
	jne    parse_opt_l2
	mov    eax,0x8
	jmp    parse_opt_l5
parse_opt_l2:
	sub    esp,0x4
	push   0x2
	push   minus_s
	push   DWORD [ebp+0x8]
	call   mystery3
	add    esp,0x10
	test   eax,eax
	jne    parse_opt_l3
	mov    eax,0x2
	jmp    parse_opt_l5
parse_opt_l3:
	sub    esp,0x4
	push   0x2
	push   minus_e
	push   DWORD [ebp+0x8]
	call   mystery3
	add    esp,0x10
	test   eax,eax
	jne    parse_opt_l4
	mov    eax,0x4
	jmp    parse_opt_l5
parse_opt_l4:
	sub    esp,0x4
	push   0x2
	push   minus_i
	push   DWORD [ebp+0x8]
	call   mystery3
	add    esp,0x10
	test   eax,eax
	jne    parse_opt_l6
	mov    eax,0x1
	jmp    parse_opt_l5
parse_opt_l6:
	mov    eax,0xfffffffe
parse_opt_l5:
	leave  
	ret    

parse_args:
	push   ebp
	mov    ebp,esp
	sub    esp,0x18
	mov    DWORD [ebp-0xc],0x0
	mov    DWORD [ebp-0x14],0x0
	mov    DWORD [ebp-0x10],0x0
	mov    DWORD [ebp-0x18],0x0
	mov    DWORD [ebp-0xc],0x1
	jmp    parse_args_l1
parse_args_l2:
	mov    eax, [argv]
	mov    edx,DWORD [ebp-0xc]
	shl    edx,0x2
	add    eax,edx
	mov    eax,DWORD [eax]
	movzx  eax,BYTE [eax]
	cmp    al,0x2d
	jne    parse_args_l3
	mov    eax,[argv]
	mov    edx,DWORD [ebp-0xc]
	shl    edx,0x2
	add    eax,edx
	mov    eax,DWORD [eax]
	sub    esp,0xc
	push   eax
	call   parse_opt
	add    esp,0x10
	mov    DWORD [ebp-0x14],eax
	cmp    DWORD [ebp-0x14],0xfffffffe
	jne    parse_args_l4
	sub    esp,0xc
	push   0xfffffffe
	call   do_exit
	add    esp,0x10
parse_args_l4:
	mov    eax,DWORD [ebp-0x14]
	and    eax,DWORD [ebp-0x10]
	test   eax,eax
	je     parse_args_l5
	sub    esp,0xc
	push   0xfffffffd
	call   do_exit
	add    esp,0x10
parse_args_l5:
	mov    eax,DWORD [ebp-0x14]
	or     DWORD [ebp-0x10],eax
	mov    eax,DWORD [ebp-0x14]
	cmp    eax,0x2
	je     parse_args_l6
	cmp    eax,0x2
	jg     parse_args_l7
	cmp    eax,0x1
	je     parse_args_l10
	jmp    parse_args_l11
parse_args_l7:
	cmp    eax,0x4
	je     parse_args_l8
	cmp    eax,0x8
	je     parse_args_l9
	jmp    parse_args_l11
parse_args_l9:
	mov    eax,[argv]
	mov    edx,DWORD [ebp-0xc]
	add    edx,0x1
	shl    edx,0x2
	add    eax,edx
	mov    eax,DWORD [eax]
	sub    esp,0xc
	push   eax
	call   mystery1
	add    esp,0x10
	mov    DWORD [ebp-0x18],eax
	cmp    DWORD [ebp-0x18],0x1f
	jle    parse_args_l12
	sub    esp,0xc
	push   0xfffffffc
	call   do_exit
	add    esp,0x10
parse_args_l12:
	mov    edx,DWORD [ebp-0x18]
	mov    eax,[argv]
	mov    ecx,DWORD [ebp-0xc]
	add    ecx,0x1
	shl    ecx,0x2
	add    eax,ecx
	mov    eax,DWORD [eax]
	sub    esp,0x4
	push   edx
	push   eax
	push   needle
	call   mystery4
	add    esp,0x10
	jmp    parse_args_l11
parse_args_l10:
	mov    eax,[argv]
	mov    edx,DWORD [ebp-0xc]
	add    edx,0x1
	shl    edx,0x2
	add    eax,edx
	mov    eax,DWORD [eax]
	sub    esp,0xc
	push   eax
	call   mystery1
	add    esp,0x10
	mov    DWORD [ebp-0x18],eax
	cmp    DWORD [ebp-0x18],0x1f
	jle    parse_args_l13
	sub    esp,0xc
	push   0xfffffffc
	call   do_exit
	add    esp,0x10
parse_args_l13:
	mov    edx,DWORD [ebp-0x18]
	mov    eax,[argv]
	mov    ecx,DWORD [ebp-0xc]
	add    ecx,0x1
	shl    ecx,0x2
	add    eax,ecx
	mov    eax,DWORD [eax]
	sub    esp,0x4
	push   edx
	push   eax
	push   filename_buffer
	call   mystery4
	add    esp,0x10
	jmp    parse_args_l11
parse_args_l8:
	mov    eax,[argv]
	mov    edx,DWORD [ebp-0xc]
	add    edx,0x1
	shl    edx,0x2
	add    eax,edx
	mov    eax,DWORD [eax]
	sub    esp,0xc
	push   eax
	call   mystery7
	add    esp,0x10
	mov    DWORD [ebp-0x18],eax
	cmp    DWORD [ebp-0x18],0xffffffff
	jne    parse_args_l14
	sub    esp,0xc
	push   0xfffffffb
	call   do_exit
	add    esp,0x10
parse_args_l14:
	mov    eax,DWORD [ebp-0x18]
	mov    [end_index],eax
	jmp    parse_args_l11
parse_args_l6:
	mov    eax,[argv]
	mov    edx,DWORD [ebp-0xc]
	add    edx,0x1
	shl    edx,0x2
	add    eax,edx
	mov    eax,DWORD [eax]
	sub    esp,0xc
	push   eax
	call   mystery7
	add    esp,0x10
	mov    DWORD [ebp-0x18],eax
	cmp    DWORD [ebp-0x18],0xffffffff
	jne    parse_args_l15
	sub    esp,0xc
	push   0xfffffffb
	call   do_exit
	add    esp,0x10
parse_args_l15:
	mov    eax,DWORD [ebp-0x18]
	mov    [start_index],eax
	nop
parse_args_l11:
	add    DWORD [ebp-0xc],0x1
parse_args_l3:
	add    DWORD [ebp-0xc],0x1
parse_args_l1:
	mov    eax,[argc]
	cmp    DWORD [ebp-0xc],eax
	jb     parse_args_l2
	mov    eax,DWORD [ebp-0x10]
	mov    [options],eax
	nop
	leave  
	ret    

do_simple_echo:
	push   ebp
	mov    ebp,esp
	sub    esp,0x30
	mov    ecx,0x0
	mov    eax,0x20
	and    eax,0xfffffffc
	mov    edx,eax
	mov    eax,0x0
do_simple_echo_l1:
	mov    DWORD [ebp+eax*1-0x24],ecx
	add    eax,0x4
	cmp    eax,edx
	jb     do_simple_echo_l1
	mov    DWORD [ebp-0x4],0x0
	push   0x20
	lea    eax,[ebp-0x24]
	push   eax
	push   0x0
	call   do_read
	add    esp,0xc
	mov    DWORD [ebp-0x4],eax
	push   0x20
	lea    eax,[ebp-0x24]
	push   eax
	push   0x1
	call   do_write
	add    esp,0xc
	nop
	leave  
	ret    

do_run:
	push   ebp
	mov    ebp,esp
	sub    esp,0x18
	mov    DWORD [ebp-0xc],0x0
	mov    eax,[options]
	and    eax,0x1
	test   eax,eax
	je     do_run_l1
	push   TEXT_MAX_SIZE
	push   text
	push   filename_buffer
	call   read_from_file
	add    esp,0xc
	mov    DWORD [ebp-0xc],eax
	mov    eax,DWORD [ebp-0xc]
	add    eax,text
	mov    BYTE [eax],0x0
	jmp    do_run_l2
do_run_l1:
	push   TEXT_MAX_SIZE
	push   text
	push   0x0
	call   do_read
	add    esp,0xc
	mov    DWORD [ebp-0xc],eax
	mov    eax,DWORD [ebp-0xc]
	add    eax,text
	mov    BYTE [eax],0x0
do_run_l2:
	mov    eax, [options]
	and    eax,0x2
	test   eax,eax
	jne    do_run_l3
	mov    DWORD [start_index],0x0
do_run_l3:
	mov    eax, [options]
	and    eax,0x4
	test   eax,eax
	jne    do_run_l4
	mov    eax,DWORD [ebp-0xc]
	mov    [end_index],eax
do_run_l4:
	mov    eax, [options]
	and    eax,0x8
	test   eax,eax
	je     do_run_l5
	mov    edx, [end_index]
	mov    eax, [start_index]
	push   needle
	push   edx
	push   eax
	push   text
	call   mystery9
	add    esp,0x10
do_run_l5:
	nop
	leave  
	ret    

update_tsc_string:
	push   ebp
	mov    ebp, esp
	push   ebx

	mov    eax, [ebp+8]
	mov    ecx, 8
	mov    ebx, tsc_string
	add    ebx, 1
	add    ecx, ebx


update_tsc_string_l1:
	mov    dl, al
	shl    dl, 4
	shr    dl, 4
	cmp    dl, 9
	jg utsc_l2
	add    dl, '0'
	jmp utsc_l3
utsc_l2:
	sub    dl, 10
	add    dl, 'A'
utsc_l3:
	mov    [ecx], dl
	sub    ecx, 1
	mov    dl, al
	shr    dl, 4
	cmp    dl, 9
	jg utsc_l4
	add    dl, '0'
	jmp utsc_l5
utsc_l4:
	sub    dl, 10
	add    dl, 'A'
utsc_l5:
	mov    [ecx], dl
	sub    ecx, 1
	shr    eax, 8
	cmp    ecx, ebx
	jnz    update_tsc_string_l1	

	pop ebx
	leave
	ret

main:
	push   ebp
	mov    ebp,esp
	sub    esp,0x8

	rdtsc
	push   eax

	mov    eax,DWORD [ebp+8]
	mov    [argc],eax
	mov    eax,[ebp+12]
	mov    [argv],eax
	mov    eax,[argc]
	cmp    eax,0x1
	jne    main_l1
	call   do_simple_echo
	jmp    main_l2
main_l1:
	call   parse_args
	call   do_run
	nop
main_l2:
	rdtsc
	pop    ecx
	sub    eax, ecx
	push   eax
	call   update_tsc_string
	add    esp, 4

	push   tsc_string
	call   print_string
	add    esp, 4

	sub    esp,0xc
	push   0x0
	call   do_exit
	add    esp,0x10
	nop
	leave  
	ret    
	xchg   ax,ax
	xchg   ax,ax
	xchg   ax,ax
	xchg   ax,ax
	xchg   ax,ax

mystery1:
	push   ebp
	mov    ebp,esp
	push   ebx
	mov    edi,DWORD [ebp+0x8]
	xor    eax,eax
	xor    ebx,ebx

mystery1_l1:
	mov    bl,BYTE [edi]
	test   ebx,ebx
	je     mystery1_l2
	inc    edi
	jmp    mystery1_l1

mystery1_l2:
	sub    edi,DWORD [ebp+0x8]
	mov    eax, edi
	pop    ebx
	leave  
	ret    

mystery2:
	push   ebp
	mov    ebp,esp
	mov    edx,DWORD [ebp+0x8]
	xor    eax,eax
	mov    edi,DWORD [ebp+0x8]
	cmp    BYTE [edi], 0x0
	jz     mystery2_l2
	mov    dl,BYTE [ebp+0xc]

mystery2_l1:
	mov    bl,BYTE [edi]
	cmp    bl,dl
	je     mystery2_l4
	inc    edi
	jmp    mystery2_l1

mystery2_l2:
	mov    eax,0xffffffff
	jmp    mystery2_l3

mystery2_l4:
	sub    edi, [ebp+0x8]
	mov    eax, edi

mystery2_l3:
	leave  
	ret    

mystery3:
	push   ebp
	mov    ebp,esp
	mov    ebx,DWORD [ebp+0x8]
	mov    edx,DWORD [ebp+0xc]
	mov    ecx,DWORD [ebp+0x10]

mystery3_l1:
	mov    al,BYTE [ebx]
	mov    ah,BYTE [edx]
	cmp    al,ah
	jne    mystery3_l2
	inc    ebx
	inc    edx
	loop   mystery3_l1
	xor    eax,eax
	jmp    mystery3_l3

mystery3_l2:
	mov    eax,0x1

mystery3_l3:
	leave  
	ret    

mystery4:
	push   ebp
	mov    ebp,esp
	push   ebx
	mov    eax,DWORD [ebp+0x8]
	mov    ebx,DWORD [ebp+0xc]
	mov    ecx,DWORD [ebp+0x10]

mystery4_l1:
	mov    dl,BYTE [ebx]
	mov    BYTE [eax],dl
	inc    eax
	inc    ebx
	loop   mystery4_l1
	pop    ebx
	leave  
	ret    

mystery5:
	push   ebp
	mov    ebp,esp
	mov    eax,DWORD [ebp+0x8]
	cmp    al,0x30
	jl     mystery5_l1
	cmp    al,0x39
	jg     mystery5_l1
	mov    eax,0x1
	jmp    mystery5_l2

mystery5_l1:
	mov    eax,0x0

mystery5_l2:
	leave  
	ret    

mystery6:
	push   ebp
	mov    ebp,esp
	mov    edi,DWORD [ebp+0x8]
	push   edi
	call   mystery1
	add    esp,0x4
	mov    edi,DWORD [ebp+0x8]
	mov    ecx,eax
	sub    esp,eax
	mov    ebx,ebp
	sub    ebx,eax

mystery6_l1:
	mov    dl,BYTE [edi+ecx*1-0x1]
	mov    BYTE [ebx],dl
	inc    ebx
	loop   mystery6_l1
	push   eax
	mov    ebx,ebp
	sub    ebx,eax
	push   ebx
	push   edi
	call   mystery4
	add    esp,0xc
	leave  
	ret    

mystery7:
	push   ebp
	mov    ebp,esp
	xor    edx,edx
	xor    ebx,ebx
	mov    eax,DWORD [ebp+0x8]
	sub    esp,0x4
	mov    DWORD [ebp-0x4],0x0
	push   eax
	call   mystery1
	add    esp,0x4
	mov    ecx,eax
	push   eax
	push   ebx
	push   ecx
	push   edx
	push   edi
	mov    esi,DWORD [ebp+0x8]
	push   esi
	call   mystery6
	add    esp,0x4
	pop    edi
	pop    edx
	pop    ecx
	pop    ebx
	pop    eax

mystery7_l1:
	mov    bl,BYTE [esi+ecx*1-0x1]
	push   ebx
	push   ebx
	call   mystery5
	add    esp,0x4
	cmp    eax,0x0
	je     mystery7_l3
	pop    ebx
	sub    bl,0x30
	push   ebx
	mov    ebx,0xa
	mov    eax,DWORD [ebp-0x4]
	mul    ebx
	pop    ebx
	add    eax,ebx
	mov    DWORD [ebp-0x4],eax
	loop   mystery7_l1
	jmp    mystery7_l2

mystery7_l3:
	mov    eax,0xffffffff
	add    esp,0x4

mystery7_l2:
	leave  
	ret    

mystery8:
	push   ebp
	mov    ebp,esp
	sub    esp,0x10
	mov    ebx, [ebp+0x8]
	mov    ecx, [ebp+0xc]
	mov    eax, [ebp+0xc]
	add    eax, [ebp+0x10]
	mov    [ebp-0x4], eax

mystery8_l1:
	mov    eax, ebx
	mov    al,BYTE [eax]
	cmp    al,0xa
	je     mystery8_l2
	test   al,al
	je     mystery8_l2
	mov    edx, ecx
	mov    dl,BYTE [edx]
	cmp    dl,al
	je     mystery8_l3
	mov    ecx, [ebp+0xc]
	jmp    mystery8_l5

mystery8_l3:
	add    ecx,0x1

mystery8_l4:
	cmp    ecx,DWORD [ebp-0x4]
	jne    mystery8_l5
	mov    eax,0x1
	jmp    mystery8_l6

mystery8_l5:
	add    ebx,0x1
	jmp    mystery8_l1

mystery8_l2:
	mov    eax,0x0

mystery8_l6:
	leave  
	ret    

mystery9:
	push   ebp
	mov    ebp,esp
	sub    esp,0x18
	mov    DWORD [ebp-0xc],0x0
	mov    eax,DWORD [ebp+0xc]
	mov    DWORD [ebp-0x10],eax
	push   DWORD [ebp+0x14]
	call   mystery1
	add    esp,0x4
	mov    DWORD [ebp-0x14],eax
	mov    eax,DWORD [ebp+0xc]
	mov    DWORD [ebp-0xc],eax

mystery9_l1:
	mov    eax,DWORD [ebp-0xc]
	cmp    eax,DWORD [ebp+0x10]
	jae    mystery9_l2
	mov    edx,DWORD [ebp+0x8]
	mov    eax,DWORD [ebp-0xc]
	add    eax,edx
	mov    al,BYTE [eax]
	cmp    al,0xa
	jne    mystery9_l3
	mov    edx,DWORD [ebp+0x8]
	mov    eax,DWORD [ebp-0x10]
	add    eax,edx
	push   DWORD [ebp-0x14]
	push   DWORD [ebp+0x14]
	push   eax
	call   mystery8
	add    esp,0xc
	test   eax,eax
	setne  al
	test   al,al
	je     mystery9_l4
	mov    edx,DWORD [ebp+0x8]
	mov    eax,DWORD [ebp-0x10]
	add    eax,edx
	sub    esp,0xc
	push   eax
	call   print_line
	add    esp,0x10

mystery9_l4:
	mov    eax,DWORD [ebp-0xc]
	add    eax,0x1
	mov    DWORD [ebp-0x10],eax

mystery9_l3:
	add    DWORD [ebp-0xc],0x1
	jmp    mystery9_l1

mystery9_l2:
	leave  
	ret    
