const { expect } = require("chai");
const { ethers } = require("hardhat");
const chalk = require("chalk");
const Generator = require("../scripts/Generator");

const zeros = n => Array(n).fill("0");
const digits = (n, value) => [...zeros(n - value.length), value].join("");

describe("Generators pair testing", function() {
  let gInstance;
  let instance;

  beforeEach(async () => {
    const contract = await ethers.getContractFactory("Generator");
    gInstance = await contract.deploy();
    const testContract = await ethers.getContractFactory("GeneratorTesting");
    instance = await testContract.deploy();
  });

  it("1 Bytes", async function() {
    const [owner, user] = await ethers.getSigners();
    const address = user.address;
    const genes = [0, 0, 0, 0];
    const count = 2;
    const rnd = new Generator(address, genes);
    const rndSeed = new Generator(address, genes);

    const jsSeeds = [...Array(count)].map(() => {
      const seed = rndSeed.seed;
      rndSeed.hashSeed();
      return seed;
    });

    let solSeeds = await instance.dumpSeeds(address, genes, count);
    solSeeds = solSeeds.map(s => s.substring(2));

    const solBytes = async () =>
      (await instance.dumpUInt8(address, [0, 0, 0, 0], count * 32)).map(v =>
        digits(3, v.toString())
      );

    const solValues = await solBytes();
    const jsValues = [...Array(count * 32)].map((_, i) =>
      digits(3, rnd.popUInt8().toString())
    );

    console.log(jsSeeds[0]);
    for (let i = 0; i < count; i++) {
        console.log("-hash-")
      for (let idx = 0; idx < 32; idx++) {
        const valueIndex = idx + (i * 32);
        const same = solValues[valueIndex] === jsValues[valueIndex];
        const color = !same ? chalk.red : chalk.green;

        console.log(
          color(digits(2, idx.toString())) + ":",
          solSeeds[i][idx * 2] + solSeeds[i][idx * 2 + 1],
          jsSeeds[i][idx * 2] + jsSeeds[i][idx * 2 + 1],
          "|",
          solValues[valueIndex],
          jsValues[valueIndex]
        );
      }
    }
  });

  it("2 Bytes", async function() {
    const [owner, user] = await ethers.getSigners();
    const address = user.address;
    const genes = [0, 0, 0, 0];
    const count = 2;
    const rnd = new Generator(address, genes);
    const rndSeed = new Generator(address, genes);

    const jsSeeds = [...Array(count)].map(() => {
      const seed = rndSeed.seed;
      rndSeed.hashSeed();
      return seed;
    });

    let solSeeds = await instance.dumpSeeds(address, genes, count);
    solSeeds = solSeeds.map(s => s.substring(2));

    const solBytes = async () =>
      (await instance.dumpUInt16(address, [0, 0, 0, 0], count * 16)).map(v =>
        digits(5, v.toString())
      );

    const solValues = await solBytes();
    const jsValues = [...Array(count * 16)].map((_, i) =>
      digits(5, rnd.popUInt16().toString())
    );

    console.log(jsSeeds[0]);
    for (let i = 0; i < count; i++) {
        console.log("-hash-")
      for (let idx = 0; idx < 16; idx++) {
        const valueIndex = idx + (i * 16);
        const same = solValues[valueIndex] === jsValues[valueIndex];
        const color = !same ? chalk.red : chalk.green;

        console.log(
          color(digits(2, idx.toString())) + ":",
          solSeeds[i][idx * 4] + solSeeds[i][idx * 4 + 1],
          jsSeeds[i][idx * 4] + jsSeeds[i][idx * 4 + 1],
          "|",
          solValues[valueIndex],
          jsValues[valueIndex]
        );
      }
    }
  });
});
