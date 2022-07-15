//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

library Generator {
    struct Rand {
        bytes32 seed;
        uint8[] genes;
        uint256 position;
        uint256 index;
    }

    function hashSeed(Rand memory rand) internal pure {
        rand.seed = keccak256(abi.encodePacked(rand.seed));
        rand.position = 0;
    }

    /**
     * @dev Pulls a uint16 [0-65536]
     * @param key Seed of the generator
     * @param genes Mutators of the generator
     */
    function createRand(address key, uint8[] memory genes)
        internal
        pure
        returns (Rand memory rand)
    {
        rand.seed = keccak256(abi.encodePacked(key));
        rand.position = 0;

        rand.genes = genes;
    }

    /**
     * @dev Pulls a byte from seed
     * @param rand Rand struct
     * @param count number of bytes
     */
    function read(Rand memory rand, uint16 count)
        internal
        pure
        returns (bytes memory)
    {
        bytes memory value = new bytes(count);

        if (count + rand.position > rand.seed.length) {
            hashSeed(rand);
        }

        unchecked {
            for (uint i = 0; i < count; i++) {
                value[i] = rand.seed[i + rand.position];
            }
            rand.position += count;
            rand.index += 1;
        }
        return value;
    }

    function abs(int x) internal pure returns (int) {
        return x >= 0 ? x : -x;
    }

    /**
     * @dev Mutate output according to expressing genes
     * @param index Index of output
     * @param value Value pulled from seed
     * @param max Max of value
     * @param genes Genes
     */
    function mutate(
        uint256 index,
        uint value,
        uint max,
        uint8[] memory genes
    ) internal pure returns (uint) {
        unchecked {
            uint length = genes.length;
            uint max2 = max * 2 - 1;

            uint256 mask = 0;
            for (uint i = 0; i < length; ) {
                if ((index & mask) == mask) {
                    value =
                        (max2 -
                            uint(
                                abs(
                                    int(
                                        (2 * (value + (genes[i] * max) / 256)) %
                                            (max * 4)
                                    ) - int(max2)
                                )
                            )) /
                        2;
                }
                if (mask == 0) mask = 1;
                else mask *= 2;
                i++;
            }
        }
        return value;
    }

    /**
     * @dev Converts byte array into uint
     * @param b array of bytes
     */
    function bytesToUint(bytes memory b) internal pure returns (uint256) {
        uint256 number;
        for (uint i = 0; i < b.length; i++) {
            number =
                number +
                uint(uint8(b[i])) *
                (2**(8 * (b.length - (i + 1))));
        }
        return number;
    }

    /**
     * @dev Pulls a uint8 [0-255]
     * @param rand Rand struct
     */
    function popUInt8(Rand memory rand, bool applyMutation)
        internal
        pure
        returns (uint8)
    {
        uint8 number = uint8(read(rand, 1)[0]);
        return
            applyMutation
                ? uint8(mutate(rand.index - 1, number, 256, rand.genes))
                : number;
    }

    function popUInt8(Rand memory rand) internal pure returns (uint8) {
        return popUInt8(rand, true);
    }

    /**
     * @dev Pulls a uint16 [0-65536]
     * @param rand Rand struct
     */
    function popUInt16(Rand memory rand, bool applyMutation)
        internal
        pure
        returns (uint16)
    {
        uint16 number = uint16(bytesToUint(read(rand, 2)));

        return
            applyMutation
                ? uint16(mutate(rand.index - 1, number, 65536, rand.genes))
                : number;
    }

    function popUInt16(Rand memory rand) internal pure returns (uint16) {
        return popUInt16(rand, true);
    }

    function popInt(Rand memory rand, int16 min, int16 max, bool applyMutation) internal pure returns (int16) {
        uint16 number = uint16(bytesToUint(read(rand, 2)));

        if (applyMutation) number = uint16(mutate(rand.index - 1, number, 65536, rand.genes));
        return int16(min + (max+1 - min) * int(int16(number)) / 65535);
    }

    function popInt(Rand memory rand, int16 min, int16 max) internal pure returns (int16) {
        return popInt(rand, min, max, true);
    }
}
