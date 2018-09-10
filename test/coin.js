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
    await this.instance.mint(minter, 20);
    await this.instance.send(receiver, 3, {from: minter});

    let senderAmount = await this.instance.balances(minter);
    let receiverAmount = await this.instance.balances(receiver);

    assert.equal(senderAmount, 7, "send 3 out. 7 left.");
    assert.equal(receiverAmount, 3, "received 3.")
  });
});