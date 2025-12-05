# Hardhat 跨链 NFT 项目

本项目演示了一个使用 Chainlink CCIP 的跨链 NFT 解决方案。它允许 NFT 在不同的区块链网络之间转移。

## 问题与解决方案

### 问题
当编译合约时，出现以下错误：
```
Error HH411: The library @openzeppelin/contracts@5.0.2, imported from @chainlink/contracts-ccip/contracts/applications/CCIPReceiver.sol, is not installed. Try installing it using npm.
```

### 根本原因
Chainlink CCIP 合约使用了带版本号的 Solidity 导入语法：
```solidity
import {IERC165} from "@openzeppelin/contracts@5.0.2/utils/introspection/IERC165.sol";
```
这种语法（`@package@version`）在 Foundry 项目中使用，但 Hardhat 不直接支持。

### 解决方案
1. 创建 `CCIPReceiver.sol` 的本地副本，使用标准导入语法：
   ```solidity
   import {IERC165} from "@openzeppelin/contracts/utils/introspection/IERC165.sol";
   ```

2. 修改合约（`NFTBurnAndMintReciever.sol` 和 `NFTLockAndReleaseSender.sol`），从本地导入 CCIPReceiver：
   ```solidity
   import {CCIPReceiver} from "./CCIPReceiver.sol";
   ```

3. 安装别名包以确保依赖解析：
   ```bash
   pnpm add @openzeppelin/contracts-5.0.2@npm:@openzeppelin/contracts@5.0.2
   ```

### 结果
项目现在可以成功编译，包含全部 68 个 Solidity 文件。

## 使用方法

运行以下任务之一：

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat ignition deploy ./ignition/modules/Lock.js
```
