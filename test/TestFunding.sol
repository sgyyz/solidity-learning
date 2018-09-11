pragma solidity ^0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Funding.sol";

contract TestFunding {
  // setup the initial balance for contract in testing
  uint public initialBalance = 10 ether;

  function testSettingOwnerDuringCreation() public {
    Funding funding = new Funding();
    Assert.equal(funding.owner(), this, "An owner is different than a deployer.");
  }

  function testSettingOwnerofDeployedContract() public {
    Funding funding = Funding(DeployedAddresses.Funding());
    Assert.equal(funding.owner(), msg.sender, "And owner is different than a deployer.");
  }

  function testAcceptingDonations() public {
    Funding funding = new Funding();
    Assert.equal(funding.raised(), 0, "Initial raised amout is different than 0.");

    funding.donate.value(10 finney)();
    funding.donate.value(20 finney)();

    Assert.equal(funding.raised(), 30 finney, "Raised amount is different than sum of donation 30.");
  }

  function testTrackingDonationBalance() public {
    Funding funding = new Funding();

    funding.donate.value(5 finney)();
    funding.donate.value(15 finney)();

    Assert.equal(funding.balance(this), 20 finney, "Donate balance is different than sum of donation 20.");
  }
}