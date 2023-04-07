const { ethers } = require("hardhat");

async function main() {

  const swapContract = await ethers.getContractFactory("SwapUSD");

  const deployedSwapContract = await swapContract.deploy();

  await deployedSwapContract.deployed();

  console.log("Contract Address:",deployedSwapContract.address);
  console.log("Deployed Contract");

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
