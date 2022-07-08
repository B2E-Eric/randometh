//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./Generator.sol";

contract Creature {
    using Generator for Generator.Rand;
    using Generator for address;

    function probability(uint8 data, uint8 percentile)
        internal
        pure
        returns (bool)
    {
        return data < (256 * percentile) / 100;
    }

    function generateTrait(address key, uint8[] memory genes) public view {
        Generator.Rand memory rand = key.createRand(genes);

        for (uint i = 0; i < 10; i++) {
            string memory posture = probability(rand.popUInt8(), 20)
                ? (probability(rand.popUInt8(), 50) ? "Shy" : "Brave")
                : "Normal";
            console.log("posture", posture);
        }
    }

    function jsonString(string memory name, string memory value)
        internal
        pure
        returns (string memory)
    {
        return string(abi.encodePacked('"', name, '":"', value, '"'));
    }

    function jsonObject(string memory name, string memory value) internal pure returns (string memory) {
        return string(abi.encodePacked('{"', name, '":"', value, '"}'));
    }

    function tokenURI(address key, uint8[] memory genes)
        public
        view
        returns (string memory)
    {
        Generator.Rand memory rand = key.createRand(genes);
        string memory temper = probability(rand.popUInt8(), 20)
            ? (probability(rand.popUInt8(), 50) ? "Shy" : "Brave")
            : "Normal";
        string memory posture = probability(rand.popUInt8(), 20)
            ? (probability(rand.popUInt8(), 50) ? "Strict" : "Charmed")
            : "Normal";
        string memory mood = probability(rand.popUInt8(), 20)
            ? (probability(rand.popUInt8(), 50) ? "Upbeat" : "Gloomy")
            : "Normal";
        string memory direction = probability(rand.popUInt8(), 20)
            ? (probability(rand.popUInt8(), 50) ? "Onward" : "Backward")
            : "Normal";

        return (
            string(
                abi.encodePacked(
                    "data:application/json;",
                    string(
                        abi.encodePacked(
                            "{",
                            jsonString("name", "Creature"),
                            ",",
                            jsonString("description", "A bioshape"),
                            ",",
                            '"attributes":[',
                            '{',jsonString("value", temper),',','"trait_type":"Temper"','}',
                            ",",
                            '{',jsonString("value", posture),',','"trait_type":"Posture"','}',
                            ",",
                            '{',jsonString("value", mood),',','"trait_type":"Mood"','}',
                            ",",
                            '{',jsonString("value", direction),',','"trait_type":"Direction"','}',

                            "]}"
                        )
                    )
                )
            )
        );
    }
}
