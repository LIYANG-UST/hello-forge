// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract Helper {
    function getFunc1Data(uint256 x) external pure returns (bytes memory) {
        return abi.encodeWithSelector(this.func1.selector, x);
    }

    function getFunc2Data() external pure returns (bytes memory) {
        return abi.encodeWithSelector(this.func2.selector);
    }

    function func1(uint256 _amount) external pure returns (uint256) {
        return _amount + 1;
    }

    function func2() external pure returns (uint256) {
        return 2;
    }
}
