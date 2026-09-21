// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

interface IStorage {
    function deposit(address user) external payable;
    function withdraw(address user, uint256 amount) external;
    function getBalance(address user) external view returns(uint256);
}

contract Storage is IStorage {
    mapping (address => uint256) private balances;

    address public broker;

    modifier onlyBroker() {
        require(msg.sender == broker, "Only broker");
        _;
    }

    function deposit(address user) external payable override onlyBroker {
        require(msg.value > 0, "Amount must be greater than 0");

        balances[user] += msg.value;
    }
    function withdraw(address user, uint256 amount) external override onlyBroker {
        require(
            balances[user] >= amount,
            "Insufficient balance"
        );

        balances[user] -= amount;

        (bool result, ) = payable(user).call{value: amount}("");
        require(result, "Failed to withdraw");
    }

    function getBalance(address user) external view override returns(uint256) {
        return balances[user];
    }

    function setBroker(address _broker) external {
        broker = _broker;
    }
}

contract Broker {
    IStorage public storageContract;

    constructor(address _storage) {
        storageContract = IStorage(_storage);
    }

    function deposit() external payable {
        require(msg.value > 0, "Amount must be greater than 0");

        storageContract.deposit{value: msg.value}(msg.sender);
    }

    function withdraw(uint256 amount) external {
        storageContract.withdraw(msg.sender, amount);
    }

    function getBalance() external view returns (uint256) {
        return storageContract.getBalance(msg.sender);
    }
}