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

  mutate = value => {
    let mutateMask = 0;
    this.genes.forEach((gene, i) => {
      if ((this.index & mutateMask) === mutateMask) {
        value = value + (gene / 2) % 256;
        value %= 256;
      }
      mutateMask = 2**(i);
    });
    return value;
  };

  read = byteCount => {
    const fromByte = () => 2 * this.index;
    let toByte = () => fromByte() + 2 * byteCount;

    if (toByte() > this.seed.length) {
      this.hashSeed();
      this.index = 0;
    }

    let value = parseInt(this.seed.substring(fromByte(), toByte()), 16);
    value = this.mutate(value);

    return value;
  };

  popUInt8 = () => {
    const value = this.read(1);
    this.index += 1;
    return value;
  };
}

module.exports = Generator;
