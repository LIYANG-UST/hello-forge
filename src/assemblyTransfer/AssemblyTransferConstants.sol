// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

// one word size = 32 bytes
uint256 constant OneWord = 0x20;
uint256 constant TwoWords = 0x40;
uint256 constant ThreeWords = 0x60;

// Memory place that points to the start of free memory
// If you want to allocate memory, use the memory starting from where this pointer points at and update it
// E.g.  Memory status
//     0x11111...111000000000000000000000000000
//                  ↑
//         start of free memory (position = x)
//         => The value of memory position 0x40 = x
uint256 constant FreeMemoryPointer = 0x40;

// The first 64 bytes of memory can be used as “scratch space” for short-term allocation
// The 32 bytes after the free memory pointer (i.e., starting at 0x60) are meant to be zero permanently
// and is used as the initial value for empty dynamic memory arrays
uint256 constant ZeroSlot = 0x60;

// The allocatable memory starts at 0x80, which is the initial value of the free memory pointer
uint256 constant DefaultFreeMemoryPointer = 0x80;

// abi.encodeWithSignature("transferFrom(address,address,uint256)")
uint256 constant ERC20_transferFrom_signature = (
    0x23b872dd00000000000000000000000000000000000000000000000000000000
);

// signature 0 - 4
uint256 constant ERC20_transferFrom_sig_ptr = 0x0;
// parameters: (each parameter 32 bytes)
//   from address 4 - 36
//   to addresss  36 - 68
//   amount       68 - 100
uint256 constant ERC20_transferFrom_from_ptr = 0x04;
uint256 constant ERC20_transferFrom_to_ptr = 0x24;
uint256 constant ERC20_transferFrom_amount_ptr = 0x44;
uint256 constant ERC20_transferFrom_length = 0x64; // 4 + 32 * 3 == 100
