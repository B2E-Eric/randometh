//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./Generator.sol";

contract Algorithm {
    using Generator for Generator.Rand;
    using Generator for address;

    function generateColor(address key, uint8[] memory genes) external view returns (uint8[] memory) {
        Generator.Rand memory rand = key.createRand(genes);
        uint8[] memory rgb = new uint8[](3);

        rgb[0] = rand.popUInt8();
        rgb[1] = rand.popUInt8();
        rgb[2] = rand.popUInt8();
        return rgb;
    }

    function generateUInt16(address key, uint8[] memory genes, uint256 count) external pure returns (uint16[] memory) {
        Generator.Rand memory rand = key.createRand(genes);
        uint16[] memory values = new uint16[](count);

        for (uint i = 0; i < count; i ++) {
            values[i] = rand.popUInt16();
        }
        return values;
    }
}
