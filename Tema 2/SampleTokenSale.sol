// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./SampleToken.sol";

contract SampleTokenSale {
    
    SampleToken public tokenContract;
    uint256 public tokenPrice;
    address owner;

    uint256 public tokensSold;

    event Sell(address indexed _buyer, uint256 indexed _amount);

    modifier onlyOwner() {

       require(msg.sender == owner, "You don't have access to this feature");
       _;
   }

    constructor(SampleToken _tokenContract, uint256 _tokenPrice) {
        owner = msg.sender;
        tokenContract = _tokenContract;
        tokenPrice = _tokenPrice;
    }

    function buyTokens(uint256 _numberOfTokens) public payable {
        require(msg.value >= _numberOfTokens * tokenPrice, "Not enough money");
        require(tokenContract.allowance(owner, address(this)) >= _numberOfTokens, "Fewer tokens in stock");
        require(tokenContract.balanceOf(owner) >= _numberOfTokens, "The owner is very poor");
        require(tokenContract.transferFrom(owner, msg.sender, _numberOfTokens), "Transfer failed");

        tokensSold += _numberOfTokens;
        uint256 remainingBalance = msg.value - _numberOfTokens*tokenPrice;

        payable(msg.sender).transfer(remainingBalance);
        emit Sell(msg.sender, _numberOfTokens);
        
    }
    
    function updateTokenPrice(uint256 _tokenPrice) external onlyOwner {
        tokenPrice = _tokenPrice;
    }

    function endSale() public onlyOwner {
        require(tokenContract.transfer(owner, tokenContract.balanceOf(address(this))), "Transfer failed to owner");
        require(tokenContract.transferFrom(owner, owner, tokenContract.allowance(owner, address(this))), "Transfer failed to owner from owner");
        
        payable(msg.sender).transfer(address(this).balance);
    }
}