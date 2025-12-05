// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract Students {
    struct Student {
        string name;
        uint8 age;
        uint256 number;
        address addr;
    }
    Student[] studentArray; 

    mapping(uint256=>Student) studentMapping;

    function setStudentToArray(string memory _name, uint8 _age, uint256 _number) public {
        Student memory student = Student(_name, _age, _number, msg.sender);
        studentArray.push(student);
    }

    function getStudentFromArray(uint256 _number) public view returns (Student memory) {
        for (uint i = 0; i < studentArray.length; i++) 
        {
            if (studentArray[i].number == _number) {
                return studentArray[i];
            }
        }
        revert("student not found in array");
    }
    
    function setStudentToMapping(string memory _name, uint8 _age, uint256 _number) public {
        studentMapping[_number] = Student(_name, _age, _number, msg.sender);
    }

    function getStudengFromMapping(uint256 _number) public view returns (Student memory) {
        if (studentMapping[_number].addr == address(0x0)) {
            revert("student not found in mapping");
        }
        return studentMapping[_number];
    } 
}
