const { expect } = require("chai");
const { ethers } = require("hardhat");
const chalk = require("chalk");
const Generator = require("../scripts/Generator");

describe("Generators pair testing", function() {
  let instance;

  beforeEach(async () => {
    const contract = await ethers.getContractFactory("Generator");
    instance = await contract.deploy();
  });

  it("Starts with same hash as JS", async function() {
    const [owner, user] = await ethers.getSigners();
    const genes = [0, 0, 0, 0];
    const rnd = new Generator(owner.address, genes);

    expect(await instance.getSeed(owner.address, genes)).to.equal(
      "0x" + rnd.seed
    );
  });

  it("Outputs same uint suite as JS", async function() {
    const [owner, user] = await ethers.getSigners();
    const genes = [0, 0, 0, 0];
    const address = owner.address;

    const rnd = new Generator(address, genes);

    const count = 128;
    const jsValues = [...Array(count)].map(() => rnd.popUInt());
    let solValues;

    try {
      solValues = await instance.dumpUInts(address, genes, count);
    } catch (err) {
      solValues = [...Array(count)].map(() => "ERR");
    }

    console.log("uints: (js) vs. (sol)");
    jsValues.forEach((v, i) => {
      console.log(
        i + ":",
        chalk.rgb(v, 255 - v, 50).visible(v),
        chalk.rgb(v, 255 - v, 50).visible(solValues[i])
      );
    });
    jsValues.forEach((v, i) => {
      expect(solValues[i]).to.equal(v);
    });
  });
});
