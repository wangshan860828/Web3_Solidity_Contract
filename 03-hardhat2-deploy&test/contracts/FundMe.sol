// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

//预言机的功能主要是用来从线下获取ETH和USD之间的汇率
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    mapping(address => uint256) public fundersToAmount; //存放付款人的地址和金额
    address[] internal funders;
    address public owner;
    uint internal constant MINIMUM = 1 * 10 ** 18; //单位是eth
    uint internal constant TARGET = 2 * 10 ** 18;

    string private stringTest = "FundMe";

    AggregatorV3Interface internal dataFeed;

    //添加锁定期
    uint public lockTimePeriod; //单位是秒，锁定期
    uint public deployTimeStamp; //合约部署时候的时间，也就是募集资金开始的时间

    bool public getFundSuccess = false; //ERC20 添加的内容，判断众筹是否结束
    address erc20Addr; //ERC20合约的地址

    constructor(uint256 _lockTimePeriod) {
        owner = msg.sender;
        dataFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        deployTimeStamp = block.timestamp;
        lockTimePeriod = _lockTimePeriod;
    }

    //收款函数，参与众筹的人员和金额，fundersToAmount中记录了参与人和金额的对应关系
    function fund() public payable {
        require(msg.value >= MINIMUM, "need more eth");
        fundersToAmount[msg.sender] = msg.value;
        funders.push(msg.sender);
    }

    //用于查看具体的众筹人员和金额
    function getAllFunders() internal view returns (address[] memory, uint256[] memory) {
        uint256[] memory amounts = new uint256[](funders.length);
        for (uint i = 0; i < funders.length; i++) {
            amounts[i] = fundersToAmount[funders[i]];
        }
        return (funders, amounts);
    }

    function getFunderBalance(address _address) public view returns (uint256) {
        return fundersToAmount[_address];
    }

    //转移 owner 关系
    function changeOwnerShip(address newAddress) public {
        require(msg.sender == owner, "you are not owner");
        owner = newAddress;
    }

    /** 这个函数具体是什么意思？ETH 和 USD之间的转换逻辑是什么？
   * Returns the latest answer.
   //预言机内容，无 sepolia 测试币，先注释
   */
  function getChainlinkDataFeedLatestAnswer() public view returns (int256) {
    // prettier-ignore
    (
      /* uint80 roundId */
      ,
      int256 answer,
      /*uint256 startedAt*/
      ,
      /*uint256 updatedAt*/
      ,
      /*uint80 answeredInRound*/
    ) = dataFeed.latestRoundData();
    return answer;
  }

    //预言机内容，无 sepolia 测试币，先注释，主要功能是将 eth转成usd
    function convertEthToUsd(uint ethAmounts) internal view returns (uint256) {
        uint256 ethPrice = uint256(getChainlinkDataFeedLatestAnswer());
        return ethAmounts * ethPrice / 10**8;
    }

    function addStringTest(string memory newString) internal view returns (string memory) {
        return string.concat(stringTest, newString);
    }

    //提款函数（合约的所有者owner）
    //address(this).balance //提款额
    //转账的三个函数（transfer，send，call）
    function getFund() public onlyOwner {
        require(address(this).balance >= TARGET, "Not enough fund");
        require(deployTimeStamp + lockTimePeriod < block.timestamp, "Funds are locked");
        (bool success,  ) = payable(owner).call{value: address(this).balance}("");
        require(success, "Failed to call");
        getFundSuccess = true;
    }

    function getFundFromCall(string memory param) public onlyOwner returns (string memory) {
        require(address(this).balance >= TARGET, "Not enough fund");
        (bool success, bytes memory data) = payable(owner).call{
             value: address(this).balance
        }(
            abi.encodeWithSignature("addStringTest(string)", param)
        );

        require(success, "Failed to call");
        return abi.decode(data, (string));
    }

    function getFundFromTransfer() public onlyOwner {
        require(address(this).balance >= TARGET, "Not enough fund transfer");
        payable(owner).transfer(address(this).balance);
    }

    function getFundFromSend() public onlyOwner {
        require(address(this).balance >= TARGET, "Not enough fund send");
        bool success = payable(owner).send(address(this).balance);
        require(success, "Failed to send");
    }

    //退款函数（投资人）
    function refund() public inLockTime {
        //退款金额：fundersToAmount[msg.sender]
        require(fundersToAmount[msg.sender] > 0, "No fund to refund");
        require(address(this).balance < TARGET, "Fund target not reached");
        //退款的 3 种方式
        // payable(msg.sender).transfer(fundersToAmount[msg.sender]);
        // payable(msg.sender).send(fundersToAmount[msg.sender]);
        (bool success, ) = payable(msg.sender).call{value: fundersToAmount[msg.sender]}("");
        require(success, "Failed to refund");
        fundersToAmount[msg.sender] = 0;
    }

    //修改器 控制owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call");
        _;
    }
    //修改器 控制锁定期
    modifier inLockTime() {
        require(deployTimeStamp + lockTimePeriod < block.timestamp, "Funds are locked");
        _;
    }

    //ERC20 添加的内容，从外部设置 ERC20 合约部署的地址
    function setErc20Addr(address _erc20Addr) external onlyOwner {
        erc20Addr = _erc20Addr;
    }

    //ERC20 添加的内容，用于设置相应用户的 amount
    function setFunderToAmount(address funder, uint256 amountToUpdate) external {
        require(msg.sender == erc20Addr, "you do not have permission to call this funtion");
        fundersToAmount[funder] = amountToUpdate;
    }
}