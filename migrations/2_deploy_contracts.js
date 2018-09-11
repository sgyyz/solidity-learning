var HelloWorld = artifacts.require("./HelloWorld.sol");
var SimpleStorage = artifacts.require("./SimpleStorage.sol");
var Coin = artifacts.require('./Coin.sol');
var Payment = artifacts.require('./Payment.sol');

module.exports = function(deployer) {
  deployer.deploy(HelloWorld);
  deployer.deploy(SimpleStorage);
  deployer.deploy(Coin);
  deployer.deploy(Payment);
};