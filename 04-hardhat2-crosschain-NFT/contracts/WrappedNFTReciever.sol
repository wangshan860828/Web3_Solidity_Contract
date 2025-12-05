// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./MyToken.sol";

contract WrappedNFTReciever is MyToken {
    constructor(string memory name, string memory symbol) MyToken(name, symbol) {}

    function mint(address to, uint256 tokenId) public {
        _safeMint(to, tokenId);
    }
}