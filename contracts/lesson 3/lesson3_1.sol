// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract Base {
    uint private_field;
    string internal message = "Hello from Base";

    function method() external virtual pure returns(string memory) {
        return "BaseContract";
    }

    function set_private(uint new_value) external {
        private_field = new_value;
    }

    function get_value() external view returns(uint) {
        return private_field;
    }
}

contract Derived is Base {
    constructor() {
        message = "Hello from derived";
    }

    function get_message() external view returns(string memory) {
        return message;
    } 

    function method() external override pure returns(string memory) {
        return "DerivedContract";
    }
}

abstract contract Token {
    uint internal coins;
    constructor() {
        mint();
    }

    function mint() internal virtual;
    function get_coins() external view returns(uint) {
        return coins;
    }
    function method() external virtual pure returns(string memory) {
        return "TokenContract";
    }
}

contract AwesomeToken is Token {
    // constructor() {
    //     mint();
    // }

    function mint() internal override {
        coins = 1 ether;
    }
}

contract MultiplyContract is Base, Token {
    function mint() internal override {
        coins = 1 ether;
    }
    function method() external override(Token, Base) pure returns(string memory) {
        return "MultiplyContract";
    }
}