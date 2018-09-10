pragma solidity ^0.4.24;

contract SimpleStorage {
  uint private storedData;

  constructor() public {
    storedData = 1;
  }

  function set(uint x) public {
    storedData = x;
  }

  function get() public view returns (uint) {
    return storedData;
  }
}