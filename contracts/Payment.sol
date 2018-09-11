pragma solidity ^0.4.24;

contract Payment {
  uint public totalContribution;
  mapping(address => uint) public contributions;

  event Contribution(address indexed from, uint amount);

  function contribute() public payable returns(bool) {
    require(msg.sender != address(0), "Invalid address.");

    contributions[msg.sender] += msg.value;
    totalContribution += msg.value;

    emit Contribution(msg.sender, msg.value);
  }
}