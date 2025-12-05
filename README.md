# Solidity 学习笔记
## 1. 初始化 Hardhat 项目
npx hardhat --init

## 2. 编译合约
npx hardhat compile

## 3. 部署合约
npx hardhat run scripts/deployFundMe.js --network rinkeby
npx hardhat run scripts/deployFundMe.js

### 3.1 部署到ganache
npx hardhat run scripts/deployFundMe.js --network ganache

## 4. 测试合约
npx hardhat test

## 5. 运行本地节点
npx hardhat node

# 工程技术栈和架构
## 02-contracts
  - FundMe.sol 众筹合约
  - 技术栈：
    1. 预言机：chainlink 的喂价合约：AggregatorV3Interface（主要用来查询 ETH 和 USD 的汇率）
   
## 03-hardhat2-deploy&test
  - 技术栈：hardhat2: js 和 CommonJS模块
  - 测试网：ganache
    1. hardhat 工程中添加 ganache 配置，在 hardhat.config.js 文件中 network 配置 ganache 的相关信息
    2. 利用 @chainlink/env-enc 工具加密存储敏感信息
       1. Install @chainlink/env-enc from pnpm or npm
       2. js 中添加 require("@chainlink/env-enc").config();
       3. 终端运行 npx env-enc set-pw , 输入密码后工程中自动创建 .env.enc 文件
       4. 终端运行 npx env-enc set，中.env.enc 文件中设置键值对
       5. 终端运行 npx env-enc view，明文查看.env.enc中内容
       6. 终端运行 npx env-enc remove <name>，删除某一个键值对
       7. 终端运行 npx env-enc remove-all，删除所有的键值对
       8. 应用的时候跟.env 文件一样，使用 process.env.<name> 获取，例如：process.env.PRIVATE_KEY_1
    3. 部署脚本，采用 hardhat ether 脚本的方式部署
       - 运行：npx hardhat run scripts/deployFundMe.js --network ganache
  - task 的创建，在 tasks 的文件夹下，操作步骤：
    1. 创建 task的内容
    2. 在 index.js 文件中导出
    3. 在hardhat.config.js 文件中注册
    4. 最后操作：
       - 无参数：npx hardhat deploy-fundMe --network ganache
       - 有参数：npx hardhat interact-fundMe --addr 0x5Fa54F9605Acc8D960f32E6e7F3F897D0bfD4893 --network ganache
  - 采用 mocha 和 chai 单元测试
    1. 采用 hardhat 自带的网络部署， npx hardhat test test/unit/fundMe.test.js
    2. 采用 hardhat-deploy 插件来部署 [官方文档：https://v2.hardhat.org/hardhat-runner/plugins]
  - **`接下来的工作`**
    1. 在 deploy 文件夹下面分别用 hardhat-deploy 部署 FundMe 和 mock 合约
    2. 在fundMe.test.js 中写 FundMe.sol 合约的单元测试
   
## 04-hardhat2-crosschain-nft
  - 基于 03 工程扩展开发 NFT 和 跨链 功能，技术栈跟 03 工程保持一致。
  - ERC721 NTF 合约的创建
    1. [官方网站：https://wizard.openzeppelin.com/#erc721] 可视化创建 ERC721 myToken
    2. 将创建好的文件下载下来添加到我们工程的 contracts 文件夹下面
  - 创建自己的 NFT 托管到 IPFS(去中心化存储服务)
    1. [官方网站：https://console.filebase.com/buckets]中创建 NFT 的元数据：metadata (付费)
    2. [官方网站：https://app.pinata.cloud/auth/signin] （免费）
  - 在 pinata 网站上面上传 image 并生成相应的 json 文件，利用 ganache 和 metaMask 测试 NFT 的部署，铸造和查看
    1. 已在 pinata 官网注册账号，并上传 public files，获得 
       - json 文件的 CID: bafkreihcury7kwckorxylt2q3p5vkhafgerij6tvxk6pwqyuldpzfvoo7i
    2. 修改 MyToken.sol，将数据源换成 pinata 的测试数据，这样 NFT 的合约代码就完成了
  - 部署和铸造 NFT 合约到 ganache 网络和账号上，并通过 metaMask 查看 
    1. 在 scripts 文件夹下面用 deployMyTokenToGanache.js 部署 MyToken 到 ganache 网络和账号上
    2. 然后在 metaMask 中导入 NFT，选择 ganache 的网络地址，输入地址（代码中 `myToken.target`）和代币 ID （代码中 `myToken.tokenId`）
    3. 以上操作正确后，即可在 metaMask 中查看到 NFT 的信息
  - 实现 NFT 合约的跨链功能，利用 chainlink CCIP[官方网站：https://docs.chain.link/ccip/tutorials/evm/send-arbitrary-data-receipt-acknowledgment] 的跨链功能，实现 NFT 在不同链上的交互
    1. CCIP 模拟器：[官方网站：https://github.com/smartcontractkit/chainlink-local]
    2. 安装`@chainlink/contracts-ccip` 和 `@chainlink/local`
   
       
