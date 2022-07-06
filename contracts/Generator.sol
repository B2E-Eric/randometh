//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Generator {
    struct Rand {
        bytes32 seed;
        uint8[] genes;
        bytes data;
        uint256 index;
    }

    uint[] internal magic = [128, 32768, 8388608, 2147483648];

    constructor() {}

    function read(
        Rand memory rand,
        uint16 count
    ) internal pure returns (bytes memory) {
        bytes memory value = new bytes(count);

        if (count + rand.index > rand.seed.length) {
            rand.seed = keccak256(abi.encodePacked(rand.seed));
            rand.index = 0;
        }

        for (uint i = 0; i < count; i++) {
            value[i] = rand.seed[i + rand.index];
        }
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

    function getBytes(address key, uint8[] memory genes, uint16 count)
        public
        pure
        returns (bytes memory)
    {
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

    function mutate(uint256 index, uint value, uint8[] memory genes) internal pure returns (uint) {
        uint length = genes.length;

        uint256 mask = 0;
        for (uint i = 0; i < length; i++) {
            if ((index & mask) == mask)
                value = uint8(value + (genes[i] / 2) % 256);
            mask = 2**i;
        }
        return value;
    } 

    function popUInt(Rand memory rand) public pure returns (uint8) {
        uint8 number = uint8(read(rand, 1)[0]);

        rand.index += 1;
        return uint8(mutate(rand.index - 1, number, rand.genes));
    }

    function display3GeneratedUInts(address key, uint8[] memory genes) external view {
        Rand memory rand = createRand(key, genes);

        console.log('sol rnd:');
        console.log('1:', popUInt(rand));
        console.log('2:', popUInt(rand));
        console.log('3:', popUInt(rand));
        console.log('4:', popUInt(rand));
        console.log('5:', popUInt(rand));
    }

    function dumpUInts(address key, uint8[] memory genes, uint256 count) external view returns (uint8[] memory) {
        Rand memory rand = createRand(key, genes);
        uint8[] memory values = new uint8[](count);

        for (uint i = 0; i < count; i++) {
            values[i] = popUInt(rand);
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
        rand.index = 0;
    }
}
