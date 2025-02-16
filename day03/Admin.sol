// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IBank.sol";

contract Admin {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    // Function to withdraw funds from bank contract
    function adminWithdraw(IBank bank) external onlyOwner {
        uint256 bankBalance = bank.getContractBalance();
        bank.withdraw(bankBalance);
    }

    // Function to receive ETH
    receive() external payable {}
} 