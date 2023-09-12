import { ethers } from "hardhat";

async function main() {
    const swap = await ethers.deployContract("swap", [
        '0x2820c404f1b4f18e66461c35542eaC5f1ce1EA0f',
        '0x75FDAc7A28B179144fc40ac8431847D7e3E93C53'
    ]);

    swap.waitForDeployment();

    console.log(swap.target);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });