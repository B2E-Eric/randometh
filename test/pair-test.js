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
    const genes2 = [0, 0, 0, 0, 100];
    const address = owner.address;

    const rnd = new Generator(address, genes);
    const rnd2 = new Generator(address, genes2);

    const count = 128;
    const jsValues = [...Array(count)].map(() => rnd.popUInt());
    const jsMutateValues = [...Array(count)].map(() => rnd2.popUInt());
    let solValues;
    let solMutateValues;

    try {
      solValues = await instance.dumpUInts(address, genes, count);
      solMutateValues = await instance.dumpUInts(address, genes2, count);
    } catch (err) {
      console.error(err);
      solValues = [...Array(count)].map(() => 0);
      solMutateValues = solValues;
    }

    const colored = (v) => chalk.rgb(v, 255 - v, 70).visible(v);
    const mutateArrow = (v1, v2) => chalk.rgb(v1 !== v2 ? 255 : 50, 50, 50).visible('->');

    console.log("uints: (js) vs. (sol)");
    jsValues.forEach((v, i) => {
      console.log(
        i + ":",
        colored(v),
        mutateArrow(v, jsMutateValues[i]),
        colored(jsMutateValues[i]),
        colored(solValues[i]),
        mutateArrow(solValues[i], solMutateValues[i]),
        colored(solMutateValues[i]),
      );
    });
    jsValues.forEach((v, i) => {
      expect(solValues[i]).to.equal(v);
      expect(solMutateValues[i]).to.equal(jsMutateValues[i]);
    });
  });
});
