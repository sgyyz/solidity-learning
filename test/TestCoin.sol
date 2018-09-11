pragma solidity ^0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Coin.sol";

contract TestCoin {
  address constant public minter = 0x627306090abaB3A6e1400e9345bC60c78a8BEf57;
  address constant public receiver = 0xf17f52151EbEF6C7334FAD080c5704D77216b732;
  address constant public other = 0xC5fdf4076b8F3A5357c5E395ab970B5B54098Fef;
  
  function testMint() public {
    Coin coin = new Coin();

    coin.mint(receiver, 5);

    uint expectedAmount = 5;
    Assert.equal(coin.balances(receiver), expectedAmount, "Receiver should get 5 amounts.");
  }
}