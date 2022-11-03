// SPDX-License-Identifier: MIT
 
pragma solidity >=0.8.0 <=0.8.17;
 
import './Crowd_Funding.sol';
 
 
contract SponsorFunding {
 
   uint percentage;
   address payable owner;
   bool fundingGoalReady;
 
   constructor(uint _percentage) payable verifyPercentage(_percentage) {
       percentage = _percentage;s
       owner = payable(msg.sender);
       fundingGoalReady = false;
   }
 
   modifier onlyOwner() {
       require(msg.sender == owner, "You don't have access to this feature");
       _;
   }
 
   modifier verifyPrefinantatState() {
       address payable addressCrowdFunding = payable (msg.sender);
       CrowdFunding crowdFunding = CrowdFunding(addressCrowdFunding);
       if (keccak256(abi.encodePacked("prefinantat")) != keccak256(abi.encodePacked(crowdFunding.getCurrentState())))
           revert("Crowd funding unmet");
       _;
   }
 
   modifier verifyPercentage(uint percentageConstructor) {
       require(percentage<=100, "Put the percentage in the range 0,100");
       _;
   }
 
   function addBalanceChangePercent(uint _percentage) external payable onlyOwner verifyPercentage(_percentage){
       require(msg.value>0, "You don't have enough money");
       percentage = _percentage;
   }
 
   function sponsorCrowdFunding() external payable verifyPrefinantatState {
       address payable addressCrowdFunding = payable(msg.sender);
       uint balanceIndicator = 1;
       if(percentage * addressCrowdFunding.balance / 100 > address(this).balance)
           balanceIndicator = 0;
 
       addressCrowdFunding.transfer(percentage * addressCrowdFunding.balance / 100 * balanceIndicator);
      
   }
  
   function transferOwnBalanceToCrownFunding() external payable onlyOwner {
       require(fundingGoalReady, "Lack of CrowdFunding communication");
 
   }
 
   receive () external payable {
 
   }
 
 
}
 

