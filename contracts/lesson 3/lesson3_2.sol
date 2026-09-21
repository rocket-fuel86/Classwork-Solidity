// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

/*
call -> transact, view, pure, payable
staticcall -> view, pure
delegatecall -> view, pure, transact
interfacecall -> transact, view, pure, payable
*/

import "hardhat/console.sol";

contract A {
    uint value;

    function set_value(uint new_value) external {
        value = new_value;
    }

    function get_value() external view returns(uint) {
        return value;
    }

    function pay() external payable { console.log("New payment"); }
}

contract B {
    uint public val;
    address contract_a;

    constructor(address other_contract) {
        contract_a = other_contract;
    }

    function callSetValue(uint new_value) public {
        // ABI - application binary interface
        (bool result, ) = contract_a.call(abi.encodeWithSignature("set_value(uint256)", new_value));
        require(result, "set_value() failed");
    }
    function callGetValue() public {
        (bool result, bytes memory data) = contract_a.call(abi.encodeWithSignature("get_value()"));
        require(result, "get_value() failed");
        uint value = abi.decode(data, (uint));
        console.log("Contract A value: ", value);
    }
    function callPayable() public payable {
        (bool result, ) = contract_a.call{value: msg.value}(abi.encodeWithSignature("pay()"));
        require(result, "pay() failed");
    }

    function staticCallGetValue() public view returns(uint) {
        (bool result, bytes memory data) = contract_a.staticcall(abi.encodeWithSignature("get_value()"));
        require(result, "get_value() failed");
        return abi.decode(data, (uint));
    }

    function delegateSetValue(uint new_value) public {
        (bool result, ) = contract_a.delegatecall(abi.encodeWithSignature("set_value(uint256)", new_value));
        require(result, "set_value() failed");
    }
}