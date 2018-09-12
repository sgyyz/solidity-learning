pragma solidity ^0.4.24;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";

contract Funding is Ownable {
  using SafeMath for uint;

  uint public raised;
  uint public constant goal = 100 finney;
  mapping(address => uint) public balances;

  event RefundSuccess(address indexed refundAddress, uint amount);

  modifier donateLimitation() {
    require(msg.value > 1 finney, "At least over 1 finney.");
    _;
  }

  modifier onlyFunded() {
    require(isFunded(), "Raise does not reach goal.");
    _;
  }

  function isFunded() public view returns (bool) {
    return raised >= goal;
  }

  function donate() public 
    donateLimitation 
    payable 
  {
    balances[msg.sender] = balances[msg.sender].add(msg.value);
    raised = raised.add(msg.value);
  }

  function withdraw() public onlyOwner onlyFunded {
    owner.transfer(address(this).balance);
  }

  function refund() public {
    uint amount = balances[msg.sender];
    require(amount > 0, "account doens't have any balance.");

    balances[msg.sender] = 0;
    raised = raised.sub(amount);
    msg.sender.transfer(amount);
    emit RefundSuccess(msg.sender, amount);
  }
}