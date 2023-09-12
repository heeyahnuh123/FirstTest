// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./IyTokenTestA.sol";
import "./IyTokenTestB.sol";

error null_Address();

contract swap {

    IyTokenTestA public iyTokenTestAaddress;
    IyTokenTestB public iyTokenTestBaddress;

    struct LiquidityProvider {
        uint256 amountA;
        uint256 amountB;
    }

    mapping(address => LiquidityProvider) public liquidityProvider;
    
    constructor(address iyTokenTestA, address iyTokenTestB){
        if(iyTokenTestA == address(0) && iyTokenTestB == address(0)) {
        revert null_Address();
        }
    
        iyTokenTestAaddress = IyTokenTestA(iyTokenTestA);
        iyTokenTestBaddress = IyTokenTestB(iyTokenTestB);
    }

    function getResA() public view returns (uint256) {
        return iyTokenTestAaddress.balanceOf(address(this));
    }

    function getResB() public view returns (uint256) {
        return iyTokenTestBaddress.balanceOf(address(this));
    }

    function addLiquidity(uint256 iyTokenTestAamount, uint256 iyTokenTestBamount) external {
        require(iyTokenTestAamount > 0 && iyTokenTestBamount > 0, "The amount must be greater than zero");
    
        uint256 iyTokenTestAResBalance = getResA();
        uint256 iyTokenTestBResBalance = getResB();
    
        iyTokenTestAaddress.transferFrom(msg.sender, address(this), iyTokenTestAamount);
        iyTokenTestBaddress.transferFrom(msg.sender, address(this), iyTokenTestBamount);
        
        iyTokenTestAResBalance += iyTokenTestAamount;
        iyTokenTestBResBalance += iyTokenTestBamount;
        
        LiquidityProvider storage provider = liquidityProvider[msg.sender];
        
        provider.amountA += iyTokenTestAamount;
        provider.amountB += iyTokenTestBamount;
    }

    function removeLiquity(uint256 iyTokenTestAamount, uint256 iyTokenTestBamount) external {
        require(iyTokenTestAamount > 0 && iyTokenTestBamount > 0, "The amount must be greater than zero");

        LiquidityProvider storage provider = liquidityProvider[msg.sender];
        require(provider.amountA >= iyTokenTestAamount && provider.amountB >= iyTokenTestBamount, "Insufficient liquidity");

        uint256 iyTokenTestAResBalance = getResA();
        uint256 iyTokenTestBResBalance = getResB();


        iyTokenTestAaddress.transfer(msg.sender, iyTokenTestAamount);
        iyTokenTestBaddress.transfer(msg.sender, iyTokenTestAamount);

        iyTokenTestAResBalance -= iyTokenTestAamount;
        iyTokenTestBResBalance -= iyTokenTestBamount;
    
        provider.amountA -= iyTokenTestAamount;
        provider.amountB -= iyTokenTestBamount;
    }

    function swapiyTokenTestAtoiyTokenTestB(uint256 iyTokenTestAamount) external returns(uint256){
        require(iyTokenTestAamount > 0, "iyTokenTestA must be greater than 0");
    
        //to transfer amount to iyTokenTestA reserve
        iyTokenTestAaddress.transferFrom(msg.sender, address(this), iyTokenTestAamount);
    
        uint256 iyTokenTestAResBalance = getResA();
        uint256 iyTokenTestBResBalance = getResB();
        uint256 iyTokenTestBexpected = iyTokenTestBResBalance * iyTokenTestAamount / iyTokenTestAResBalance + iyTokenTestAamount;
    
        // iyTokenTestBResBalance += iyTokenTestAamount;
        iyTokenTestBaddress.transfer(msg.sender, iyTokenTestBexpected);
        return iyTokenTestBexpected;
    }

    function swapiyTokenTestBtoiyTokenTestA(uint256 iyTokenTestBamount) external returns(uint256){
        require(iyTokenTestBamount > 0, "iyTokenTestA must be greater than 0");
    
        //transfer amount to iyTokenTestA reserve
        iyTokenTestAaddress.transferFrom(msg.sender, address(this), iyTokenTestBamount);
        uint256 iyTokenTestAResBalance = getResA();
        uint256 iyTokenTestBResBalance = getResB();
    
        // (x * y) = k 
        uint256 iyTokenTestAexpected = iyTokenTestAResBalance * iyTokenTestBamount / iyTokenTestBResBalance + iyTokenTestBamount;
        // iyTokenTestBResBalance += iyTokenTestBamount;
        iyTokenTestBaddress.transfer(msg.sender, iyTokenTestAexpected);
        return iyTokenTestAexpected;
}

}