// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./TokenBank.sol";
import "./IERC20Receiver.sol";

contract TokenBankV2 is TokenBank, IERC20Receiver {

    constructor(address tokenAddress) TokenBank(tokenAddress) {
        require(tokenAddress != address(0), "TokenBankV2: Invalid token address");
    }
    function tokensReceived(address _from, uint256 _value) external override {
        // 确保发送者是我们支持的代币合约
        require(msg.sender == address(token), "TokenBankV2: Invalid token");
        
        // 记录存款
        deposits[_from] += _value;
        // 触发存款事件
        emit Deposited(_from, _value);
    }
}
