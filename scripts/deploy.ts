import { ethers } from 'hardhat';

async function main() {
  const network = 'SEPOLIA'; // Replace with the network name you want to use
  const [deployer] = await ethers.getSigners();

  console.log('Deploying contract with the account:', deployer.address);

  const tokenContractA = await ethers.getContractFactory('IyTokenTestA');
  const contractA = await tokenContractA.deploy();

  await contractA.waitForDeployment();

  console.log('Contract deployed to address:', contractA.address);

  const tokenContractB = await ethers.getContractFactory('IyTokenTestB');
  const contractB = await tokenContractB.deploy();

  await contractB.waitForDeployment();

  console.log('Contract deployed to address:', contractB.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
