const { expect } = require("chai");
const { ethers } = require("hardhat");
const { getHash} = require("../scripts/random");

describe("Random Generation", function () {

  let instance;

  beforeEach(async () => { 
    const contract = await ethers.getContractFactory("Generator");
    instance = await contract.deploy();
  })

  it("Should return a number", async function () {
    const [owner, user] = await ethers.getSigners();

    console.log('from:', owner.address);
    console.log("sol :", await instance.getSeed(owner.address, [0, 0, 0, 0]));
    console.log("js  :", getHash(owner.address));

    console.log("1 byte sol:", await instance.getFirstBytes(owner.address, [0, 0, 0, 0]));

    console.log("1st nb sol :", await instance.getFirstNumber(owner.address, [0, 0, 0, 0]));
    console.log("1st nb sol :", parseInt(getHash(owner.address).substring(2, 4), 16));

  });
});
