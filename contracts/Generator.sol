//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

library Generator {

    struct Rand {
        bytes32 seed;
        uint16[] genes;
        uint256 position;
        uint256 index;
    }

    /**
     * @dev Hash the key to get a new seed
     * @param rand Rand struct
     */
    function hashSeed(Rand memory rand) internal pure {
        rand.seed = keccak256(abi.encodePacked(rand.seed));
        rand.position = 0;
    }

    /**
     * @dev Pulls a uint16 [0-65536]
     * @param key Seed of the generator
     * @param genes Mutators of the generator
     */
    function createRand(address key, uint16[] memory genes)
        internal
        pure
        returns (Rand memory rand)
    {
        rand.seed = keccak256(abi.encodePacked(key));
        rand.position = 0;

        rand.genes = genes;
    }

    /**
     * @dev Pulls 2 bytes from seed
     * @param rand Rand struct
     */
    function read16(Rand memory rand)
        internal
        pure
        returns (uint16)
    {
        // bytes memory value;
        uint16 value;

        if (2 + rand.position > rand.seed.length) {
            hashSeed(rand);
        }

        bytes memory seed = abi.encodePacked(rand.seed);
        uint256 position = rand.position;

        assembly {
            value := mload(add(add(seed, 0x2), position))
        }

        unchecked {
            rand.position += 2;
            rand.index += 1;
        }
        return value;
    }

    /**
     * @dev Pulls a byte from seed
     * @param rand Rand struct
     */
    function read8(Rand memory rand) internal pure returns (uint8) {
        uint8 value;

        if (1 + rand.position > rand.seed.length) {
            hashSeed(rand);
        }

        bytes memory seed = abi.encodePacked(rand.seed);
        uint256 position = rand.position;
        // value = uint8(rand.seed[position]);
        assembly {
            value := mload(add(seed, add(0x1, position)))
        }

        unchecked {
            rand.position += 1;
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
        uint16[] memory genes
    ) internal pure returns (uint) {
        unchecked {
            uint length = genes.length;

            uint256 mask = 0;
            for (uint i = 0; i < length; ) {
                if ((index & mask) == mask) {
                    value += genes[i] * max / 256;
                }
                value = (value + 2 * max) % (2 * max);
                if (mask == 0) mask = 1;
                else mask *= 2;
                i++;
            }
            value = max-1-uint(abs(int(max-1-value)));
        }
        return value;
    }

    /**
     * @dev Pulls a uint8 [0-255]
     * @param rand Rand struct
     * @param applyMutation Influence number with genes
     */
    function popUInt8(Rand memory rand, bool applyMutation)
        internal
        pure
        returns (uint8)
    {
        uint8 number = read8(rand);
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
     * @param applyMutation Influence number with genes
     */
    function popUInt16(Rand memory rand, bool applyMutation)
        internal
        pure
        returns (uint16)
    {
        uint16 number = read16(rand);

        return
            applyMutation
                ? uint16(mutate(rand.index - 1, number, 65536, rand.genes))
                : number;
    }

    function popUInt16(Rand memory rand) internal pure returns (uint16) {
        return popUInt16(rand, true);
    }

    /**
     * @dev Pulls an int from min to max
     * @param rand Rand struct
     * @param min Lower bound
     * @param max Upper bound
     * @param applyMutation Influence number with genes
     */
    function popInt(
        Rand memory rand,
        int16 min,
        int16 max,
        bool applyMutation
    ) internal pure returns (int16) {
        int16 number = int16(popUInt16(rand, applyMutation) >> 1);

        return int16(min + ((max + 1 - min) * int(int16(number))) / 32767);
    }

    function popInt(
        Rand memory rand,
        int16 min,
        int16 max
    ) internal pure returns (int16) {
        return popInt(rand, min, max, true);
    }
}
