pragma solidity ^0.4.24;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";

contract Funding is Ownable {
  using SafeMath for uint;

  uint public raised;
  uint public constant goal = 100 finney;
  mapping(address => uint) public balances;

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
}