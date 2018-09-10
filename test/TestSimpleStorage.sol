pragma solidity ^0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/SimpleStorage.sol";

contract TestSimpleStorage {
  function testIntialSimpleStorage() public {
    SimpleStorage instance = new SimpleStorage();

    uint expectedStoredData = 1;

    Assert.equal(instance.get(), expectedStoredData, "Intial Simple Storage with stored data: 1.");
  }

  function testGetDeployedSimpleStorage() public {
    SimpleStorage instance = SimpleStorage(DeployedAddresses.SimpleStorage());

    uint expectedStoredData = 1;

    Assert.equal(instance.get(), expectedStoredData, "Intial Simple Storage with stored data: 1.");
  }

  function testSetMethod() public {
    SimpleStorage instance = SimpleStorage(DeployedAddresses.SimpleStorage());
    instance.set(2);

    uint expectedStoredData = 2;

    Assert.equal(instance.get(), expectedStoredData, "Set stored data to 2.");
  }
}