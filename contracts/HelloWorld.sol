pragma solidity ^0.4.24;

contract HelloWorld {
  string private constant GREETING = "Hello World";

  function sayHello() external pure returns(string) {
    return GREETING;
  }
}