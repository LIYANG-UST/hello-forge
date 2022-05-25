// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract StorageSlot {
    struct MyStruct {
        uint256 value;
    }

    // struct stored at slot 0
    MyStruct public s0 = MyStruct(123);
    // struct stored at slot 1
    MyStruct public s1 = MyStruct(456);
    // struct stored at slot 2
    MyStruct public s2 = MyStruct(789);

    function get(uint256 _i) external view returns (uint256) {
        return _loadSlot(_i).value;
    }

    function set(uint256 _slot, uint256 _value) external {
        _loadSlot(_slot).value = _value;
    }

    function _loadSlot(uint256 _slot)
        internal
        pure
        returns (MyStruct storage s)
    {
        assembly {
            s.slot := _slot
        }
    }
}
