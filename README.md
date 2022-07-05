# randometh
Pseudo random generator from an Ethereum address.
This is a seed-based generator, meant to generate assets, not secure gambling.

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
