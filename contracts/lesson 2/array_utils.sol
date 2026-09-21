// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

import "lib/array_lib.sol";

contract ArrayUtils {
    using ArrayLibrary for uint256[];

    uint256[] public numbers;

    function addElement(uint256 value) external {
        numbers.push(value);
    }

    function findValue(uint256 value) external view returns (bool found, uint256 index) {
        return numbers.findIndexOf(value);
    }

    function sortArray() external {
        numbers.sort();
    }

    function removeAt(uint256 index) external {
        numbers.removeByIndex(index);
    }

    function getNumbers() external view returns (uint256[] memory) {
        return numbers;
    }
}