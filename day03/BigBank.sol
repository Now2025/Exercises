// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Bank.sol";

contract BigBank is Bank {
    modifier minDeposit() {
        require(msg.value > 0.001 ether, "Deposit must be greater than 0.001 ether");
        _;
    }

    // Override receive function with minDeposit modifier
    receive() override external payable  minDeposit {
        balances[msg.sender] += msg.value;
        updateTopDepositors(msg.sender, balances[msg.sender]);
    }

    // Override fallback function with minDeposit modifier
    fallback() override external payable  minDeposit {
        balances[msg.sender] += msg.value;
        updateTopDepositors(msg.sender, balances[msg.sender]);
    }

    // Function to transfer admin rights
    function transferAdmin(address newAdmin) external onlyAdmin {
        require(newAdmin != address(0), "New admin cannot be zero address");
        admin = newAdmin;
    }
} 