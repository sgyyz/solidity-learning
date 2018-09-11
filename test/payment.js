const FINNEY = 10**15;

var Payment = artifacts.require("./Payment.sol");

contract("Payment", (accounts) => {
  it("Contribute 2 ether to Payment contract.", async () => {
    let instance = await Payment.deployed();

    await instance.contribute({from: accounts[0], value: 10 * FINNEY});
    await instance.contribute({from: accounts[1], value: 20 * FINNEY});

    let expectedAccount1Contribution = 10 * FINNEY;
    assert.equal(await instance.contributions(accounts[0]), expectedAccount1Contribution);

    let expectedAccount2Contribution = 20 * FINNEY;
    assert.equal(await instance.contributions(accounts[1]), expectedAccount2Contribution);

    let expectedTotalContribution = 30 * FINNEY;
    assert.equal(await instance.totalContribution(), expectedTotalContribution);
  });
});