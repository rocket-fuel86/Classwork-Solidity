// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

import "hardhat/console.sol";

contract Foundation {
    address owner;

    error NotOwner(address expected, address given);

    constructor() {
        owner = msg.sender;
    }

    function donate() external payable {
        console.log("New donate: ", msg.value);
    }

    function withdraw() external {
        // if (msg.sender != owner) {
        //     // revert("You`re not owner");
        //     revert NotOwner(owner, msg.sender);
        // }
        
        require(msg.sender != owner, NotOwner(owner, msg.sender));

        (bool result, ) = payable(owner).call{value: address(this).balance}("");

        if (!result) {
            revert("Withdraw failed");
        }

        console.log("Withdraw successful");
    }
}