// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract MultiCall {
    function multicall(address[] calldata targets, bytes[] calldata data)
        external
        view
        returns (bytes[] memory)
    {
        require(targets.length == data.length, "different length");

        bytes[] memory results = new bytes[](data.length);

        for (uint256 i; i < targets.length; i++) {
            (bool success, bytes memory result) = targets[i].staticcall(
                data[i]
            );
            require(success, "failed");
            results[i] = result;
        }

        return results;
    }
}