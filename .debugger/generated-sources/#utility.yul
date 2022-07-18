{

    // uint8[]
    function abi_decode_available_length_t_array$_t_uint8_$dyn_memory_ptr(offset, length, end) -> array {
        array := allocate_memory(array_allocation_size_t_array$_t_uint8_$dyn_memory_ptr(length))
        let dst := array

        mstore(array, length)
        dst := add(array, 0x20)

        let src := offset
        if gt(add(src, mul(length, 0x20)), end) {
            revert_error_81385d8c0b31fffe14be1da910c8bd3a80be4cfa248e04f42ec0faea3132a8ef()
        }
        for { let i := 0 } lt(i, length) { i := add(i, 1) }
        {

            let elementPos := src

            mstore(dst, abi_decode_t_uint8(elementPos, end))
            dst := add(dst, 0x20)
            src := add(src, 0x20)
        }
    }

    function abi_decode_t_address(offset, end) -> value {
        value := calldataload(offset)
        validator_revert_t_address(value)
    }

    // uint8[]
    function abi_decode_t_array$_t_uint8_$dyn_memory_ptr(offset, end) -> array {
        if iszero(slt(add(offset, 0x1f), end)) { revert_error_1b9f4a0a5773e33b91aa01db23bf8c55fce1411167c872835e7fa00a4f17d46d() }
        let length := calldataload(offset)
        array := abi_decode_available_length_t_array$_t_uint8_$dyn_memory_ptr(add(offset, 0x20), length, end)
    }

    function abi_decode_t_int16(offset, end) -> value {
        value := calldataload(offset)
        validator_revert_t_int16(value)
    }

    function abi_decode_t_uint256(offset, end) -> value {
        value := calldataload(offset)
        validator_revert_t_uint256(value)
    }

    function abi_decode_t_uint8(offset, end) -> value {
        value := calldataload(offset)
        validator_revert_t_uint8(value)
    }

    function abi_decode_tuple_t_addresst_array$_t_uint8_$dyn_memory_ptr(headStart, dataEnd) -> value0, value1 {
        if slt(sub(dataEnd, headStart), 64) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

        {

            let offset := 0

            value0 := abi_decode_t_address(add(headStart, offset), dataEnd)
        }

        {

            let offset := calldataload(add(headStart, 32))
            if gt(offset, 0xffffffffffffffff) { revert_error_c1322bf8034eace5e0b5c7295db60986aa89aae5e0ea0873e4689e076861a5db() }

            value1 := abi_decode_t_array$_t_uint8_$dyn_memory_ptr(add(headStart, offset), dataEnd)
        }

    }

    function abi_decode_tuple_t_addresst_array$_t_uint8_$dyn_memory_ptrt_int16t_int16t_uint256(headStart, dataEnd) -> value0, value1, value2, value3, value4 {
        if slt(sub(dataEnd, headStart), 160) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

        {

            let offset := 0

            value0 := abi_decode_t_address(add(headStart, offset), dataEnd)
        }

        {

            let offset := calldataload(add(headStart, 32))
            if gt(offset, 0xffffffffffffffff) { revert_error_c1322bf8034eace5e0b5c7295db60986aa89aae5e0ea0873e4689e076861a5db() }

            value1 := abi_decode_t_array$_t_uint8_$dyn_memory_ptr(add(headStart, offset), dataEnd)
        }

        {

            let offset := 64

            value2 := abi_decode_t_int16(add(headStart, offset), dataEnd)
        }

        {

            let offset := 96

            value3 := abi_decode_t_int16(add(headStart, offset), dataEnd)
        }

        {

            let offset := 128

            value4 := abi_decode_t_uint256(add(headStart, offset), dataEnd)
        }

    }

    function abi_decode_tuple_t_addresst_array$_t_uint8_$dyn_memory_ptrt_uint256(headStart, dataEnd) -> value0, value1, value2 {
        if slt(sub(dataEnd, headStart), 96) { revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() }

        {

            let offset := 0

            value0 := abi_decode_t_address(add(headStart, offset), dataEnd)
        }

        {

            let offset := calldataload(add(headStart, 32))
            if gt(offset, 0xffffffffffffffff) { revert_error_c1322bf8034eace5e0b5c7295db60986aa89aae5e0ea0873e4689e076861a5db() }

            value1 := abi_decode_t_array$_t_uint8_$dyn_memory_ptr(add(headStart, offset), dataEnd)
        }

        {

            let offset := 64

            value2 := abi_decode_t_uint256(add(headStart, offset), dataEnd)
        }

    }

    function abi_encodeUpdatedPos_t_bytes32_to_t_bytes32(value0, pos) -> updatedPos {
        abi_encode_t_bytes32_to_t_bytes32(value0, pos)
        updatedPos := add(pos, 0x20)
    }

    function abi_encodeUpdatedPos_t_int16_to_t_int16(value0, pos) -> updatedPos {
        abi_encode_t_int16_to_t_int16(value0, pos)
        updatedPos := add(pos, 0x20)
    }

    function abi_encodeUpdatedPos_t_uint16_to_t_uint16(value0, pos) -> updatedPos {
        abi_encode_t_uint16_to_t_uint16(value0, pos)
        updatedPos := add(pos, 0x20)
    }

    function abi_encodeUpdatedPos_t_uint8_to_t_uint8(value0, pos) -> updatedPos {
        abi_encode_t_uint8_to_t_uint8(value0, pos)
        updatedPos := add(pos, 0x20)
    }

    function abi_encode_t_address_to_t_address_nonPadded_inplace_fromStack(value, pos) {
        mstore(pos, leftAlign_t_address(cleanup_t_address(value)))
    }

    // bytes32[] -> bytes32[]
    function abi_encode_t_array$_t_bytes32_$dyn_memory_ptr_to_t_array$_t_bytes32_$dyn_memory_ptr_fromStack(value, pos)  -> end  {
        let length := array_length_t_array$_t_bytes32_$dyn_memory_ptr(value)
        pos := array_storeLengthForEncoding_t_array$_t_bytes32_$dyn_memory_ptr_fromStack(pos, length)
        let baseRef := array_dataslot_t_array$_t_bytes32_$dyn_memory_ptr(value)
        let srcPtr := baseRef
        for { let i := 0 } lt(i, length) { i := add(i, 1) }
        {
            let elementValue0 := mload(srcPtr)
            pos := abi_encodeUpdatedPos_t_bytes32_to_t_bytes32(elementValue0, pos)
            srcPtr := array_nextElement_t_array$_t_bytes32_$dyn_memory_ptr(srcPtr)
        }
        end := pos
    }

    // int16[] -> int16[]
    function abi_encode_t_array$_t_int16_$dyn_memory_ptr_to_t_array$_t_int16_$dyn_memory_ptr_fromStack(value, pos)  -> end  {
        let length := array_length_t_array$_t_int16_$dyn_memory_ptr(value)
        pos := array_storeLengthForEncoding_t_array$_t_int16_$dyn_memory_ptr_fromStack(pos, length)
        let baseRef := array_dataslot_t_array$_t_int16_$dyn_memory_ptr(value)
        let srcPtr := baseRef
        for { let i := 0 } lt(i, length) { i := add(i, 1) }
        {
            let elementValue0 := mload(srcPtr)
            pos := abi_encodeUpdatedPos_t_int16_to_t_int16(elementValue0, pos)
            srcPtr := array_nextElement_t_array$_t_int16_$dyn_memory_ptr(srcPtr)
        }
        end := pos
    }

    // uint16[] -> uint16[]
    function abi_encode_t_array$_t_uint16_$dyn_memory_ptr_to_t_array$_t_uint16_$dyn_memory_ptr_fromStack(value, pos)  -> end  {
        let length := array_length_t_array$_t_uint16_$dyn_memory_ptr(value)
        pos := array_storeLengthForEncoding_t_array$_t_uint16_$dyn_memory_ptr_fromStack(pos, length)
        let baseRef := array_dataslot_t_array$_t_uint16_$dyn_memory_ptr(value)
        let srcPtr := baseRef
        for { let i := 0 } lt(i, length) { i := add(i, 1) }
        {
            let elementValue0 := mload(srcPtr)
            pos := abi_encodeUpdatedPos_t_uint16_to_t_uint16(elementValue0, pos)
            srcPtr := array_nextElement_t_array$_t_uint16_$dyn_memory_ptr(srcPtr)
        }
        end := pos
    }

    // uint8[] -> uint8[]
    function abi_encode_t_array$_t_uint8_$dyn_memory_ptr_to_t_array$_t_uint8_$dyn_memory_ptr_fromStack(value, pos)  -> end  {
        let length := array_length_t_array$_t_uint8_$dyn_memory_ptr(value)
        pos := array_storeLengthForEncoding_t_array$_t_uint8_$dyn_memory_ptr_fromStack(pos, length)
        let baseRef := array_dataslot_t_array$_t_uint8_$dyn_memory_ptr(value)
        let srcPtr := baseRef
        for { let i := 0 } lt(i, length) { i := add(i, 1) }
        {
            let elementValue0 := mload(srcPtr)
            pos := abi_encodeUpdatedPos_t_uint8_to_t_uint8(elementValue0, pos)
            srcPtr := array_nextElement_t_array$_t_uint8_$dyn_memory_ptr(srcPtr)
        }
        end := pos
    }

    function abi_encode_t_bytes32_to_t_bytes32(value, pos) {
        mstore(pos, cleanup_t_bytes32(value))
    }

    function abi_encode_t_bytes32_to_t_bytes32_nonPadded_inplace_fromStack(value, pos) {
        mstore(pos, leftAlign_t_bytes32(cleanup_t_bytes32(value)))
    }

    function abi_encode_t_int16_to_t_int16(value, pos) {
        mstore(pos, cleanup_t_int16(value))
    }

    function abi_encode_t_uint16_to_t_uint16(value, pos) {
        mstore(pos, cleanup_t_uint16(value))
    }

    function abi_encode_t_uint8_to_t_uint8(value, pos) {
        mstore(pos, cleanup_t_uint8(value))
    }

    function abi_encode_tuple_packed_t_address__to_t_address__nonPadded_inplace_fromStack_reversed(pos , value0) -> end {

        abi_encode_t_address_to_t_address_nonPadded_inplace_fromStack(value0,  pos)
        pos := add(pos, 20)

        end := pos
    }

    function abi_encode_tuple_packed_t_bytes32__to_t_bytes32__nonPadded_inplace_fromStack_reversed(pos , value0) -> end {

        abi_encode_t_bytes32_to_t_bytes32_nonPadded_inplace_fromStack(value0,  pos)
        pos := add(pos, 32)

        end := pos
    }

    function abi_encode_tuple_t_array$_t_bytes32_$dyn_memory_ptr__to_t_array$_t_bytes32_$dyn_memory_ptr__fromStack_reversed(headStart , value0) -> tail {
        tail := add(headStart, 32)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_array$_t_bytes32_$dyn_memory_ptr_to_t_array$_t_bytes32_$dyn_memory_ptr_fromStack(value0,  tail)

    }

    function abi_encode_tuple_t_array$_t_int16_$dyn_memory_ptr__to_t_array$_t_int16_$dyn_memory_ptr__fromStack_reversed(headStart , value0) -> tail {
        tail := add(headStart, 32)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_array$_t_int16_$dyn_memory_ptr_to_t_array$_t_int16_$dyn_memory_ptr_fromStack(value0,  tail)

    }

    function abi_encode_tuple_t_array$_t_uint16_$dyn_memory_ptr__to_t_array$_t_uint16_$dyn_memory_ptr__fromStack_reversed(headStart , value0) -> tail {
        tail := add(headStart, 32)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_array$_t_uint16_$dyn_memory_ptr_to_t_array$_t_uint16_$dyn_memory_ptr_fromStack(value0,  tail)

    }

    function abi_encode_tuple_t_array$_t_uint8_$dyn_memory_ptr__to_t_array$_t_uint8_$dyn_memory_ptr__fromStack_reversed(headStart , value0) -> tail {
        tail := add(headStart, 32)

        mstore(add(headStart, 0), sub(tail, headStart))
        tail := abi_encode_t_array$_t_uint8_$dyn_memory_ptr_to_t_array$_t_uint8_$dyn_memory_ptr_fromStack(value0,  tail)

    }

    function allocate_memory(size) -> memPtr {
        memPtr := allocate_unbounded()
        finalize_allocation(memPtr, size)
    }

    function allocate_unbounded() -> memPtr {
        memPtr := mload(64)
    }

    function array_allocation_size_t_array$_t_uint8_$dyn_memory_ptr(length) -> size {
        // Make sure we can allocate memory without overflow
        if gt(length, 0xffffffffffffffff) { panic_error_0x41() }

        size := mul(length, 0x20)

        // add length slot
        size := add(size, 0x20)

    }

    function array_dataslot_t_array$_t_bytes32_$dyn_memory_ptr(ptr) -> data {
        data := ptr

        data := add(ptr, 0x20)

    }

    function array_dataslot_t_array$_t_int16_$dyn_memory_ptr(ptr) -> data {
        data := ptr

        data := add(ptr, 0x20)

    }

    function array_dataslot_t_array$_t_uint16_$dyn_memory_ptr(ptr) -> data {
        data := ptr

        data := add(ptr, 0x20)

    }

    function array_dataslot_t_array$_t_uint8_$dyn_memory_ptr(ptr) -> data {
        data := ptr

        data := add(ptr, 0x20)

    }

    function array_length_t_array$_t_bytes32_$dyn_memory_ptr(value) -> length {

        length := mload(value)

    }

    function array_length_t_array$_t_int16_$dyn_memory_ptr(value) -> length {

        length := mload(value)

    }

    function array_length_t_array$_t_uint16_$dyn_memory_ptr(value) -> length {

        length := mload(value)

    }

    function array_length_t_array$_t_uint8_$dyn_memory_ptr(value) -> length {

        length := mload(value)

    }

    function array_nextElement_t_array$_t_bytes32_$dyn_memory_ptr(ptr) -> next {
        next := add(ptr, 0x20)
    }

    function array_nextElement_t_array$_t_int16_$dyn_memory_ptr(ptr) -> next {
        next := add(ptr, 0x20)
    }

    function array_nextElement_t_array$_t_uint16_$dyn_memory_ptr(ptr) -> next {
        next := add(ptr, 0x20)
    }

    function array_nextElement_t_array$_t_uint8_$dyn_memory_ptr(ptr) -> next {
        next := add(ptr, 0x20)
    }

    function array_storeLengthForEncoding_t_array$_t_bytes32_$dyn_memory_ptr_fromStack(pos, length) -> updated_pos {
        mstore(pos, length)
        updated_pos := add(pos, 0x20)
    }

    function array_storeLengthForEncoding_t_array$_t_int16_$dyn_memory_ptr_fromStack(pos, length) -> updated_pos {
        mstore(pos, length)
        updated_pos := add(pos, 0x20)
    }

    function array_storeLengthForEncoding_t_array$_t_uint16_$dyn_memory_ptr_fromStack(pos, length) -> updated_pos {
        mstore(pos, length)
        updated_pos := add(pos, 0x20)
    }

    function array_storeLengthForEncoding_t_array$_t_uint8_$dyn_memory_ptr_fromStack(pos, length) -> updated_pos {
        mstore(pos, length)
        updated_pos := add(pos, 0x20)
    }

    function checked_add_t_int16(x, y) -> sum {
        x := cleanup_t_int16(x)
        y := cleanup_t_int16(y)

        // overflow, if x >= 0 and y > (maxValue - x)
        if and(iszero(slt(x, 0)), sgt(y, sub(0x7fff, x))) { panic_error_0x11() }
        // underflow, if x < 0 and y < (minValue - x)
        if and(slt(x, 0), slt(y, sub(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8000, x))) { panic_error_0x11() }

        sum := add(x, y)
    }

    function checked_add_t_int256(x, y) -> sum {
        x := cleanup_t_int256(x)
        y := cleanup_t_int256(y)

        // overflow, if x >= 0 and y > (maxValue - x)
        if and(iszero(slt(x, 0)), sgt(y, sub(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, x))) { panic_error_0x11() }
        // underflow, if x < 0 and y < (minValue - x)
        if and(slt(x, 0), slt(y, sub(0x8000000000000000000000000000000000000000000000000000000000000000, x))) { panic_error_0x11() }

        sum := add(x, y)
    }

    function checked_add_t_uint256(x, y) -> sum {
        x := cleanup_t_uint256(x)
        y := cleanup_t_uint256(y)

        // overflow, if x > (maxValue - y)
        if gt(x, sub(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, y)) { panic_error_0x11() }

        sum := add(x, y)
    }

    function checked_div_t_int256(x, y) -> r {
        x := cleanup_t_int256(x)
        y := cleanup_t_int256(y)
        if iszero(y) { panic_error_0x12() }

        // overflow for minVal / -1
        if and(
            eq(x, 0x8000000000000000000000000000000000000000000000000000000000000000),
            eq(y, sub(0, 1))
        ) { panic_error_0x11() }

        r := sdiv(x, y)
    }

    function checked_mul_t_int256(x, y) -> product {
        x := cleanup_t_int256(x)
        y := cleanup_t_int256(y)

        // overflow, if x > 0, y > 0 and x > (maxValue / y)
        if and(and(sgt(x, 0), sgt(y, 0)), gt(x, div(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, y))) { panic_error_0x11() }
        // underflow, if x > 0, y < 0 and y < (minValue / x)
        if and(and(sgt(x, 0), slt(y, 0)), slt(y, sdiv(0x8000000000000000000000000000000000000000000000000000000000000000, x))) { panic_error_0x11() }
        // underflow, if x < 0, y > 0 and x < (minValue / y)
        if and(and(slt(x, 0), sgt(y, 0)), slt(x, sdiv(0x8000000000000000000000000000000000000000000000000000000000000000, y))) { panic_error_0x11() }
        // overflow, if x < 0, y < 0 and x < (maxValue / y)
        if and(and(slt(x, 0), slt(y, 0)), slt(x, sdiv(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, y))) { panic_error_0x11() }

        product := mul(x, y)
    }

    function checked_sub_t_int16(x, y) -> diff {
        x := cleanup_t_int16(x)
        y := cleanup_t_int16(y)

        // underflow, if y >= 0 and x < (minValue + y)
        if and(iszero(slt(y, 0)), slt(x, add(0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8000, y))) { panic_error_0x11() }
        // overflow, if y < 0 and x > (maxValue + y)
        if and(slt(y, 0), sgt(x, add(0x7fff, y))) { panic_error_0x11() }

        diff := sub(x, y)
    }

    function checked_sub_t_uint256(x, y) -> diff {
        x := cleanup_t_uint256(x)
        y := cleanup_t_uint256(y)

        if lt(x, y) { panic_error_0x11() }

        diff := sub(x, y)
    }

    function cleanup_t_address(value) -> cleaned {
        cleaned := cleanup_t_uint160(value)
    }

    function cleanup_t_bytes32(value) -> cleaned {
        cleaned := value
    }

    function cleanup_t_int16(value) -> cleaned {
        cleaned := signextend(1, value)
    }

    function cleanup_t_int256(value) -> cleaned {
        cleaned := value
    }

    function cleanup_t_uint16(value) -> cleaned {
        cleaned := and(value, 0xffff)
    }

    function cleanup_t_uint160(value) -> cleaned {
        cleaned := and(value, 0xffffffffffffffffffffffffffffffffffffffff)
    }

    function cleanup_t_uint256(value) -> cleaned {
        cleaned := value
    }

    function cleanup_t_uint8(value) -> cleaned {
        cleaned := and(value, 0xff)
    }

    function finalize_allocation(memPtr, size) {
        let newFreePtr := add(memPtr, round_up_to_mul_of_32(size))
        // protect against overflow
        if or(gt(newFreePtr, 0xffffffffffffffff), lt(newFreePtr, memPtr)) { panic_error_0x41() }
        mstore(64, newFreePtr)
    }

    function increment_t_uint256(value) -> ret {
        value := cleanup_t_uint256(value)
        if eq(value, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff) { panic_error_0x11() }
        ret := add(value, 1)
    }

    function leftAlign_t_address(value) -> aligned {
        aligned := leftAlign_t_uint160(value)
    }

    function leftAlign_t_bytes32(value) -> aligned {
        aligned := value
    }

    function leftAlign_t_uint160(value) -> aligned {
        aligned := shift_left_96(value)
    }

    function negate_t_int256(value) -> ret {
        value := cleanup_t_int256(value)
        if eq(value, 0x8000000000000000000000000000000000000000000000000000000000000000) { panic_error_0x11() }
        ret := sub(0, value)
    }

    function panic_error_0x11() {
        mstore(0, 35408467139433450592217433187231851964531694900788300625387963629091585785856)
        mstore(4, 0x11)
        revert(0, 0x24)
    }

    function panic_error_0x12() {
        mstore(0, 35408467139433450592217433187231851964531694900788300625387963629091585785856)
        mstore(4, 0x12)
        revert(0, 0x24)
    }

    function panic_error_0x32() {
        mstore(0, 35408467139433450592217433187231851964531694900788300625387963629091585785856)
        mstore(4, 0x32)
        revert(0, 0x24)
    }

    function panic_error_0x41() {
        mstore(0, 35408467139433450592217433187231851964531694900788300625387963629091585785856)
        mstore(4, 0x41)
        revert(0, 0x24)
    }

    function revert_error_1b9f4a0a5773e33b91aa01db23bf8c55fce1411167c872835e7fa00a4f17d46d() {
        revert(0, 0)
    }

    function revert_error_81385d8c0b31fffe14be1da910c8bd3a80be4cfa248e04f42ec0faea3132a8ef() {
        revert(0, 0)
    }

    function revert_error_c1322bf8034eace5e0b5c7295db60986aa89aae5e0ea0873e4689e076861a5db() {
        revert(0, 0)
    }

    function revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b() {
        revert(0, 0)
    }

    function round_up_to_mul_of_32(value) -> result {
        result := and(add(value, 31), not(31))
    }

    function shift_left_96(value) -> newValue {
        newValue :=

        shl(96, value)

    }

    function validator_revert_t_address(value) {
        if iszero(eq(value, cleanup_t_address(value))) { revert(0, 0) }
    }

    function validator_revert_t_int16(value) {
        if iszero(eq(value, cleanup_t_int16(value))) { revert(0, 0) }
    }

    function validator_revert_t_uint256(value) {
        if iszero(eq(value, cleanup_t_uint256(value))) { revert(0, 0) }
    }

    function validator_revert_t_uint8(value) {
        if iszero(eq(value, cleanup_t_uint8(value))) { revert(0, 0) }
    }

}
