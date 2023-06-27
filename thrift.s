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
	call findnl
	nop

exit:
	mov $60, %rax
	xor %rdi, %rdi
	syscall

findnl:
	lea buf, %rbp 
	# start counter for max limit
	mov $0,%rdi    
	mov $5000,%rsi
	lo:
		addq $1,%rbp
		addq $1,%rdi 
		cmp %rsi,%rdi
	    je err
		movb (%rbp), %al
		movb $0x0A,%ah
		cmp %ah,%al
	jne lo

	mov %rbp,%rax
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
