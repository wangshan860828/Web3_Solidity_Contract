// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@chainlink/local/src/ccip/CCIPLocalSimulator.sol";

// 继承CCIPLocalSimulator以使其能在脚本中部署
contract CCIPSimulator is CCIPLocalSimulator {
    constructor() CCIPLocalSimulator() {}
}
