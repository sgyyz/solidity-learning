pragma solidity ^0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Funding.sol";

contract TestFunding {
  // setup the initial balance for contract in testing
  uint public initialBalance = 10 ether;

  // this is used to receive money as the default fall back
  // like the funding contract transfer balance back to this contract, it just call `transfer` method,
  // and there is no payable metho in TestContract to receive money, 
  // so we should define a payable default method to receive it.
  function() public payable {}

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

    // donate 100 finney
    funding.donate.value(100 finney)();
    Assert.equal(address(this).balance, initBalance - 100 finney, "Balance before withdrawal doesn't correspond to the sum of donations");
    Assert.equal(address(funding).balance, 100 finney, "aaa");

    // withdraw
    bool result = address(funding).call(bytes4(keccak256("withdraw()")));
    Assert.equal(result, true, "Allows for withdrawal before reaching the goal");
    Assert.equal(address(this).balance, initBalance, "Balance after withdrawal doesn't correspond to the sum of donations");
  }

  function testWithdrawByNotAnOwner() public {
    Funding funding = Funding(DeployedAddresses.Funding());
    funding.donate.value(100 finney)();

    bool result = address(funding).call(bytes4(keccak256("withdraw()")));
    Assert.equal(result, false, "Only allow owner do the withdraw.");
  }

  function testRefundZeroFailed() public {
    Funding funding = new Funding();

    bool result = address(funding).call(bytes4(keccak256("refund()")));
    Assert.equal(result, false, "Refund 0 should fail.");
  }

  function testRefundSuccess() public {
    Funding funding = new Funding();

    uint initBalance = address(this).balance;
    funding.donate.value(100 finney)();
    Assert.equal(address(this).balance, initBalance - 100 finney, "Donate failed.");

    bool result = address(funding).call(bytes4(keccak256("refund()")));
    Assert.equal(result, true, "Refund 0 should fail."); 
    Assert.equal(address(this).balance, initBalance, "After refund, balance should be same as initial.");
  }
}