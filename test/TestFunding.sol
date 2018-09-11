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

    Assert.equal(funding.balances(this), 20 finney, "Donate balance is different than sum of donation 20.");
  }

  function testDonatingLessThanLimit() public {
    Funding funding = new Funding();

    bool result = address(funding).call.value(1 finney)(bytes4(keccak256("donate()")));

    Assert.equal(result, false, "Allow donate more than 1 finney.");
  }

  function testWithdrawByAnOwnerFailed() public {
    Funding funding = new Funding();

    funding.donate.value(50 finney)();
    bool result = address(funding).call(bytes4(keccak256("withdraw()")));
    Assert.equal(result, false, "Allows for withdraw before reaching the goal.");
  }

  function testWithdrawByAnOwnerSuccess() public {
    Funding funding = new Funding();

    uint initBalance = address(this).balance;

    funding.donate.value(50 finney)();
    bool result = address(funding).call(bytes4(keccak256("withdraw()")));
    Assert.equal(result, false, "Allows for withdrawal before reaching the goal");

    funding.donate.value(50 finney)();
    Assert.equal(address(this).balance, initBalance - 100 finney, "Balance before withdrawal doesn't correspond to the sum of donations");
    
    bool result1 = address(funding).call(bytes4(keccak256("withdraw()")));
    Assert.equal(result1, true, "Doesn't allow for withdrawal after reaching the goal");
    Assert.equal(address(this).balance, initBalance, "Balance after withdrawal doesn't correspond to the sum of donations");
  }

  function testWithdrawByNotAnOwner() public {
    Funding funding = Funding(DeployedAddresses.Funding());
    funding.donate.value(100 finney)();

    bool result = address(funding).call(bytes4(keccak256("withdraw()")));
    Assert.equal(result, false, "Only allow owner do the withdraw.");
  }
}