// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BaseERC20 {
    string public name = "BaseERC20"; 
    string public symbol = "BERC20"; 
    uint8 public decimals = 18; 

    uint256 public totalSupply = 100000000 * 10**uint256(decimals); 

    mapping(address => uint256) public balances; 
    mapping(address => mapping(address => uint256)) public allowances; 

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor() {
        // Initialize the total supply to the creator of the contract
        balances[msg.sender] = totalSupply;
    }

    // View function to return balance of a given address
    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

    // Transfer function to send tokens from sender to receiver
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0), "ERC20: transfer to the zero address");
        require(balances[msg.sender] >= _value, "ERC20: transfer amount exceeds balance");

        balances[msg.sender] -= _value;
        balances[_to] += _value;

        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    // Transfer function to send tokens from a specific address
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_from != address(0), "ERC20: transfer from the zero address");
        require(_to != address(0), "ERC20: transfer to the zero address");
        require(balances[_from] >= _value, "ERC20: transfer amount exceeds balance");
        require(allowances[_from][msg.sender] >= _value, "ERC20: transfer amount exceeds allowance");

        balances[_from] -= _value;
        balances[_to] += _value;
        allowances[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);
        return true;
    }

    // Approve a spender to spend a specific amount of tokens from the owner's balance
    function approve(address _spender, uint256 _value) public returns (bool success) {
        require(_spender != address(0), "ERC20: approve to the zero address");

        allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    // View function to check how much the spender is allowed to spend from the owner's balance
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowances[_owner][_spender];
    }
}
