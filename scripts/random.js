const { ethers } = require("hardhat");

class Generator {
  constructor(address, genes) {
    this.seed = address.substring(2);
    this.genes = genes;
    this.index = 0;

    this.hashSeed();
  }

  hashSeed = () => {
    this.seed = ethers.utils.keccak256('0x' + this.seed).substring(2);
  };

  read = byteCount => {
    const fromByte = () => 2 * this.index;
    let toByte = () => fromByte() + 2 * byteCount;

    if (toByte() > this.seed.length) {
        this.hashSeed();
      this.index = 0;
    }
    return this.seed.substring(fromByte(), toByte());
  };

  popUInt = () => {
    const value = this.read(1);
    this.index += 1;
    return parseInt(value, 16);
  };
}

module.exports = Generator;
