pragma solidity ^0.4.24;

contract Funding {
  address public owner;
  uint public raised;
  mapping(address => uint) public balance;

  constructor() public {
    owner = msg.sender;
  }

  function donate() public payable {
    balance[msg.sender] += msg.value;
    raised += msg.value;
  }
}