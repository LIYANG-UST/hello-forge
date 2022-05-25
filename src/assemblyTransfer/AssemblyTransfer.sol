// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import {TokenTransferErrors} from "./TokenTransferErrors.sol";
import "./AssemblyTransferConstants.sol";

// Ref to seaport ()

contract AssemblyTransfer is TokenTransferErrors {
    function _ERC20Transfer(
        address _token,
        address _from,
        address _to,
        uint256 _amount
    ) internal {
        assembly {
            let freeMemPointer := mload(FreeMemoryPointer)

            // Prepare calldata to be sent
            mstore(ERC20_transferFrom_sig_ptr, ERC20_transferFrom_signature)
            mstore(ERC20_transferFrom_from_ptr, _from)
            mstore(ERC20_transferFrom_to_ptr, _to)
            mstore(ERC20_transferFrom_amount_ptr, _amount)

            let callStatus := call(
                gas(), // gas
                _token, // address to call
                0, // msg.value
                ERC20_transferFrom_sig_ptr, // calldata offset (start from 0)
                ERC20_transferFrom_length, // calldata length
                0, // return data offset
                OneWord // return data size (return type of ERC20.transferFrom is bool)
            )

            // Check the call is successful
            // Scenes:
            //   return data size == 0, callStatus is 0 => false (this call itself failed)
            //   return data size >= 32, return data == true, callStatus is 1 => true (call success and transferFrom succeeded)
            //   return data size >= 32, return data == false, callStatus is 1 => false (call success but transferFrom failed)
            let success := and(
                or(
                    // load value at 0 (where the return value is stored)
                    // check if the return value is 1 (true)
                    // check if the latest return data size is > 31
                    // condition A: return true && return data size > 31
                    // condition B:  return data size == 0
                    // result = A || B
                    and(eq(mload(0), 1), gt(returndatasize(), 31)),
                    iszero(returndatasize())
                ),
                // when call success, the callStatus is 1, otherwise 0
                callStatus
            )
        }
    }
}
