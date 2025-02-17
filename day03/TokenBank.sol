// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC20.sol";

contract TokenBank {
    IERC20 public token; // 代币合约的地址

    // 记录每个用户的存款数量
    mapping(address => uint256) public deposits;

    // 事件：存款
    event Deposited(address indexed user, uint256 amount);
    // 事件：取款
    event Withdrawn(address indexed user, uint256 amount);
    // 事件：授权存款
    event ApprovedDeposit(address indexed user, uint256 amount);

    // 构造函数，初始化Token合约地址
    constructor(address _token) {
        token = IERC20(_token);
    }

    // 存入代币
    function deposit(uint256 amount) public {
        require(amount > 0, "Deposit amount must be greater than 0");

        // 从用户地址转移代币到 TokenBank 合约
        require(
            token.transferFrom(msg.sender, address(this), amount),
            "Transfer failed"
        );

        // 增加用户的存款数量
        deposits[msg.sender] += amount;

        // 发出存款事件
        emit Deposited(msg.sender, amount);
    }

    // 提取代币
    function withdraw(uint256 amount) public {
        require(amount > 0, "Withdraw amount must be greater than 0");
        require(deposits[msg.sender] >= amount, "Insufficient balance");

        // 减少用户的存款数量
        deposits[msg.sender] -= amount;

        // 将代币从 TokenBank 合约转移到用户地址
        require(token.transfer(msg.sender, amount), "Transfer failed");

        // 发出取款事件
        emit Withdrawn(msg.sender, amount);
    }

    // 获取当前用户的存款余额
    function getDepositBalance() public view returns (uint256) {
        return deposits[msg.sender];
    }

    // 查询用户授权 TokenBank 合约的代币额度
    function getAllowance(address owner) public view returns (uint256) {
        return token.allowance(owner, address(this)); // 查询用户授权给 TokenBank 合约的代币额度
    }
}
