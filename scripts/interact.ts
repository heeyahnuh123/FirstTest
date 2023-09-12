import { ethers } from 'ethers';

const provider = new ethers.providers.JsonRpcProvider('https://mainnet.infura.io/v3/000bcb71eb974611b9657eb89fc35c24');

const uniswapV2Address = '0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D';
const uniswapV2Abi = ['0xC75650fe4D14017b1e12341A97721D5ec51D5340'];

const uniswapV2Contract = new ethers.Contract(uniswapV2Address, uniswapV2Abi, provider);

const tokenA = '0x2820c404f1b4f18e66461c35542eaC5f1ce1EA0f';
const tokenB = '0x75FDAc7A28B179144fc40ac8431847D7e3E93C53';
const amountADesired = ethers.utils.parseEther('100'); // Convert the desired amount to the appropriate unit
const amountBDesired = ethers.utils.parseEther('200'); // Convert the desired amount to the appropriate unit
const amountAMin = ethers.utils.parseEther('90'); // Convert the minimum amount to the appropriate unit
const amountBMin = ethers.utils.parseEther('180'); // Convert the minimum amount to the appropriate unit
const to = '0x925d0F3Cb509D5B26d6ff6DaB7F9Da906F19EE94';
const deadline = Math.floor(Date.now() / 1000) + 60 * 10; // Set the deadline to 10 minutes from now

const tx = await uniswapV2Contract.addLiquidity(
  tokenA,
  tokenB,
  amountADesired,
  amountBDesired,
  amountAMin,
  amountBMin,
  to,
  deadline
);

const tx = await uniswapRouter.removeLiquidity(
    tokenA,
    tokenB,
    liquidityAmount,
    minAmountA,
    minAmountB,
    signer.address,
    deadline
  );

  const receipt = await tx.wait();

  if (receipt.status === 1) {
    console.log('Liquidity removed successfully!');
  } else {
    console.error('Failed to remove liquidity.');
  }