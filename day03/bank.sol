// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Bank {
    address public admin;
    mapping(address => uint256) public balances;
    address[3] public topDepositors;
    uint256[3] public topAmounts;

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    // Function to receive ETH deposits
    receive() external payable {
        balances[msg.sender] += msg.value;
        updateTopDepositors(msg.sender, balances[msg.sender]);
    }

    // Fallback function
    fallback() external payable {
        balances[msg.sender] += msg.value;
        updateTopDepositors(msg.sender, balances[msg.sender]);
    }

    // Function to update top depositors
    function updateTopDepositors(address depositor, uint256 amount) private {
        for (uint i = 0; i < 3; i++) {
            if (amount > topAmounts[i]) {
                // Shift existing entries down
                for (uint j = 2; j > i; j--) {
                    topAmounts[j] = topAmounts[j-1];
                    topDepositors[j] = topDepositors[j-1];
                }
                // Insert new entry
                topAmounts[i] = amount;
                topDepositors[i] = depositor;
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
        return (topDepositors, topAmounts);
    }
}
