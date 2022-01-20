// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.10;

import "ds-test/test.sol";

import "../Contract.sol";

contract ContractTest is DSTest {
    Contract myContract;

    function setUp() public {
        myContract = new Contract();
    }

    function testExample() public {
        assertTrue(true);
    }

    function testAddOne(uint256 x) public {
        emit log_string("hello");
        assertEq(x + 1, myContract.addOne(x));
    }
}
