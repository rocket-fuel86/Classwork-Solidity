// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

abstract contract Base {
    mapping(address => uint) internal balances;

    function transfer(address from, address to, uint256 amount) internal virtual;
}

contract StableCoin is Base {
    address public _treasureWallet;

    constructor(address treasureWallet) {
        require(treasureWallet != address(0), "Invalid treasure wallet");
        _treasureWallet = treasureWallet;
    }

    function mint(address account, uint256 amount) external {
        balances[account] += amount;
    }

    function publicTransfer(address to, uint256 amount) external {
        transfer(msg.sender, to, amount);
    }

    function transfer(address from, address to, uint256 amount) internal override {
        require(balances[from] >= amount, "Insufficient balance");
        
        uint256 feeAmount = amount * 1 / 100;
        uint256 recipientAmount = amount - feeAmount;

        balances[from] -= amount;
        balances[to] += recipientAmount;
        balances[_treasureWallet] += feeAmount;
    }
}