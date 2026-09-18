// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

library ArrayLibrary {
    function findIndexOf(uint256[] storage arr, uint256 value) 
        internal 
        view  
        returns (bool found, uint256 index)
    {
        for (uint i = 0; i < arr.length; i++) {
            if (arr[i] == value) {
                return (true, i);
            }
        }
        return (false, 0);
    }

    function removeByIndex(uint256[] storage arr, uint256 index) internal {
        require(index < arr.length, "Index out of bounds");
        
        for (uint256 i = index; i < arr.length - 1; i++) {
            arr[i] = arr[i + 1];
        }

        arr.pop();
    }

    function sort(uint256[] storage arr) internal {
        uint256 n = arr.length;
        if (n <= 1) return;

        for (uint256 i = 0; i < n - 1; i++) {
            for (uint256 j = 0; j < n - i - 1; j++) {
                if (arr[j] > arr[j + 1]) {
                    uint256 temp = arr[j];
                    arr[j] = arr[j + 1];
                    arr[j + 1] = temp;
                }
            }
        }
    }
}