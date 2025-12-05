// 采用的是 hardhat 部署脚本的写法

const { ethers } = require("hardhat");

async function main() {
  const FundMe = await ethers.getContractFactory("FundMe");
  console.log("Deploying FundMe...");
  const fundMe = await FundMe.deploy(3000);
  await fundMe.waitForDeployment();
  console.log("FundMe deployed to:", fundMe.target);

  if (hre.network.config.chainId === 11155111 && process.env.ETHERSCAN_API_KEY) {
    console.log("Verifying contract on Etherscan...");
    await fundMe.deploymentTransaction.wait(5); // 等待5个区块确认
    await verify(fundMe.target, [3000]); 
  } else {
    console.log("Skipping Etherscan verification.");
  }

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
  
  /*
  const timestamp = Date.now();
  const Locker = await ethers.getContractFactory("Lock");
  console.log("Deploying Lock...");
  const lock = await Locker.deploy(timestamp + 3000);
  await lock.waitForDeployment();
  console.log("Lock deployed to:", lock.target);
  
  console.log("All deployments completed at timestamp:", Date.now());*/
}

main()
  .then()
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });