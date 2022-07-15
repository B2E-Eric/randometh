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

  it("Matches seed hashing", async function() {
    const [owner, user] = await ethers.getSigners();
    const genes = [0, 0, 0, 0];
    const count = 64;
    const rnd = new Generator(owner.address, genes);
    const solSeeds = await instance.dumpSeeds(owner.address, genes, count);

    solSeeds.forEach(seed => {
      expect("0x" + rnd.seed).to.equal(seed);
      rnd.hashSeed();
    });
  });

  it("Matches mutation distribution on 1 byte", async function() {
    const [owner, user] = await ethers.getSigners();
    const count = 32;
    const mutation = 50;
    const geneCount = 6;
    const genome = i => [...Array(geneCount)].fill(0).fill(mutation, i, i + 1);

    // [...Array(geneCount)].forEach((_, i) => {
    //   console.log(genome(i));
    // });

    const bytes = i => {
      const rnd = new Generator(owner.address, genome(i));
      return [...Array(count)].map(() => digits(3, rnd.popUInt8().toString()));
    };

    const solBytes = async i => {
      return (await instance.dumpUInt8(
        owner.address,
        genome(i),
        count
      )).map((v) => digits(3, v.toString()));
    };

    const fullSolBytes = await Promise.all(
      [...Array(geneCount)].map(async (_, i) => solBytes(i))
    );

    const original = bytes(-1);

    console.log(`mutation distribution (${mutation})`);
    console.log("bytes  :", ...original);

    [...Array(geneCount)].forEach((byte, i) => {
      const values = bytes(i);
      const solValues = solBytes(i);
      values.forEach((v, idx) => expect(v).to.equal(fullSolBytes[i][idx]));
      const displayed = bytes(i).map(
        (v, i) => (v === original[i] ? chalk.red(v) : chalk.green(v))
      );
      console.log("gene", i, ":", ...displayed);
    });
  });

  it("Matches mutation distribution on 2 bytes", async function() {
    const [owner, user] = await ethers.getSigners();
    const count = 21;
    const mutation = 50;
    const geneCount = 6;
    const genome = i => [...Array(geneCount)].fill(0).fill(mutation, i, i + 1);

    // [...Array(geneCount)].forEach((_, i) => {
    //   console.log(genome(i));
    // });

    const bytes = i => {
      const rnd = new Generator(owner.address, genome(i));
      return [...Array(count)].map(() => digits(5, rnd.popUInt16().toString()));
    };

    const solBytes = async i => {
      return (await instance.dumpUInt16(
        owner.address,
        genome(i),
        count
      )).map((v) => digits(5, v.toString()));
    };

    const fullSolBytes = await Promise.all(
      [...Array(geneCount)].map(async (_, i) => solBytes(i))
    );

    const original = bytes(-1);

    console.log(`mutation distribution (${mutation})`);
    console.log("bytes  :", ...original);

    [...Array(geneCount)].forEach((byte, i) => {
      const values = bytes(i);
      const solValues = solBytes(i);
      values.forEach((v, idx) => expect(v).to.equal(fullSolBytes[i][idx]));
      const displayed = bytes(i).map(
        (v, i) => (v === original[i] ? chalk.red(v) : chalk.green(v))
      );
      console.log("gene", i, ":", ...displayed);
    });
  });

  it("Has fair value occurence", async function () {
    const [owner, user] = await ethers.getSigners();
    const count = 100000;
    const values = [0, 1, 128, 254, 255];
    const occurences = Array(values.length).fill(0);

    const rnd = new Generator(owner.address, [0, 0, 0, 0]);

    for (let i = 0; i < count; i++) {
      const n = rnd.popUInt8();
      values.forEach((value, idx) => {
        if (value === n)
          occurences[idx] = occurences[idx]  + 1;
      })
    }
    occurences.forEach((value, i) => {
      console.log(values[i], ":", value);
    })
  })

  it("Generates int with min/max", async function () {
    const [owner, user] = await ethers.getSigners();
    const count = 32;
    const genes = [0, 0, 0, 0];
    const min = -16;
    const max = 10;
    const rnd = new Generator(owner.address, genes);
    const jsValues = [...Array(count)].map(() => rnd.popInt(min, max));
    const solValues = await instance.dumpInt(owner.address, genes, min, max, count);

    console.log("rbg for gene mutation:");
    console.log(
      "sol :",
      ...solValues
    );
    console.log("js  :", ...jsValues);
    jsValues.map((v, i) => expect(v).to.equal(solValues[i]))
  })
});
