// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "contracts/storageSlot/StorageSlot.sol";

contract StorageSlotTest is Test {
    StorageSlot storageSlot;

    function setUp() public {
        storageSlot = new StorageSlot();
    }

    function testGet() public {
        assertEq(storageSlot.get(0), 123);
        assertEq(storageSlot.get(1), 456);
        assertEq(storageSlot.get(2), 789);
    }

    function testSet(uint256 _value) public {
        vm.assume(_value < type(uint256).max / 2);

        storageSlot.set(0, _value);
        storageSlot.set(1, _value + 1);
        storageSlot.set(2, _value + 2);

        assertEq(storageSlot.get(0), _value);
        assertEq(storageSlot.get(1), _value + 1);
        assertEq(storageSlot.get(2), _value + 2);
    }
}
