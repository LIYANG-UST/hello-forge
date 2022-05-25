// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract MultiDelegateCall {
    error DelegateCallFailed();

    function multiDelegateCall(bytes[] calldata data)
        external
        payable
        returns (bytes[] memory results)
    {
        results = new bytes[](data.length);

        for (uint256 i; i < data.length; i++) {
            (bool success, bytes memory result) = address(this).delegatecall(
                data[i]
            );

            // require(success, "DelegateCallFailed");
            if (!success) {
                revert DelegateCallFailed();
            }

            results[i] = result;
        }
    }
}


