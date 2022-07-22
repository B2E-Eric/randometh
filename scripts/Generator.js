const { ethers } = require("hardhat");

class Generator {
  constructor(address, genes) {
    //Seed which we pull bytes out of
    this.seed = address.substring(2);
    this.hashSeed();

    //Array of uint8 to influence output
    this.genes = genes;

    //index of current output
    this.index = 0;

    //index of current byte in seed
    this.position = 0;
  }

  //Hashes the seed again to refresh byte values
  hashSeed = () => {
    this.seed = ethers.utils.keccak256("0x" + this.seed).substring(2);
  };

  //Changes value according to which genes express themselves on index
  mutate = (value, max) => {
    const max2 = max * 2 - 1;
    const bound = max * 4;

    let mask = 0;
    this.genes.forEach((gene, i) => {
      if (((this.index - 1) & mask) === mask) {
        value += gene * max / 256;
        value = (max2 - Math.abs(2 * value % bound - max2)) / 2;
      }
      if (mask == 0) mask = 1;
      else mask *= 2;
    });
    return value;
  };

  //Pulls a byte from seed
  read = byteCount => {
    const fromByte = () => 2 * this.position;
    let toByte = () => fromByte() + 2 * byteCount;

    if (toByte() > this.seed.length) {
      this.hashSeed();
      this.position = 0;
    }

    let value = parseInt(this.seed.substring(fromByte(), toByte()), 16);
    this.index += 1;
    this.position += byteCount;

    return value;
  };

  //Pull a uint8 [0-255]
  popUInt8 = (applyMutation = true) => {
    let value = this.read(1);
    if (applyMutation) value = this.mutate(value, 256);
    return parseInt(value % 256);
  };

  //Pull a uint16 [0-65536]
  popUInt16 = (applyMutation = true) => {
    let value = this.read(2);
    if (applyMutation) value = this.mutate(value, 65536);
    return parseInt(value % 65536);
  };

  popInt = (min, max, applyMutation = true) => {
    let value = this.read(2);

    if (applyMutation) value = this.mutate(value, 65536);
    value = min + (max + 1 - min) * (value >> 1) / 32767;
    return Math.floor(value);
  };
}

module.exports = Generator;
