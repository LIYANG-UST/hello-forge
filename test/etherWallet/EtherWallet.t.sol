// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "contracts/etherWallet/EtherWallet.sol";

contract EtherWalletTest is Test {
    EtherWallet wallet;

    event Withdraw(address receiver, uint256 amount);

    uint256 constant MAX_UINT = type(uint256).max;

    address constant ALICE = address(0x12);

    function setUp() public {
        wallet = new EtherWallet();
    }

    function testOwner() public {
        assertEq(wallet.owner(), address(this));
    }

    function testGetBalance(uint256 _amount) public {
        uint256 balance = address(this).balance;
        vm.assume(_amount < balance);

        payable(address(wallet)).transfer(_amount);

        assertEq(wallet.getBalance(), _amount);
    }

    function testWithdraw(uint256 _amount) public {
        uint256 balance = address(this).balance;
        vm.assume(_amount < balance);

        payable(address(wallet)).transfer(_amount);

        vm.expectEmit(false, false, false, true);
        emit Withdraw(ALICE, _amount / 2);
        wallet.withdraw(ALICE, _amount / 2);

        assertEq(address(ALICE).balance, _amount / 2);
    }
}
