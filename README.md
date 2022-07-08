# randometh
Pseudo random generator from an Ethereum address.
This is a seed-based generator, meant to generate assets, not secure gambling.

## Usage
### Solidity
You can use the library in your contract like so:
```solidity
import "./Generator.sol";

contract Algorithm {
    using Generator for Generator.Rand;
    using Generator for address;
}
```
This will allow you to use functions on address and the Rand struct.
To start using the generator, instantiate a rand struct from a key and genes:
```solidity
function generateColor(address key, uint8[] memory genes) public pure {
    Generator.Rand memory rand = key.createRand(genes);
    uint8[] memory rbg = new uint8[](3);

    rgb[0] = rand.popUInt8(); //Generates a uint8 [0-255]
    rgb[1] = rand.popUInt8();
    rgb[2] = rand.popUInt8();
}
```

## How it works
This generator takes a public key and an array of genes (uint16) to generate random numbers.

## Project
This is a Hardhat project.

Install dependencies
```bash
npm install
```
Run unit tests
```bash
npx hardhat test
```

Solidity Generator contract at [./contracts/Generator.sol](/contracts/Generator.sol)

Javascript Generator class at [./scripts/Generator.js](./scripts/Generator.js)