// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import { FundMe } from "./FundMe.sol";

contract FundTokenERC20 is ERC20 {

    FundMe public fundMe;

    constructor() ERC20("FundToken", "FTTest") {
        fundMe = new FundMe(30);
    }

    function mint(uint256 amountToMint) public {
        require(fundMe.fundersToAmount(msg.sender) >= amountToMint,"you have no enough value");
        // 当众筹结束，owner 提款成功后，才会 mint
        require(fundMe.getFundSuccess() == true, "fund not success");
        _mint(msg.sender, amountToMint);
        fundMe.setFunderToAmount(msg.sender, fundMe.fundersToAmount(msg.sender) - amountToMint);
    }

    function claim(uint256 amountToClaim) public {
        require(balanceOf(msg.sender) >= amountToClaim, "you have no enough token");
        require(fundMe.getFundSuccess(), "fund not success");
        _burn(msg.sender, amountToClaim);
    }

}