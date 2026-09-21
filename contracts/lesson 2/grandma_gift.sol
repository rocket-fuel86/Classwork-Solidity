// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract GrandmaGift {
    uint256 public giftAmount;

    mapping(address => uint256) public birthdates;

    constructor(address[] memory children, uint256[] memory dates) payable {
        giftAmount = msg.value / children.length;

        for (uint256 i = 0; i < children.length; i++) {
            birthdates[children[i]] = dates[i];
        }
    }

    function claim() external {
        uint256 birthday = birthdates[msg.sender];

        require(birthday != 0, "Not on the list");
        require(block.timestamp >= birthday, "Too early!");

        delete birthdates[msg.sender];

        payable(msg.sender).call{value: giftAmount}("");
    }
}