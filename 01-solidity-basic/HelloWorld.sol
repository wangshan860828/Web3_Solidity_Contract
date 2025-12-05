// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract HelloWorld {
    string stringVar = "Hello World";

    function getString() public view returns (string memory) {
        return stringVar;
    }

    function updateString(string memory newString) public view returns (string memory) {
        return string.concat(stringVar, newString, "hhhh");
    }

    function updateString2(string memory newString) public pure returns (string memory) {
        return string.concat(newString, "hhhh pure");
    }

    function sayHelloWorld() public view returns (string memory) {
        return stringVar;
    }

    function setHelloWorld(string memory _newString) public pure returns (string memory) {
        return updateString2(_newString);
    }
}

