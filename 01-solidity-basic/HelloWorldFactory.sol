// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import { HelloWorld } from "./HelloWorld.sol";

contract HelloWorldFactory {
    HelloWorld[] hwList;

    function createHelloWorld() public {
        HelloWorld hw = new HelloWorld();
        hwList.push(hw);
    }

    function sayHelloWorldFromFactory(uint256 _index) 
    public 
    view 
    returns (string memory) {
        return hwList[_index].sayHelloWorld();
    }

    function setHelloWorldFromFactory(uint256 _index, string memory _newString) 
    public 
    view 
    returns (string memory) {
        return hwList[_index].setHelloWorld(_newString);
    }
}