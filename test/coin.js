var Coin = artifacts.require("./Coin.sol");

contract("Coin", ([minter, receiver, other]) => {
  beforeEach(async () => {
    this.instance = await Coin.new();
  });

  it("Intial verification", async () => {
    let minterAmount = await this.instance.balances(minter);

    let expectedAmount = 0;

    assert.equal(minterAmount, expectedAmount, "Initial minter does not have any amount.");
  });

  it("Receiver mint 5 amount tokens", async () => {
    await this.instance.mint(receiver, 5, {from: minter});

    // check the result
    let receiverAmount = await this.instance.balances(receiver);

    let expectedAmount = 5;

    assert.equal(receiverAmount, expectedAmount, "Mint 5 amount tokens.");
    
  });

  it("Receiver mint 5 amount tokens by himself failed", async () => {
    await this.instance.mint(receiver, 5, {from: receiver});

    // check the result
    let receiverAmount = await this.instance.balances(receiver);

    let expectedAmount = 0;

    assert.equal(receiverAmount, expectedAmount, "Mint 5 amount tokens.");
  });

  it("Receiver sent 3 amount to other", async () => {
    await this.instance.mint(receiver, 10);
    await this.instance.sendAmount(other, 3, {from: receiver});

    let receiverAmountBalance = await this.instance.balances(receiver);
    let otherAmountBalance = await this.instance.balances(other);

    assert.equal(receiverAmountBalance, 7, "send 3 out. 7 left.");
    assert.equal(otherAmountBalance, 3, "received 3.")
  });

  it("Receiver does not have enough amount to send", async () => {
    await this.instance.mint(receiver, 10);
    await this.instance.sendAmount(other, 20, {from: receiver});

    let receiverAmountBalance = await this.instance.balances(receiver);
    let otherAmountBalance = await this.instance.balances(other);

    assert.equal(receiverAmountBalance, 10, "Receiver still has 10.");
    assert.equal(otherAmountBalance, 0, "Other does not have any number.");
  });
});