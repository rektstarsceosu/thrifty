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
	
	# return rax: void* findl(rax: ln_no, rbp: *buffer);
	mov $4,%rax
	lea buf,%rbp
	call findnl 		
	
	mov %rax,%rsi
	mov $1, %rax
	mov $1, %rdi
	mov $1, %rdx 
	syscall

exit:
	mov $60, %rax
	xor %rdi, %rdi
	syscall

findnl:
# rbp: buffer*
# input rax & r9: line no 
# rax->ah: \n constant
# rax->al: current byte
# rsi: buff size
# rdi: buff counter
# r10: new line counter

	dec %rax
	mov $0,%r10 #count nls found
	mov %rax,%r9
	# start counter for max limit
	mov $0,%rdi    
	mov $5000,%rsi
	lo:
		inc %rbp
		inc %rdi 
		cmp %rsi,%rdi
	    	je err
		movb (%rbp), %al
		movb $0x0A,%ah
		cmp %ah,%al
	jne lo

	addq $1,%r10
	cmp %r9,%r10
	jne lo
	mov %rbp,%rax
	inc %rax
	ret

	err:
		mov $1,%rax
		ret
	nop

.section .rodata
file:
	.asciz "/proc/meminfo\0"

.section .bss
buf:
	.space 5000
	nop
