//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./Generator.sol";

contract GeneratorTesting {
    using Generator for Generator.Rand;
    using Generator for address;

    uint8 number;

    function dumpUInt8(address key, uint16[] memory genes, uint256 count) external pure returns (uint8[] memory) {
        Generator.Rand memory rand = key.createRand(genes);
        uint8[] memory values = new uint8[](count);

        for (uint i = 0; i < count; i++) {
            values[i] = rand.popUInt8();
        }
        return values;
    }

    function dumpUInt16(address key, uint16[] memory genes, uint256 count) external pure returns (uint16[] memory) {
        Generator.Rand memory rand = key.createRand(genes);
        uint16[] memory values = new uint16[](count);

        for (uint i = 0; i < count; i++) {
            values[i] = rand.popUInt16();
        }
        return values;
    }

    function dumpInt(address key, uint16[] memory genes, int16 min, int16 max, uint256 count) external pure returns (int16[] memory) {
        Generator.Rand memory rand = key.createRand(genes);
        int16[] memory values = new int16[](count);

        for (uint i = 0; i < count; i++) {
            values[i] = rand.popInt(min, max, false);
        }
        return values;
    }

    function dumpSeeds(address key, uint16[] memory genes, uint256 count) external pure returns (bytes32[] memory) {
        Generator.Rand memory rand = key.createRand(genes);
        bytes32[] memory values = new bytes32[](count);

        for (uint i = 0; i < count; i++) {
            values[i] = rand.seed;
            rand.hashSeed();
        }
        return values;
    }

    function storeUInt8(address key, uint16[] memory genes) external {
        Generator.Rand memory rand = key.createRand(genes);
        number = rand.popUInt8();
    }
}       
