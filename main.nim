import os
import streams
import strutils
import strformat


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

var ram: array[0..65535, uint16]

proc load_file(path: string) =
    var 
        rom = newFileStream(path, fmRead)
        buffer: array[2, uint8]

    doAssert rom.readData(addr(buffer), 2) == 2
    let load_addr: uint16 = (buffer[0] shl 2) or buffer[1]
    
    echo fmt"Loading rom at addr {load_addr}, 0x{load_addr.toHex()}"

    var load_index: uint16 = 0
    while not rom.atEnd():
        doAssert rom.readData(addr(buffer), 2) == 2
        ram[load_addr + load_index] = (buffer[1] shl 2) or buffer[0]
        load_index += 1

    echo fmt"Loaded {(load_index + 1) * 2}"

    rom.close()


if paramCount() == 1:
    load_file(paramStr(1))