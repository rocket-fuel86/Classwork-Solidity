// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

import "hardhat/console.sol";
/*
call -> transact, view, pure, payable
staticcall -> view, pure
delegatecall -> view, pure, transact
interfacecall -> transact, view, pure, payable
*/

interface IContractA {
    function set_value(uint value) external;
    function get_value()external view returns(uint);
    function pay() external payable;
}

contract A is IContractA{
    address owner; //0
    uint value; //1

    function set_value(uint new_value) external{
        owner = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
        value = new_value;
    }

    function get_value()external view returns(uint){
        return value;
    }

    function withdraw() external{
        (bool result, ) = payable(owner).call{value: address(this).balance}("");
        require(result, "withdraw failed");
    }
    function pay() external payable{ console.log("New payment");}
}

contract B{
    address public owner = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4; //0
    uint public val; // 1
    address public contract_a; // 2
   

    constructor(address other_contract){
        contract_a = other_contract;
    }

    function pay() external payable{ console.log("New payment");}

    function callSetValue(uint new_value) public{
        // ABI - application binnary interface
        (bool result, ) = contract_a.call(abi.encodeWithSignature("set_value(uint256)", new_value));
        require(result, "Set value failed");
    }
    function callGetValue() public{
        (bool result, bytes memory data) = contract_a.call(abi.encodeWithSignature("get_value()"));
        require(result, "Get value failed");
        uint value = abi.decode(data, (uint));
        console.log("Contract A value: ", value);
    }
    function callPayable() public payable{
        (bool result, ) = contract_a.call{value: msg.value}(abi.encodeWithSignature("pay()"));
        require(result, "Pay function failed");
    }
    
    function staticcallGetValue() public view returns(uint){
        (bool result, bytes memory data) = contract_a.staticcall(abi.encodeWithSignature("get_value()"));
        require(result, "get value failed");
        return abi.decode(data,(uint));
    }

    function delegateSetValue(uint new_value) public{
        (bool result, ) = contract_a.delegatecall(abi.encodeWithSignature("set_value(uint256)", new_value));
        require(result, "Set value failed");
    }

    function delegateWithdraw() public{
        (bool result, ) = contract_a.delegatecall(abi.encodeWithSignature("withdraw()"));
        require(result, "Set value failed");
    }

    function interfacecall(uint new_value) public payable returns(uint){
        IContractA contrA = IContractA(contract_a);

        contrA.set_value(new_value);
        contrA.pay{value:msg.value}();
        return contrA.get_value();
    }
    
}