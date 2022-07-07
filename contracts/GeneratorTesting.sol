//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./Generator.sol";

contract GeneratorTesting {
    using Generator for Generator.Rand;
    using Generator for address;

    function dumpUInt8(address key, uint8[] memory genes, uint256 count) external view returns (uint8[] memory) {
        Generator.Rand memory rand = key.createRand(genes);
        uint8[] memory values = new uint8[](count);

        for (uint i = 0; i < count; i++) {
            values[i] = rand.popUInt8();
        }
        return values;
    }

    function dumpUInt16(address key, uint8[] memory genes, uint256 count) external view returns (uint16[] memory) {
        Generator.Rand memory rand = key.createRand(genes);
        uint16[] memory values = new uint16[](count);

        for (uint i = 0; i < count; i++) {
            values[i] = rand.popUInt16();
        }
        return values;
    }

    function getSeed(address key, uint8[] memory genes) external pure returns (bytes32) {
        return key.createRand(genes).seed;
    }
}       
