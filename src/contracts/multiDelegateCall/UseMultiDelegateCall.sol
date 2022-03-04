// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./MultiDelegateCall.sol";

contract UseMultiDelegateCall is MultiDelegateCall {
    event Log(address caller, string func, uint256 i);

    function func1(uint256 x, uint256 y) external {
        // msg.sender = alice
        emit Log(msg.sender, "func1", x + y);
    }

    function func2() external returns (uint256) {
        // msg.sender = alice
        emit Log(msg.sender, "func2", 2);
        return 111;
    }

    mapping(address => uint256) public balanceOf;

    // WARNING: unsafe code when used in combination with multi-delegatecall
    // user can mint multiple times for the price of msg.value
    function mint() external payable {
        balanceOf[msg.sender] += msg.value;
    }
}
