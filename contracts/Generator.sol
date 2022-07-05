//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Generator {
    struct Rand {
        bytes32 seed;
        uint16[] genes;
        bytes data;
        uint256 index;
    }

    uint[] internal magic = [128, 32768, 8388608, 2147483648];

    constructor() {}

    function getNumber(uint lgBytes) public pure returns (uint) {
        return lgBytes;
    }

    function bytes32ToString(bytes32 x) public pure returns (string memory) {
        bytes memory bytesString = new bytes(32);
        uint charCount = 0;
        for (uint j = 0; j < 32; j++) {
            bytes1 char = bytes1(bytes32(uint(x) * 2**(8 * j)));
            if (char != 0) {
                bytesString[charCount] = char;
                charCount++;
            }
        }
        bytes memory bytesStringTrimmed = new bytes(charCount);
        for (uint j = 0; j < charCount; j++) {
            bytesStringTrimmed[j] = bytesString[j];
        }
        return string(bytesStringTrimmed);
    }

    function read(
        bytes32 seed,
        uint256 index,
        uint16 count
    ) internal pure returns (bytes memory) {
        bytes memory value = new bytes(count);

        for (uint i = 0; i < count; i++) {
            value[i] = seed[i + index];
        }
        return value;
    }

    function getSeed(address key, uint16[] memory genes)
        public
        pure
        returns (bytes32)
    {
        Rand memory rand = createRand(key, genes);

        return (rand.seed);
    }

    function getFirstBytes(address key, uint16[] memory genes)
        public
        pure
        returns (bytes memory)
    {
        return read(getSeed(key, genes), 0, 1);
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

    function getFirstNumber(address key, uint16[] memory genes)
        public
        pure
        returns (uint256)
    {
        bytes32 seed = getSeed(key, genes);
        bytes memory nb = read(seed, 0, 1);
        uint16 x;

        assembly {
            x := mload(add(nb, 1))
        }

        return (bytesToUint(nb));
    }

    function extract(
        bytes32 seed,
        uint count,
        uint256 index
    ) internal returns (bytes memory) {
        bytes memory extracted = new bytes(count);

        for (uint i = 0; i < count; ) {
            extracted[i] = seed[index + i];
            unchecked {
                ++i;
            }
        }
        return extracted;
    }

    function createRand(address key, uint16[] memory genes)
        public
        pure
        returns (Rand memory)
    {
        Rand memory rand;
        bytes memory seed = abi.encodePacked(key);

        rand.seed = keccak256(seed);
        rand.genes = genes;
        rand.index = 0;
        return rand;
    }
}
