import os
import streams
import strutils

type
    Register = enum
        r0, r1, r2, r3, r4, r5, r6, r7,
        pc, cond, count

type
    Operations = enum
        branch,
        add,
        load,
        store,
        jump_reg,
        bitw_and,
        load_reg,
        store_reg,
        unused,
        bitw_not,
        load_ind,
        store_ind,
        jump,
        reserved,
        load_eff,
        trap


var regs: array[Register.count, uint16]

var ram: array[0..65535, uint8]


proc toggle_endianess(num: uint16): uint16 =
    var
        left_byte, right_byte: uint16

    left_byte = (num and 0x00ff) shl 2
    right_byte = (num and 0xff00) shr 2

    return left_byte + right_byte


proc load_file(path: string) =
    var rom = newFileStream(path, fmRead)
    var load_addr = rom.readUint16()
    
    echo "0x" & toggle_endianess(load_addr).toHex()

    rom.close()


if paramCount() == 1:
    load_file(paramStr(1))