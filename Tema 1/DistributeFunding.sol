// SPDX-License-Identifier: MIT
 
pragma solidity >=0.8.0 <=0.8.17;
 
import './Crowd_Funding.sol';
 
contract DistributeFunding {
  
   struct ShareHolder{
       bool hasReceived;
       uint8 percentage;
   }
   mapping (address => ShareHolder) private shareholders;
   bool private isDistributed;
   uint8 private totalPercentage;
   uint private totalSumReceived;
   address payable owner;
 
   constructor() {
       isDistributed = false;
       totalSumReceived = 0;
       owner = payable(msg.sender);
   }
 
   modifier verifyFinantatState() {
       address payable addressCrowdFunding = payable (msg.sender);
       CrowdFunding crowdFunding = CrowdFunding(addressCrowdFunding);
       if (keccak256(abi.encodePacked("finantat")) != keccak256(abi.encodePacked(crowdFunding.getCurrentState())))
           revert("Crowd funding unsponsored");
       _;
   }
  
   modifier verifyShareHolder(uint8 _percentage) {
       require(isDistributed == false, "The shareholders have already been established.");
       require(_percentage <= 100, "The percentage should be between 0 and 100");
       // in caz ca ShareHolder-ul exista, scad procentajul vechi, si adaug pe cel nou. Daca nu exista vom avea valoarea 0 pentru procentajul vechi
       totalPercentage = totalPercentage - shareholders[payable(msg.sender)].percentage;
       require(_percentage + totalPercentage <= 100, "The total percentage surpasses 100");
       _;
   }
 
   modifier validateWithdraw() {
       require(isDistributed == true, "You need to wait to receive the funds from CrowdFunding");
       require(shareholders[payable(msg.sender)].hasReceived == false, "You have already received the funds");
       _;
   }
   //optional
   modifier onlyOwner() {
       require(msg.sender == owner, "You don't have access to this feature");
       _;
   }
 
   function becomeAShareHolder(uint8 _percentage) external
   verifyShareHolder(_percentage)
   {
       address payable shareHolderAddr = payable(msg.sender);
       ShareHolder memory shareHolder = ShareHolder(false, _percentage);
       shareholders[shareHolderAddr] = shareHolder;
       totalPercentage += _percentage;
   }
 
   function communicateTransfer() external payable verifyFinantatState {
       require(isDistributed == false, "Funds have already been received ");
       totalSumReceived = address(this).balance;
       isDistributed = true;
   }
 
   function withdraw() external payable validateWithdraw {
       address payable user = payable(msg.sender);
       uint amount = shareholders[user].percentage * totalSumReceived / 100;
       shareholders[user].hasReceived = true;
       user.transfer(amount);
   }
 
   function getMyPercentage() external view returns (uint8) {
       return shareholders[msg.sender].percentage;
   }
 
   function getDistributeFundingBalance() external view returns (uint) {
       return address(this).balance;
   }
   //optional
   function getRemainingPercentage() external payable onlyOwner {
       require(isDistributed==true);
       require(totalPercentage<100);
       uint amount = (100-totalPercentage) * totalSumReceived / 100;
       totalPercentage = 100;
       owner.transfer(amount);
      
   }
 
   receive() external payable {
    
  }
 
 
}
 

