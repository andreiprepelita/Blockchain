// SPDX-License-Identifier: MIT
 
pragma solidity >=0.8.0 <=0.8.17;
 
 
contract CrowdFunding {
 
   uint public fundingGoal;
   uint public currentFund;
   enum State {
       nefinantat,
       prefinantat,
       finantat
   }
   State currentState;
 
   mapping (address => contribuitor) contribuitors; //variabila de tip mapping
   struct contribuitor {
       string name;
       uint age;
       uint balance;
   }
 
   constructor() {
       currentState=State.nefinantat;
       currentFund=0;
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
 
   function getCurrentFund() external view returns (uint) {
       return currentFund;
   }
   modifier nefinantatState() {
        require(currentState==State.prefinantat, "You can no longer contribute ");
        _;
   }
   function contribute() payable external nefinantatState {
       require(msg.value>0, "You don't have enough money");
       contribuitors[msg.sender].balance +=msg.value;
       currentFund +=msg.value;
       if(currentFund == fundingGoal) {
           currentState = State.prefinantat;
       }
   }
 
   function withdraw(uint amount) payable external nefinantatState {
       address payable user = payable(msg.sender);
       require(amount<=contribuitors[user].balance, "amount too big");
       contribuitors[user].balance= contribuitors[user].balance - amount;
       user.transfer(amount);
   }
 
}

