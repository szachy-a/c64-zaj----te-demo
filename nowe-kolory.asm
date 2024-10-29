ldx #$00

// Fill $e000-$ffff with 0
lda #$e0
sta $f8
lda #$00
sta $f7
!loop:
sta ($f7,x)
inc $f7
bne !loop-
inc $f8
bne !loop-

// Draw first version at $c000-$c3ff
.for (var i = $c000; i < $c400; i++) {
    !loop:
    txa
    sta i,x
    sta $0401
    inx
    bne !loop-
}

// Draw second version at $c400-$c7ff
.for (var i = $c400; i < $c800; i++) {
    !loop:
    txa
    lsr
    lsr
    lsr
    lsr
    sta i,x
    sta $0402
    inx
    bne !loop-
}

lda #$00
sta $d018
sta $dd00

lda #$20
ora $d011
sta $d011

sei
lda #$7f
sta $dc0d
and $d011
sta $d011
sta $dc0d
sta $dc0d
lda #$ff
sta $d012
lda #<rasterHandler
sta $0314
lda #>rasterHandler
sta $0315
lda #$01
sta $d01a
cli

!loop:
jmp !loop-

rasterHandler:
pha
inc $d020
bit $d018
beq notSet
lda #$00
jmp afterChange
notSet:
lda #$10
afterChange:
sta $d018
pla
rti