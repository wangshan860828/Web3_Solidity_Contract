require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
require("@chainlink/env-enc").config();
require("./tasks");
require('hardhat-deploy');

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  defaultNetwork: "hardhat",
  solidity: "0.8.28",
  networks: {
    ganache: {
      url: process.env.GANACHE_RPC_URL,
      chainId: 1337,
      accounts: [process.env.PRIVATE_KEY_1, process.env.PRIVATE_KEY_2],
    },
    sepolia: {
      url: process.env.SOPOLIA_RPC_URL,
      chainId: 11155111,
      accounts: [process.env.PRIVATE_KEY_1, process.env.PRIVATE_KEY_2], //替换成 sepolia 的私钥，加密
    },
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY, // 用于合约验证verify，加密
  },
  namedAccounts: {
    firstAccount: {
      default: 0,
    },
    secondAccount: {
      default: 1,
    },
  },
  gasReporter: {
    enabled: process.env.GAS_REPORTER === "true" ? true : false,
    currency: "USD",
    outputFile: "gas-report.txt",
    noColors: true,
    // coinmarketcap: process.env.COINMARKETCAP_API_KEY,
  },
};
