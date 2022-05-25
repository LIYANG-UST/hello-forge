// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "contracts/timeLock/TimeLock.sol";
import "contracts/timeLock/Helper.sol";


contract TimeLockTest is Test {
    TimeLock public timeLock;
    Helper helper;

    // error NotOwner();

    address public constant alice = address(0x12);

    function setUp() public {
        timeLock = new TimeLock(alice);
        helper = new Helper();
    }

    function testOwner() public {
        assertEq(timeLock.owner(), alice);
    }

    function testGetTxId() public {
        address target = address(helper);
        uint256 value = 1 ether;
        string memory func = "func1(uint256)";
        bytes memory data = new bytes(0x10);
        uint256 timestamp = block.timestamp + 100;

        bytes32 IdFromTimeLock = timeLock.getTxId(
            target,
            value,
            func,
            data,
            timestamp
        );
        bytes32 ownId = keccak256(
            abi.encode(target, value, func, data, timestamp)
        );

        assertEq(IdFromTimeLock, ownId);
    }

    function testQueue() public {
        address target = address(helper);
        uint256 value = 1 ether;
        string memory func = "func1(uint256)";
        bytes memory data = new bytes(0x10);
        uint256 timestamp = block.timestamp + 100;

        bytes32 txId = timeLock.getTxId(target, value, func, data, timestamp);

        // called by alice and give alice 20 ether
        hoax(alice, 20 ether);
        timeLock.queue(target, value, func, data, timestamp);

        assertTrue(timeLock.queued(txId));

        // called by this contract will fail
        // NotOwner error selector manually calculated
        bytes4 selector_notOwner = bytes4(keccak256(bytes("NotOwner()")));
        vm.expectRevert(selector_notOwner);
        timeLock.queue(target, value, func, data, timestamp);
    }
}
