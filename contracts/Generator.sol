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

    function read(Rand memory rand, uint16 count)
        internal
        pure
        returns (bytes memory)
    {
        bytes memory value = new bytes(count);

        if (count + rand.position > rand.seed.length) {
            rand.seed = keccak256(abi.encodePacked(rand.seed));
            rand.position = 0;
        }

        for (uint i = 0; i < count; i++) {
            value[i] = rand.seed[i + rand.position];
        }
        rand.position += count;
        rand.index += 1;
        return value;
    }

    function getSeed(address key, uint8[] memory genes)
        public
        pure
        returns (bytes32)
    {
        Rand memory rand = createRand(key, genes);

        return (rand.seed);
    }

    function getBytes(
        address key,
        uint8[] memory genes,
        uint16 count
    ) public pure returns (bytes memory) {
        return read(createRand(key, genes), count);
    }

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

    function abs(int x) private pure returns (int) {
        return x >= 0 ? x : -x;
    }

    function mutate(
        uint256 index,
        uint value,
        uint max,
        uint8[] memory genes
    ) internal pure returns (uint) {
        uint length = genes.length;
        uint max2 = max * 2 - 1;
        uint bound = max * 4;

        uint256 mask = 0;
        for (uint i = 0; i < length; i++) {
            if ((index & mask) == mask) {
                value = value + genes[i];
                value = (2 * value) % bound;
                value = uint(abs(int(value) - int(max2)));
                value = (max2 - value) / 2;
            }
            if (mask == 0) mask = 1;
            else mask *= 2;
        }
        return value;
    }

    function popUInt8(Rand memory rand) internal pure returns (uint8) {
        uint8 number = uint8(read(rand, 1)[0]);
        return uint8(mutate(rand.index - 1, number, 256, rand.genes));
    }

    function popUInt16(Rand memory rand) internal pure returns (uint16) {
        uint16 number = uint16(bytesToUint(read(rand, 2)));

        return uint16(mutate(rand.index - 1, number, 65536, rand.genes));
    }

    function dumpUInts(
        address key,
        uint8[] memory genes,
        uint256 count
    ) external view returns (uint8[] memory) {
        Rand memory rand = createRand(key, genes);
        uint8[] memory values = new uint8[](count);

        for (uint i = 0; i < count; i++) {
            values[i] = popUInt8(rand);
        }
        return values;
    }

    function createRand(address key, uint8[] memory genes)
        public
        pure
        returns (Rand memory rand)
    {
        rand.seed = keccak256(abi.encodePacked(key));
        rand.genes = genes;
        rand.position = 0;
    }
}
