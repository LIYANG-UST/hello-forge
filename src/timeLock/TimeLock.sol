// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract TimeLock {
    address public owner;

    uint256 public constant MIN_DELAY = 10;
    uint256 public constant MAX_DELAY = 1000;
    uint256 public constant GRACE_PERIOD = 1000;

    mapping(bytes32 => bool) public queued;

    event Queue(
        bytes32 indexed txId,
        address indexed tartget,
        uint256 value,
        string func,
        bytes data,
        uint256 timestamp
    );
    event Execute(
        bytes32 indexed txId,
        address indexed tartget,
        uint256 value,
        string func,
        bytes data,
        uint256 timestamp
    );
    event Cancel(bytes32 txId);

    error NotOwner();
    error AlreadyQueued(bytes32 txId);
    error TimestampNotInRange(uint256 blockTimestamp, uint256 timestamp);
    error NotQueued(bytes32 txId);
    error TimestampNotPassed(uint256 blockTimestamp, uint256 timestamp);
    error TimestampExpired(uint256 blockTimestamp, uint256 expiresAt);
    error TxFailed();

    constructor(address _initOwner) {
        owner = _initOwner;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    function queue(
        address _target,
        uint256 _value,
        string calldata _func,
        bytes calldata _data,
        uint256 _timestamp
    ) external onlyOwner {
        // create tx id
        bytes32 txId = getTxId(_target, _value, _func, _data, _timestamp);

        // check tx id
        if (queued[txId]) revert AlreadyQueued(txId);

        // check timestamp
        // ----|----------|------------|---
        //   block    block+min     block+max
        if (
            _timestamp < block.timestamp + MIN_DELAY ||
            _timestamp > block.timestamp + MAX_DELAY
        ) {
            revert TimestampNotInRange(block.timestamp, _timestamp);
        }

        // queue tx
        queued[txId] = true;

        emit Queue(txId, _target, _value, _func, _data, _timestamp);
    }

    function execute(
        address _target,
        uint256 _value,
        string calldata _func,
        bytes calldata _data,
        uint256 _timestamp
    ) external payable onlyOwner returns (bytes memory) {
        bytes32 txId = getTxId(_target, _value, _func, _data, _timestamp);

        // check tx is queued
        if (!queued[txId]) revert NotQueued(txId);

        // check block.timestamp > _timestamp
        if (block.timestamp < _timestamp)
            revert TimestampNotPassed(block.timestamp, _timestamp);

        // check within grace period (not expired)
        if (block.timestamp > _timestamp + GRACE_PERIOD)
            revert TimestampExpired(block.timestamp, _timestamp + GRACE_PERIOD);

        // move out of the queue
        queued[txId] = false;

        // execute
        bytes memory data;
        if (bytes(_func).length > 0) {
            data = abi.encodePacked(bytes4(keccak256(bytes(_func))), _data);
        } else {
            data = _data;
        }

        (bool success, bytes memory res) = _target.call{value: _value}(data);
        if (!success) revert TxFailed();

        emit Execute(txId, _target, _value, _func, _data, _timestamp);

        return res;
    }

    function cancel(bytes32 _txId) external onlyOwner {
        if (!queued[_txId]) revert NotQueued(_txId);

        queued[_txId] = false;

        emit Cancel(_txId);
    }

    receive() external payable {}

    function getTxId(
        address _target,
        uint256 _value,
        string calldata _func,
        bytes calldata _data,
        uint256 _timestamp
    ) public pure returns (bytes32 txId) {
        txId = keccak256(abi.encode(_target, _value, _func, _data, _timestamp));
    }
}
