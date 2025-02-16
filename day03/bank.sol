// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IBank.sol";

contract Bank is IBank {
    struct Depositor {
        address addr;
        uint256 amount;
    }

    address public admin;
    mapping(address => uint256) public balances;
    Depositor[3] public topDepositors;

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    // Function to receive ETH deposits
    receive() external virtual payable {
        balances[msg.sender] += msg.value;
        updateTopDepositors(msg.sender, balances[msg.sender]);
    }

    // Fallback function
    fallback() external virtual payable {
        balances[msg.sender] += msg.value;
        updateTopDepositors(msg.sender, balances[msg.sender]);
    }

    // Function to update top depositors
    function updateTopDepositors(address depositor, uint256 amount) internal {
        // Remove existing entry if present
        for (uint i = 0; i < 3; i++) {
            if (topDepositors[i].addr == depositor) {
                // Remove the existing entry
                for (uint j = i; j < 2; j++) {
                    topDepositors[j] = topDepositors[j+1];
                }
                topDepositors[2] = Depositor(address(0), 0);
                break;
            }
        }

        // Insert at the correct position
        for (uint i = 0; i < 3; i++) {
            if (amount > topDepositors[i].amount) {
                // Shift existing entries down
                for (uint j = 2; j > i; j--) {
                    topDepositors[j] = topDepositors[j-1];
                }
                // Insert new entry
                topDepositors[i] = Depositor(depositor, amount);
                break;
            }
        }
    }

    // Function for admin to withdraw funds
    function withdraw(uint256 amount) external onlyAdmin {
        require(address(this).balance >= amount, "Insufficient contract balance");
        payable(admin).transfer(amount);
    }

    // Function to check contract balance
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // Function to get top depositors
    function getTopDepositors() public view returns (address[3] memory, uint256[3] memory) {
        address[3] memory addresses;
        uint256[3] memory amounts;
        
        for(uint i = 0; i < 3; i++) {
            addresses[i] = topDepositors[i].addr;
            amounts[i] = topDepositors[i].amount;
        }
        
        return (addresses, amounts);
    }
}
