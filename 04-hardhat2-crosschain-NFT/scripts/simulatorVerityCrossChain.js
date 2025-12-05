const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();

  //部署MyToken合约
  const MyToken = await ethers.getContractFactory("MyToken");
  const myToken = await MyToken.deploy("MyToken", "MTK"); // 修正：MyToken 构造函数只接受两个参数
  await myToken.waitForDeployment();
  console.log("MyToken deployed to:", myToken.target);

  //从 CCIPSimulator 获取相关信息
  const CCIPSimulator = await ethers.getContractFactory("CCIPSimulator");
  const ccipSimulator = await CCIPSimulator.deploy();
  await ccipSimulator.waitForDeployment(); // 确保合约部署完成
  console.log("CCIPSimulator deployed to:", ccipSimulator.target);

  const config = await ccipSimulator.configuration();
  // 给下面变量添加注释，说明每个变量的含义
  const {
    chainSelector_, // 链选择器
    sourceRouter_, // 源链路由合约
    destinationRouter_, // 目的链路由合约
    wrappedNative_, // 包装的本地.native 代币
    linkToken_, // LINK 代币
    ccipBnM_, // ccipBnM 代币
    ccipLnM_, // ccipLnM 代币
  } = config;
  console.log("chainSelector_:", chainSelector_);
  console.log("sourceRouter_:", sourceRouter_);
  console.log("destinationRouter_:", destinationRouter_);
  console.log("wrappedNative_:", wrappedNative_);
  console.log("linkToken_:", linkToken_);
  console.log("ccipBnM_:", ccipBnM_);
  console.log("ccipLnM_:", ccipLnM_);

  //部署 NFTLockAndRelease 合约
//   const NFTLockAndRelease = await ethers.getContractFactory("NFTLockAndRelease");
//   const nftLockAndRelease = await NFTLockAndRelease.deploy(
//     sourceRouter_, // 源链路由合约
//     linkToken_, // LINK 代币
//     myToken.target
//   );
//   await nftLockAndRelease.waitForDeployment();
//   console.log("NFTLockAndRelease deployed to:", nftLockAndRelease.target);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {   
    console.error(error.message);
    process.exit(1);
  });