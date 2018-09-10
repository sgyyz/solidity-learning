var SimpleStorage = artifacts.require("./SimpleStorage.sol");

contract('SimpleStorage', (accounts) => {
  
  beforeEach(async () => {
    this.instance = await SimpleStorage.deployed();
  });

  it('initialize simple storage contract', async () => {
    let storedData = await this.instance.get();

    assert.equal(storedData, 1, "Initial storedData is 1.");
  });

  it('set data', async () => {
    await this.instance.set(2);

    let storeData = await this.instance.get();

    assert.equal(storeData, 2, "Update storedData to 2.");
  });
});