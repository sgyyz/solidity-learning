const Funding = artifacts.require("Funding");

const FINNEY = 10**15;

contract("Funding", accounts => {
  const [firstAccount, secondAccount] = accounts;

  it("set an owner", async () => {
    const funding = await Funding.new();
    assert.equal(await funding.owner.call(), firstAccount);
  });

  it("accept donations", async () => {
    const funding = await Funding.new();

    await funding.donate({from: firstAccount, value: 10 * FINNEY});
    await funding.donate({from: secondAccount, value: 20 * FINNEY});

    assert.equal(await funding.raised.call(), 30 * FINNEY);
  });

  it("keep track of donator balance", async () => {
    const funding = await Funding.new();

    await funding.donate({from: firstAccount, value: 10 * FINNEY});
    await funding.donate({from: secondAccount, value: 20 * FINNEY});
    await funding.donate({from: secondAccount, value: 30 * FINNEY});

    assert.equal(await funding.balances.call(firstAccount), 10 * FINNEY);
    assert.equal(await funding.balances.call(secondAccount), 50 * FINNEY);
  });

  it("Donate is not allowed due to less than limitation", async () => {
    const funding = await Funding.new();

    try {
      await funding.donate({from: firstAccount, value: 0.5 * FINNEY});
      assert.fail();
    } catch (error) {
      assert.ok(/revert/.test(error.message));
    }
  });

  it("owner withdraw when goal reach.", async () => {
    const funding = await Funding.new();

    await funding.donate({from: firstAccount, value: 30 * FINNEY});
    await funding.donate({from: secondAccount, value: 70 * FINNEY});

    const initBalance = web3.eth.getBalance(firstAccount);
    assert.equal(web3.eth.getBalance(funding.address), 100 * FINNEY);

    await funding.withdraw();

    const finalBalance = web3.eth.getBalance(firstAccount);
    assert.ok(finalBalance.greaterThan(initBalance));
  });

  it("non owner withdraw when goal reach", async () => {
    const funding = await Funding.new({from: secondAccount});
    await funding.donate({from: firstAccount, value: 100 * FINNEY});

    try {
      await funding.withdraw();
      assert.fail();
    } catch (error) {
      assert.ok(/revert/.test(error.message));
    }
  });

  it("Refund failed due to balance is 0", async () => {
    const funding = await Funding.new({from: firstAccount});
    try {
      await funding.refund({from: secondAccount});
      assert.fail();
    } catch (error) {
      assert.ok(/revert/.test(error.message));
    }
  });

  it("Refund success.", async () => {
    const funding = await Funding.new({from: firstAccount});
    const initialBalance = web3.eth.getBalance(secondAccount);

    await funding.donate({from: secondAccount, value: 10 * FINNEY});
    await funding.refund({from: secondAccount});
    
    const finalBalance = web3.eth.getBalance(secondAccount);
    assert.ok(initialBalance.greaterThan(finalBalance));
  });
});