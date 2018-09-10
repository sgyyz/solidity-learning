var HelloWolrd = artifacts.require("./HelloWorld.sol");

contract('HelloWorld', (accounts) => {
  it("Say hello correct.", async () => {
    let instance = await HelloWolrd.deployed();
    let greeting = await instance.sayHello();

    var expectedGreeting = 'Hello World';

    assert.equal(greeting, expectedGreeting);
  });
});