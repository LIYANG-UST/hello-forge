// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract EtherWallet {
    address payable public owner;

    event Withdraw(address receiver, uint256 amount);

    constructor() {
        owner = payable(msg.sender);
    }

    function getBalance() external view returns(uint256) {
        return address(this).balance;
    }

    receive() external payable {}

    function withdraw(address _receiver, uint256 _amount) external {
        require(msg.sender == owner, "Only owner");
        payable(_receiver).transfer(_amount);
        emit Withdraw(_receiver, _amount);
    }
}
