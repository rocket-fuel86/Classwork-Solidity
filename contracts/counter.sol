// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

import "hardhat/console.sol";

contract Counter {
    uint private counter;

    constructor() {
        counter = 0;
    }

    function increment() public {
        counter += 1;
        console.log(getCounter());
    }

    function decrement() public {
        if (counter != 0) {
            counter -= 1;
            console.log(getCounter());
        }
    }

    function getCounter() public view returns (uint256) {
        return counter;
    }
}