// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract HelperContractA {
    uint256 number;

    constructor(uint256 _number) {
        number = _number;
    }

    function getNumber() public view returns (uint256) {
        return number;
    }
}

contract HelperContractB {
    uint256 number;
    bool boolean;
    string name;

    constructor(
        uint256 _number,
        bool _boolean,
        string memory _name
    ) {
        number = _number;
        boolean = _boolean;
        name = _name;
    }

    function getName() public view returns (string memory) {
        return name;
    }

    function getNumber(bool isPlusOne) public view returns (uint256) {
        return isPlusOne == boolean ? number + 1 : number;
    }
}
