/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>

#include <kern/picirq.h>


###################################################################
# exceptions/interrupts
###################################################################

/* TRAPHANDLER defines a globally-visible function for handling a trap.
 * It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 *
 * You shouldn't call a TRAPHANDLER function from C, but you may
 * need to _declare_ one in C (for instance, to get a function pointer
 * during IDT setup).  You can declare the function with
 *   void NAME();
 * where NAME is the argument passed to TRAPHANDLER.
 */
#define TRAPHANDLER(name, num)						\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	pushl $(num);							\
	jmp _alltraps

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
#define TRAPHANDLER_NOEC(name, num)					\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
	pushl $0;							\
	pushl $(num);							\
	jmp _alltraps

.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */

TRAPHANDLER_NOEC(T_DIVIDE_handler, T_DIVIDE)
TRAPHANDLER_NOEC(T_DEBUG_handler, T_DEBUG)
TRAPHANDLER_NOEC(T_NMI_handler, T_NMI)
TRAPHANDLER_NOEC(T_BRKPT_handler, T_BRKPT)
TRAPHANDLER_NOEC(T_OFLOW_handler, T_OFLOW)
TRAPHANDLER_NOEC(T_BOUND_handler, T_BOUND)
TRAPHANDLER_NOEC(T_ILLOP_handler, T_ILLOP)
TRAPHANDLER_NOEC(T_DEVICE_handler, T_DEVICE)
TRAPHANDLER(T_DBLFLT_handler, T_DBLFLT)
TRAPHANDLER(T_TSS_handler, T_TSS)
TRAPHANDLER(T_SEGNP_handler, T_SEGNP)
TRAPHANDLER(T_STACK_handler, T_STACK)
TRAPHANDLER(T_GPFLT_handler, T_GPFLT)
TRAPHANDLER(T_PGFLT_handler, T_PGFLT)
TRAPHANDLER_NOEC(T_FPERR_handler, T_FPERR)
TRAPHANDLER(T_ALIGN_handler, T_ALIGN)
TRAPHANDLER_NOEC(T_MCHK_handler, T_MCHK)
TRAPHANDLER_NOEC(T_SIMDERR_handler, T_SIMDERR)

TRAPHANDLER_NOEC(syscall_handler, T_SYSCALL)

TRAPHANDLER_NOEC(IRQ_0_handler,  IRQ_OFFSET + 0);
TRAPHANDLER_NOEC(IRQ_1_handler,  IRQ_OFFSET + 1);
TRAPHANDLER_NOEC(IRQ_2_handler,  IRQ_OFFSET + 2);
TRAPHANDLER_NOEC(IRQ_3_handler,  IRQ_OFFSET + 3);
TRAPHANDLER_NOEC(IRQ_4_handler,  IRQ_OFFSET + 4);
TRAPHANDLER_NOEC(IRQ_5_handler,  IRQ_OFFSET + 5);
TRAPHANDLER_NOEC(IRQ_6_handler,  IRQ_OFFSET + 6);
TRAPHANDLER_NOEC(IRQ_7_handler,  IRQ_OFFSET + 7);
TRAPHANDLER_NOEC(IRQ_8_handler,  IRQ_OFFSET + 8);
TRAPHANDLER_NOEC(IRQ_9_handler,  IRQ_OFFSET + 9);
TRAPHANDLER_NOEC(IRQ_10_handler, IRQ_OFFSET + 10);
TRAPHANDLER_NOEC(IRQ_11_handler, IRQ_OFFSET + 11);
TRAPHANDLER_NOEC(IRQ_12_handler, IRQ_OFFSET + 12);
TRAPHANDLER_NOEC(IRQ_13_handler, IRQ_OFFSET + 13);
TRAPHANDLER_NOEC(IRQ_14_handler, IRQ_OFFSET + 14);
TRAPHANDLER_NOEC(IRQ_15_handler, IRQ_OFFSET + 15);


/*
 * Lab 3: Your code here for _alltraps
 */

_alltraps:
	push %ds
	push %es
	pushal
	mov $GD_KD, %ax
	mov %ax, %ds
	mov %ax, %es
	pushl %esp
	call trap