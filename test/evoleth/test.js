const { expect } = require("chai");
const { ethers } = require("hardhat");
const chalk = require("chalk");
const Generator = require("../../scripts/Generator").default;

describe("Algorithm", function() {
  let instance;

  beforeEach(async () => {
    const genContract = await ethers.getContractFactory("Generator");
    const genInstance = await genContract.deploy();
    const contract = await ethers.getContractFactory("Creature");
    instance = await contract.deploy();
  });

  it("Costs coherent gas", async function() {
    const [owner, user, user1] = await ethers.getSigners();
    
    
    await instance.generateTrait(owner.address, [0]);
    console.log(await instance.tokenURI(owner.address, [0]));
    console.log(await instance.tokenURI(user.address, [0]));
    console.log(await instance.tokenURI(user1.address, [0]));
  });
});
