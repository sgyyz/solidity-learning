pragma solidity ^0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/HelloWorld.sol";

contract TestHelloWorld {
  function testSayHello() public {
    HelloWorld instance = new HelloWorld();

    Assert.isTrue(compareString(instance.sayHello(), "Hello World"), "wrong greeting.");
  }

  function compareString(string memory a, bytes memory b) private pure returns (bool) {
    return keccak256(a) == keccak256(b);
  }
}