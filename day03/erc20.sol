// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC20.sol";
import "./IERC20Receiver.sol";

contract BaseERC20 is IERC20 {
    // 代币名称
    string public name = "BaseERC20"; 
    // 代币符号
    string public symbol = "BERC20"; 
    // 代币的小数位
    uint8 public decimals = 18; 

    // 代币总供应量
    uint256 public totalSupply = 100000000 * 10**uint256(decimals); 

    // 存储每个地址的代币余额
    mapping(address => uint256) public balances; 
    // 存储每个地址对于某个spender的授权额度
    mapping(address => mapping(address => uint256)) public allowances; 

    // 转账事件
    event Transfer(address indexed from, address indexed to, uint256 value);
    // 授权事件
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // 合约构造函数，初始化总供应量并将其分配给合约创建者
    constructor() {
        // 初始化总供应量并将其分配给合约创建者
        balances[msg.sender] = totalSupply;
    }

    // 视图函数：返回指定地址的余额
    function balanceOf(address _owner) public view returns (uint256 balance) {
        // 返回指定地址的代币余额
        return balances[_owner];
    }

    // 转账函数：从调用者地址转账一定数量的代币到目标地址
    function transfer(address _to, uint256 _value) public returns (bool success) {
        // 检查目标地址是否为零地址
        require(_to != address(0), "ERC20: transfer to the zero address");
        // 检查调用者是否有足够的余额进行转账
        require(balances[msg.sender] >= _value, "ERC20: transfer amount exceeds balance");

        // 执行转账
        balances[msg.sender] -= _value;
        balances[_to] += _value;

        // 触发 Transfer 事件
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    // 从指定地址转账代币到目标地址（需要调用者有相应的授权）
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        // 检查发起转账的地址是否为零地址
        require(_from != address(0), "ERC20: transfer from the zero address");
        // 检查目标地址是否为零地址
        require(_to != address(0), "ERC20: transfer to the zero address");
        // 检查发起转账的地址是否有足够的余额
        require(balances[_from] >= _value, "ERC20: transfer amount exceeds balance");
        // 检查授权的额度是否足够
        require(allowances[_from][msg.sender] >= _value, "ERC20: transfer amount exceeds allowance");

        // 执行转账
        balances[_from] -= _value;
        balances[_to] += _value;
        // 更新授权额度
        allowances[_from][msg.sender] -= _value;

        // 触发 Transfer 事件
        emit Transfer(_from, _to, _value);
        return true;
    }

    // 授权函数：授权某个地址可以花费一定数量的代币
    function approve(address _spender, uint256 _value) public returns (bool success) {
        // 检查授权地址是否为零地址
        require(_spender != address(0), "ERC20: approve to the zero address");

        // 设置授权额度
        allowances[msg.sender][_spender] = _value;
        // 触发 Approval 事件
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    // 视图函数：查看某个地址授权给指定spender的剩余额度
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        // 返回该spender剩余可以从_owner账户中转账的额度
        return allowances[_owner][_spender];
    }

    // 转账并调用目标合约的 tokensReceived 方法
    function transferWithCallback(address _to, uint256 _value) public returns (bool success) {
        // 检查目标地址是否为零地址
        require(_to != address(0), "ERC20: transfer to the zero address");
        // 检查调用者是否有足够的余额进行转账
        require(balances[msg.sender] >= _value, "ERC20: transfer amount exceeds balance");

        // 执行转账
        balances[msg.sender] -= _value;
        balances[_to] += _value;

        // 触发 Transfer 事件
        emit Transfer(msg.sender, _to, _value);

        // 检查目标地址是否是合约地址
        if (isContract(_to)) {
            // 调用目标合约的 tokensReceived 方法
            IERC20Receiver(_to).tokensReceived(msg.sender, _value);
        }

        return true;
    }

    // 检查地址是否是合约地址的辅助函数
    function isContract(address _addr) private view returns (bool) {
        uint32 size;
        assembly {
            size := extcodesize(_addr)
        }
        return (size > 0);
    }
}
