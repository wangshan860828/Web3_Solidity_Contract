const { task } = require("hardhat/config");

task("deploy-fundMe", "Deploys the FundMe contract")
  .setAction(async (taskArgs, hre) => {
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
  });

  module.exports = {};