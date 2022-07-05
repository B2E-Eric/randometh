const { expect } = require("chai");
const { ethers } = require("hardhat");
const { getHash } = require("../scripts/random");

describe("Random Generation", function() {
  let instance;

  beforeEach(async () => {
    const contract = await ethers.getContractFactory("Generator");
    instance = await contract.deploy();
  });

  it("Should return a number", async function() {
    const [owner, user] = await ethers.getSigners();
    const byteCount = 1;
    const jsBytes = getHash(owner.address).substring(2, 2 + 2 * byteCount);
    const solBytes = await instance.getBytes(
      owner.address,
      [0, 0, 0, 0],
      byteCount
    );

    console.log("from:", owner.address);
    console.log("sol :", await instance.getSeed(owner.address, [0, 0, 0, 0]));
    console.log("js  :", getHash(owner.address));

    console.log("bytes:", solBytes, "vs", jsBytes);

    console.log(
      byteCount,
      "b nb (sol) :",
      (await instance.getNumber(
        owner.address,
        [0, 0, 0, 0],
        byteCount
      )).toNumber()
    );
    console.log(byteCount, "b nb (js)  :", parseInt(jsBytes, 16));
  });
});
