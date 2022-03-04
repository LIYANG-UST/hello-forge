// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./UseMultiDelegateCall.sol";

contract Helper {
    function getFunc1Data(uint256 x, uint256 y)
        external
        pure
        returns (bytes memory)
    {
        return
            abi.encodeWithSelector(UseMultiDelegateCall.func1.selector, x, y);
    }

    function getFunc2Data() external pure returns (bytes memory) {
        return abi.encodeWithSelector(UseMultiDelegateCall.func2.selector);
    }

    function getMintData() external pure returns (bytes memory) {
        return abi.encodeWithSelector(UseMultiDelegateCall.mint.selector);
    }
}
