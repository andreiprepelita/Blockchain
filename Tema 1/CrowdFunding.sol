// SPDX-License-Identifier: MIT
 
pragma solidity >=0.8.0 <=0.8.17;
 
import './Sponsor_Funding.sol';
import './Distribute_Funding.sol';
 
contract CrowdFunding {
 
   uint public fundingGoal;
   enum State {
       nefinantat,
       prefinantat,
       finantat
   }
   State private currentState;
   address payable owner;
 
   mapping (address => Contribuitor) private contribuitors; //variabila de tip mapping
   struct Contribuitor {
       string name;
       uint balance;
   }
   bool private isDistributed;
   constructor(uint _fundingGoal) {
       currentState=State.nefinantat;
       fundingGoal = _fundingGoal;
       isDistributed = false;
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
       return "necunoscut";
   }
 
   modifier onlyOwner() {
       require(msg.sender == owner, "You don't have access to this feature");
       _;
   }
   modifier verifyCurentState(State stateParam, string memory errorMsg) {
       require(currentState == stateParam, errorMsg);
       _;
   }
   function contribute(string calldata name) payable external
   verifyCurentState(State.nefinantat, "You can no longer contribute/withdraw ")
   {
       require(msg.value>0, "You don't have enough money");
       address payable contribuitorAddr = payable(msg.sender);
       Contribuitor memory contribuitor = Contribuitor(name, msg.value);
       contribuitor.balance += contribuitors[contribuitorAddr].balance;
       contribuitors[contribuitorAddr]= contribuitor;
 
       if(address(this).balance >= fundingGoal) {
           currentState = State.prefinantat;
       }
   }
 
   function withdraw(uint amount) payable external
   verifyCurentState(State.nefinantat, "You can no longer contribute/withdraw ")
   {
       address payable user = payable(msg.sender);
       require(amount<=contribuitors[user].balance, "Amount too big to withdraw");
       contribuitors[user].balance= contribuitors[user].balance - amount;
       user.transfer(amount);
   }
 
   function communicateToSponsorFunding(address payable sponsorAddress) external onlyOwner payable
   verifyCurentState(State.prefinantat, "You cannot communicate with SponsorFunding.")
   {
       (bool successTransaction, ) = sponsorAddress.call(abi.encodeWithSignature("sponsorCrowdFunding()"));
       require(successTransaction, "Transaction failed");
       currentState = State.finantat;
 
   }
 
   function transferToDistributeFunding(address payable distributeAddress) external onlyOwner payable
   verifyCurentState(State.finantat, "You cannot communicate with DistributeFunding.")
   {
       require(isDistributed == false, "You have already distributed the amount");
       (bool successTransaction, ) = distributeAddress.call {value: address(this).balance}
                                     (abi.encodeWithSignature("communicateTransfer()"));
       require(successTransaction, "Transaction failed");
       isDistributed  = true;
 
   }
 
   receive() external payable {
      
   }
 
}

