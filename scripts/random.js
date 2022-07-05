const { ethers } = require("hardhat");

 const getHash = (address) => {
    return ethers.utils.keccak256(address);
}

module.exports = {
    getHash
}