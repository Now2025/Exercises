// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20Receiver {
    // 当合约接收到代币时调用的方法
    function tokensReceived(address from, uint256 value) external;
} 