// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract BaseA {
    function role() public pure virtual returns (string memory) {
        return "Role A";
    }
}

contract BaseB is BaseA {
    function role() public pure virtual override returns (string memory) {
        return "Role B";
    }
}

contract Child is BaseB {
    function role() public pure override returns (string memory) {
        return "Child Role";
    }

    function baseRole() public pure returns (string memory) {
        return super.role();
    }
}