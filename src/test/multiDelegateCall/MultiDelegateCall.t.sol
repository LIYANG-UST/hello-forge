// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "ds-test/test.sol";

import "forge-std/stdLib.sol";
import "forge-std/Vm.sol";

import "contracts/multiDelegateCall/UseMultiDelegateCall.sol";
import "contracts/multiDelegateCall/Helper.sol";

// interface Vm {
//     function warp(uint256 x) external;

//     function expectEmit(
//         bool,
//         bool,
//         bool,
//         bool
//     ) external;
// }

contract MultiDelegateCallTest is DSTest {
    // Vm vm = Vm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);
    Vm public constant vm = Vm(HEVM_ADDRESS);

    UseMultiDelegateCall multiDelegateCall;
    Helper helper;

    bytes data_func1;
    bytes data_func2;
    bytes data_mint;

    event Log(address caller, string func, uint256 i);

    function setUp() public {
        multiDelegateCall = new UseMultiDelegateCall();
        helper = new Helper();

        data_func1 = helper.getFunc1Data(1, 1);
        data_func2 = helper.getFunc2Data();
        data_mint = helper.getMintData();
    }

    function testMultiCall() public {
        bytes[] memory call_data = new bytes[](2);
        call_data[0] = data_func1;
        call_data[1] = data_func2;

        vm.expectEmit(true, false, false, true);

        emit Log(address(this), "func1", 2);
        emit Log(address(this), "func2", 2);
        multiDelegateCall.multiDelegateCall(call_data);
    }

    function testMultiCallMint() public {
        bytes[] memory call_data = new bytes[](3);
        call_data[0] = data_mint;
        call_data[1] = data_mint;
        call_data[2] = data_mint;

        multiDelegateCall.multiDelegateCall{value: 1 ether}(call_data);

        assertEq(multiDelegateCall.balanceOf(address(this)), 3 ether);
    }
}
