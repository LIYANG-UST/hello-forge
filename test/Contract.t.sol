// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.10;

import "ds-test/test.sol";

import "../src/Contract.sol";

interface Vm {
    function prank(address) external;

    function assume(bool) external;
}

contract Foo {
    function bar() external view {
        require(msg.sender == address(1), "wrong caller");
    }
}

contract ContractTest is DSTest {
    Vm vm = Vm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

    Contract myContract;
    Foo foo;

    function setUp() public {
        myContract = new Contract();
        foo = new Foo();
    }

    function testExample() public {
        assertTrue(true);
    }

    function testAdd() public {
        emit log_string("hello");
        assertEq(2 + 1, myContract.addOne(2));
    }

    function testAddOne(uint256 x) public {
        // Assume that x should be < 2^256 - 1
        // No overflow with vm.assume
        vm.assume(x < type(uint256).max);
        assertEq(x + 1, myContract.addOne(x));
    }

    function testBar() public {
        vm.prank(address(1));
        foo.bar();
    }
}
