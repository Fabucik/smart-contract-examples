//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract Payout {
  
  // initiating employee
  struct Employee {
    uint amount;
    bool canWithdraw;
  }
  
  // creating mapping to "connect" address to employee
  mapping(address => Employee) employees;
  
  address owner;
  
  constructor() {
    // setting this variable for functions that require owner of this contract
    owner = msg.sender;
  }
  
  // function to give ether to employees storage
  function setEmployee(address emplAddress) public payable {
    require(msg.sender == owner, "Only owner can set an employee");
    require(emplAddress != owner, "You can not set yourself as an employee");
    
    // creating employee variable
    Employee storage empl = employees[emplAddress];
    
    // incrementing employees amount of wei and allowing him to withdraw
    empl.amount += msg.value;
    empl.canWithdraw = true;
  }
  
  function withdraw(uint amount) public {
    Employee storage empl = employees[msg.sender];
    require(empl.amount > 0, "You have 0 wei");
    require(amount > 0, "Must withdraw more than 0 wei");
    require(amount <= empl.amount, "Can not withdraw more than amount your allowed amount");
    require(empl.canWithdraw == true, "You can not withdraw");
    
    // disallowing employee to withdraw if employees withdrawable amount is 0
    if (empl.amount == 0) {
      empl.canWithdraw = false;
    }
    
    // transfering amount to employee and decreasing employees withdrawable amount by withdrawed amount
    payable(msg.sender).transfer(amount);
    empl.amount -= amount;
  }
  
  function viewAmount(address emplAddress) public view returns(uint) {
    Employee storage empl = employees[emplAddress];
    return empl.amount;
  }
}