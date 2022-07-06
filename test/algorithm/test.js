const { expect } = require("chai");
const { ethers } = require("hardhat");
const chalk = require("chalk");

describe("Algorithm", function() {
  let instance;

  beforeEach(async () => {
    const genContract = await ethers.getContractFactory("Generator");
    const genInstance = await genContract.deploy();
    const contract = await ethers.getContractFactory("Algorithm", {
      libraries: { Generator: genInstance.address }
    });
    instance = await contract.deploy();
  });

  it("Color sample", async function() {
    const [owner, user] = await ethers.getSigners();
    const genes = [0, 0, 0, 0];
    const colors = 16;

    const callColor = async genes =>
      await instance.generateColor(owner.address, genes);

      console.log("rbg for gene mutation:");
    for (let i = 0; i < colors; i++) {
      const geneMutationFactor = parseInt(i / colors * 256);
      let index = i.toString(16);
      if (index.length === 1) index = "0" + index;

      console.log(
        chalk
          .rgb(...(await callColor([geneMutationFactor, 0, 0, 0, 0])))
          .visible(`[${index}]`),
        chalk
          .rgb(...(await callColor([0, geneMutationFactor, 0, 0, 0])))
          .visible(`[${index}]`),
        chalk
          .rgb(...(await callColor([0, 0, geneMutationFactor, 0, 0])))
          .visible(`[${index}]`),
        chalk
          .rgb(...(await callColor([0, 0, 0, geneMutationFactor, 0])))
          .visible(`[${index}]`),
        chalk
          .rgb(...(await callColor([0, 0, 0, 0, geneMutationFactor])))
          .visible(`[${index}]`)
      );
    }
  });
});
