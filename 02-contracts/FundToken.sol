// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract FundToken {
    string public tokenName; //通证名称
    string public tokenSymbol; //通证简介
    uint256 public totalSupply; //通证总数
    
    address public owner; //所有者
    
    mapping(address => uint256) public balances; //通证余额

    constructor(string memory _tokenName, string memory _tokenSymbol) {
        tokenName = _tokenName;
        tokenSymbol = _tokenSymbol;
        owner = msg.sender;
    }

    //铸造：给相应的用户增加 FT 数量
    function mint( uint256 amount) public {
        balances[msg.sender] += amount;
        totalSupply += amount;
    }

    //获取通证余额：查询用户的 FT 数量
    function getBalanceOf(address _address) public view returns (uint256) {
        return balances[_address];
    }

    //转移通证：将我名下的 FT 进行转移，只是做数量的增删操作
    function transferToken(address _address, uint256 _amount) public {
        require(balances[msg.sender] >= _amount, "you have no enough ");
        balances[msg.sender] -= _amount;
        balances[_address] += _amount;
    }

}