// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Test.sol";

import "contracts/multiCall/MultiCall.sol";
import "contracts/multiCall/Helper.sol";

contract MultiCallTest is DSTest {
    MultiCall multiCall;
    HelperContractA helperA;
    HelperContractB helperB;

    uint256 public constant NUMBER = 1;
    bool public constant BOOL = true;
    string public constant NAME = "alice";

    function setUp() public {
        multiCall = new MultiCall();

        helperA = new HelperContractA(NUMBER);
        helperB = new HelperContractB(NUMBER, BOOL, NAME);
    }

    function testMultiCall() public {
        bytes[] memory call_data = new bytes[](3);
        call_data[0] = abi.encodeWithSelector(helperA.getNumber.selector);
        call_data[1] = abi.encodeWithSelector(helperB.getName.selector);
        call_data[2] = abi.encodeWithSelector(helperB.getNumber.selector, BOOL);

        address[] memory targets = new address[](3);
        targets[0] = address(helperA);
        targets[1] = address(helperB);
        targets[2] = address(helperB);

        bytes[] memory res = multiCall.multicall(targets, call_data);

        uint256 res_1 = abi.decode(res[0], (uint256));
        string memory res_2 = abi.decode(res[1], (string));
        uint256 res_3 = abi.decode(res[2], (uint256));

        assertEq(res_1, NUMBER);
        assertEq(res_2, NAME);
        assertEq(res_3, NUMBER + 1);
    }
}
