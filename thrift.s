.section .text
	.global _start

_start:
    # open meminfo
    	mov $2, %rax
	mov $file, %rdi
	mov $0, %rsi
	mov $2, %rdx
	syscall
    
	# read
    	mov %rax, %rdi
	mov $0, %rax
	lea buf, %rsi
    	mov $5000, %rdx
	syscall

	mov %rax,%r11 # for limiting maximum bytes to check in function findnl

	mov $4,%rax
	lea buf,%rbp
	call findnl 		
	
	mov %rax,%rsi
	mov $1, %rax
	mov $1, %rdi
	mov $1, %rdx 
	syscall
	
	call realprint
	
exit:
	mov $60, %rax
	xor %rdi, %rdi
	syscall

findnl: # rax: void* findnl(rax: count,rbx *buffer);
# input rax: count
# out rax: linetop pointer
# rbp: buffer pointer
# ch: \n constant
# cl: current byte
# r11: max buff size
# rdi: buff limit counter
# r10: new line counter

	dec %rax
	mov $0,%r10
	mov $0,%rdi
	lo:
		inc %rbp
		inc %rdi 
		cmp %r11,%rdi
	    	je err
		movb (%rbp), %cl
		movb $0x0A, %ch
		cmp %ch, %cl
	jne lo
	
	# check if we reached requested line count
	inc %r10
	cmp %rax, %r10
	jne lo

	mov %rbp, %rax
	inc %rax
	ret

	err:
		mov $1,%rax
		ret
	nop

realprint: # rax int realprint(rax: *buffer);

	#%rax
	
	ret
	
.section .rodata
file:
	.asciz "/proc/meminfo\0"

.section .bss
buf:
	.space 5000
	nop
