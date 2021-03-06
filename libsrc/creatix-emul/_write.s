;; _write.s

        .setcpu "c39-native"
        
        .import         popax, incsp1
        .importzp       ptr1, ptr2, ptr3, tmp1

        .include "c39.inc"

        .import _serial_putc

        .export _write

.proc _write
        sta     ptr3
        sta     ptr3+1          ; save count as result

        eor     #$FF
        sta     ptr2
        txa
        eor     #$FF
        sta     ptr2+1          ; Remember -count-1

        jsr     popax           ; get buf
        sta     ptr1
        stx     ptr1+1
        jsr     popax           ; get fd and discard
L1:     inc     ptr2
        bne     L2
        inc     ptr2+1
        beq     L9
L2:
        ;ldy     #0
        ;lda    (ptr1),y
        ldx     #0
        lda     (ptr1),x
        
        jsr     _serial_putc
        
        inc     ptr1
        bne     L1
        inc     ptr1+1
        jmp     L1

; No error, return count

L9:     lda     ptr3
        ldx     ptr3+1
        rts
.endproc

        
