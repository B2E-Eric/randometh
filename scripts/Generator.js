const { ethers } = require("hardhat");

class Generator {
  constructor(address, genes) {
    this.seed = address.substring(2);
    this.genes = genes;
    this.index = 0;

    this.hashSeed();
  }

  hashSeed = () => {
    this.seed = ethers.utils.keccak256("0x" + this.seed).substring(2);
  };

  mutate = (value, max) => {
    const max2 = max * 2 - 1;
    const bound = max * 4;

    let mask = 0;
    this.genes.forEach((gene, i) => {
      if ((this.index & mask) === mask) {
        value += gene;
        value = (max2 - Math.abs((2 * value) % bound - max2)) / 2
      }
      if (mask == 0 ) mask = 1; else mask *= 2;
    });
    return value;
  };
  
  read = byteCount => {
    const fromByte = () => 2 * this.index;
    let toByte = () => fromByte() + 2 * byteCount;
    const max = [256, 65536, 16777216, 4294967296]

    if (toByte() > this.seed.length) {
      this.hashSeed();
      this.index = 0;
    }

    let value = parseInt(this.seed.substring(fromByte(), toByte()), 16);
    value = this.mutate(value, max[byteCount - 1]);

    return value;
  };

  popUInt8 = () => {
    const value = this.read(1);
    this.index += 1;
    return parseInt(value % 256);
  };

  popUInt16 = () => {
    const value = this.read(2);
    this.index += 2;
    return parseInt(value % 65536);
  };
}

module.exports = Generator;
