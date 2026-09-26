// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract SubscriptionSystem {
    address public admin;
    uint public price;

    mapping (address => uint) public subscriptionEnd;

    constructor(uint _price) {
        admin = msg.sender;
        price = _price;
    }

    function subscribe(uint daysCount) public payable  {
        require(msg.value == price * daysCount, "Wrong payment");

        if (subscriptionEnd[msg.sender] < block.timestamp) {
            subscriptionEnd[msg.sender] = block.timestamp;
        }

        subscriptionEnd[msg.sender] += daysCount * 1 days;
    }

    function isSubscribed(address user) public view returns (bool) {
        return subscriptionEnd[user] > block.timestamp;
    }

    function changePrice(uint256 newPrice) public {
        require(msg.sender == admin, "Only admin");

        price = newPrice;
    }

    function withdraw() public {
        require(msg.sender == admin, "Only admin");

        (bool success, ) = payable(admin).call{value: address(this).balance}("");
        require(success, "Transfer failed");
    }
}