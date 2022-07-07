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
    const testContract = await ethers.getContractFactory("GeneratorTesting", {
      libraries: { Generator: gInstance.address }
    });
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

  it("Outputs same uint suite as JS", async function() {
    const [owner, user] = await ethers.getSigners();
    const genes = [0, 0, 0, 0];
    const genes2 = [0, 0, 100, 0, 0];
    const address = owner.address;

    const rnd = new Generator(address, genes);
    const rnd2 = new Generator(address, genes2);

    const count = 64;
    const jsValues = [...Array(count)].map(() => rnd.popUInt8());
    const jsMutateValues = [...Array(count)].map(() => rnd2.popUInt8());
    let solValues;
    let solMutateValues;

    try {
      solValues = await instance.dumpUInt8(address, genes, count);
      solMutateValues = await instance.dumpUInt8(address, genes2, count);
    } catch (err) {
      console.error(err);
      solValues = [...Array(count)].map(() => 0);
      solMutateValues = solValues;
    }

    const colored = v => chalk.rgb(v, 255 - v, 70).visible(v);
    const mutateArrow = (v1, v2) =>
      chalk.rgb(v1 !== v2 ? 255 : 50, 50, 50).visible("->");

    console.log("uints: (js) vs. (sol)");
    jsValues.forEach((v, i) => {
      console.log(
        i + ":",
        colored(v),
        mutateArrow(v, jsMutateValues[i]),
        colored(jsMutateValues[i]),
        colored(solValues[i]),
        mutateArrow(solValues[i], solMutateValues[i]),
        colored(solMutateValues[i])
      );
    });
    jsValues.forEach((v, i) => {
      expect(solValues[i]).to.equal(v);
      expect(solMutateValues[i]).to.equal(jsMutateValues[i]);
    });
  });
});
