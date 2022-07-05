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

  read = byteCount => {
    const fromByte = () => 2 * this.index;
    let toByte = () => fromByte() + 2 * byteCount;

    if (toByte() > this.seed.length) {
      this.hashSeed();
      this.index = 0;
    }

    let mutateMask = 1;
    let value = parseInt(this.seed.substring(fromByte(), toByte()), 16);
    this.genes.forEach((gene, i) => { 
        if ((this.index & mutateMask) === 1) {
          value = (value + (gene / 2)) % 256;
        }
        mutateMask *= 2
     })
    return parseInt(value);
  };

  popUInt = () => {
    const value = this.read(1);
    this.index += 1;
    return value;
  };
}

module.exports = Generator;
