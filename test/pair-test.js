const { expect } = require("chai");
const { ethers } = require("hardhat");
const chalk = require("chalk");
const Generator = require("../scripts/Generator");

const zeros = n => Array(n).fill("0");
const digits = (n, value) => [...zeros(n - value.length), value].join("");

describe("Generators pair testing", function() {
  let gInstance;
  let instance;

  // const issueBytes = async (address, genes, iterations) => {
  //   const rand = new Generator(address, genes);
  //   const contract = instance;

  //   const js = [...Array(iterations)].map((_, i) => rand.popUInt8());
  //   const sol = await contract.dumpUInt8(address, genes, iterations);

  //   return { js, sol };
  // };

  const issueBytes = async (address, genes, iterations, bytes = 1) => {
    const rand = new Generator(address, genes);
    const contract = instance;
    const solByteValues = [
      () => contract.dumpUInt8(address, genes, iterations),
      () => contract.dumpUInt16(address, genes, iterations)
    ];
    const jsByteValues = [() => rand.popUInt8(), () => rand.popUInt16()];

    const js = [...Array(iterations)].map(jsByteValues[bytes - 1]);
    const sol = await solByteValues[bytes - 1]();

    return { js, sol };
  };

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

  describe("Gene influence", async function() {
    const matchForNBytes = async function(bytes, count = 32 / bytes, log = true) {
      const [owner] = await ethers.getSigners();
      const address = owner.address;
      const mutation = 50;
      const geneCount = 6;
      const genome = i =>
        i === -1
          ? [...Array(geneCount)].fill(0)
          : [...Array(geneCount)].fill(0).fill(mutation, i, i + 1);

      const original = await issueBytes(address, genome(-1), count, bytes);
      const format = v => digits(bytes * 2 + 1, v.toString());

      log && console.log(`gene influence 1 byte (${mutation})`);
      log &&console.log("bytes  :", ...original.js.map(v => format(v)));

      let errorCount = 0;
      await Promise.all(
        [...Array(geneCount)].map(async (byte, i) => {
          const values = await issueBytes(address, genome(i), count, bytes);
          const displayed = values.js.map((v, i) => {
            if (v != values.sol[i]) {
              errorCount++;
              return chalk.bgRed(format(v));
            } else {
              return v === original.js[i]
                ? chalk.red(format(v))
                : chalk.green(format(v));
            }
          });
          if (!log) return;
          console.log("gene", i, ":", ...displayed);
        })
      );
      expect(errorCount).to.equal(
        0,
        "There were mismatches between JS and SOL values"
      );
    };
    it("Display gene influence on 1 byte", async () => matchForNBytes(1));
    it("Matches gene influence on 1 byte", async () => matchForNBytes(2, 500, false));
    it("Matches gene influence on 2 byte", async () => matchForNBytes(2, 500, false));
    it("Has fair value occurence", async function() {
      const [owner, user] = await ethers.getSigners();
      const count = 100000;
      const values = [0, 1, 128, 254, 255];
      const occurences = Array(values.length).fill(0);

      const rnd = new Generator(owner.address, [0, 0, 0, 0]);

      for (let i = 0; i < count; i++) {
        const n = rnd.popUInt8();
        values.forEach((value, idx) => {
          if (value === n) occurences[idx] = occurences[idx] + 1;
        });
      }
      occurences.forEach((value, i) => {
        console.log(values[i], ":", value);
      });
    });

    it("Generates int with min/max", async function() {
      const [owner, user] = await ethers.getSigners();
      const count = 32;
      const genes = [0, 0, 0, 0];
      const min = 0;
      const max = 10;
      const rnd = new Generator(owner.address, genes);
      const jsValues = [...Array(count)].map(() => rnd.popInt(min, max, false));
      const solValues = await instance.dumpInt(
        owner.address,
        genes,
        min,
        max,
        count
      );

      console.log("rbg for gene mutation:");
      console.log("sol :", ...solValues);
      console.log("js  :", ...jsValues);
      jsValues.map((v, i) => expect(v).to.equal(solValues[i]));
    });
  });
});
