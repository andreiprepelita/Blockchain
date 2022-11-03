// SPDX-License-Identifier: MIT
 
pragma solidity >=0.8.0 <=0.8.17;
 
import './Sponsor_Funding.sol';
 
contract CrowdFunding {
 
   uint public fundingGoal;
   enum State {
       nefinantat,
       prefinantat,
       finantat
   }
   State currentState;
   address payable owner;
 
   mapping (address => Contribuitor) contribuitors; //variabila de tip mapping
   struct Contribuitor {
       string name;
       uint balance;
   }
 
   constructor(uint _fundingGoal) {
       currentState=State.nefinantat;
       fundingGoal = _fundingGoal;
       owner = payable(msg.sender);
   }
 
   function getCrowdFundingBalance() external view returns (uint) {
       return address(this).balance;
   }
 
   function getCurrentState() public view returns (string memory) {
       if(currentState==State.nefinantat)
           return "nefinantat";
       if(currentState==State.prefinantat)
           return "prefinantat";
       if(currentState==State.finantat)
           return "finantat";
       return "";
   }
 
   modifier nefinantatState() {
        require(currentState==State.nefinantat, "You can no longer contribute/withdraw ");
        _;
   }
 
   modifier onlyOwner() {
       require(msg.sender == owner, "You don't have access to this feature");
       _;
   }
 
   function contribute(string calldata name) payable external nefinantatState {
       require(msg.value>0, "You don't have enough money");
       address payable contribuitorAddr = payable(msg.sender);
       Contribuitor memory contribuitor = Contribuitor(name, msg.value);
       contribuitor.balance += contribuitors[contribuitorAddr].balance;
       contribuitors[contribuitorAddr]= contribuitor;
 
       if(address(this).balance >= fundingGoal) {
           currentState = State.prefinantat;
       }
   }
 
   function withdraw(uint amount) payable external nefinantatState {
       address payable user = payable(msg.sender);
       require(amount<=contribuitors[user].balance, "Amount too big");
       contribuitors[user].balance= contribuitors[user].balance - amount;
       user.transfer(amount);
   }
 
   function communicateToSponsorFunding(address sponsorAddress) external onlyOwner payable {
       require(currentState == State.prefinantat, "You cannot communicate with SponsorFunding.");
       (bool successTransaction, ) = payable(sponsorAddress).call(abi.encodeWithSignature("sponsorCrowdFunding()"));
       require(successTransaction, "Transaction failed");
       currentState = State.finantat;
 
   }
 
   // function transferToDistributeFunding() external onlyOwner {
   //     require(currentState == State.finantat, "You cannot transfer current fund to DistributeFunding");
   // }
 
   receive() external payable {
 
   }
 
 
}

