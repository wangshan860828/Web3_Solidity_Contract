const { task } = require("hardhat/config");

task("interact-fundMe", "interact with FundMe contract")
.addParam("addr", "fundme contract address")
.setAction(async (taskArgs, hre) => {
    const fundMeFactory = await ethers.getContractFactory("FundMe")
    const fundMe = fundMeFactory.attach(taskArgs.addr)

    const owner = await fundMe.owner();
    console.log("FundMe Owner:", owner);

    const [firstAccount, secondAccount] = await ethers.getSigners();
    const fundMeWithFirstAccount = fundMe.connect(firstAccount);
    const fundMeWithSecondAccount = fundMe.connect(secondAccount);
    console.log("firstAccount:", firstAccount.address);
    console.log("secondAccount:", secondAccount.address);

    const fundTx1 = await fundMeWithFirstAccount.fund({ value: ethers.parseEther("1") });
    await fundTx1.wait();
    
    const fundTx2 = await fundMeWithSecondAccount.fund({ value: ethers.parseEther("2") });
    await fundTx2.wait();

    const balance = await ethers.provider.getBalance(fundMe.target);
    console.log("after secondAccount Balance:", balance);
});

  module.exports = {};