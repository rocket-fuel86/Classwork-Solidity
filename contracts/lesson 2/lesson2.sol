// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

import "hardhat/console.sol";
import "lib/my_lib.sol";

contract Foundation{

    using my_lib for uint;
    using console for string;

    address owner;

    error NotOwner(address expected, address current);
    error NotEnoughMoney(uint expected, uint current);

    event WithdrawEvent(uint value);
    event DonateEvent(address indexed sender, uint value);

    modifier isOwner(){
        console.log("Who's trying get access to owner functions: ", msg.sender);
        require(msg.sender == owner, NotOwner(owner, msg.sender));
        _;
    }

    modifier minValue(uint256 min_value){
        require(msg.value >= min_value, NotEnoughMoney(min_value, msg.value));
        _;
    }

    constructor(){
        console.log("Sum 1 + 2 =", my_lib.sum(1,2));
        console.log("Max(1,2): ", my_lib.get_max(1,2));

        uint val1 = 25;
        console.log("Sum 25 + 30 =",val1.sum(30));
        console.log("Max(25,1000): ", val1.get_max(1000));
        owner = msg.sender;

        string memory s = "Contract successfuly deployed at: ";
        s.log(address(this));
    }

    function get_product() external pure returns(my_lib.Product memory){
        return my_lib.Product("product1", 1 ether);
    }

    function donate() external payable minValue(0.0002 ether){
        console.log("New donate: ", msg.value);
        emit DonateEvent(msg.sender, msg.value);
    }

    // uint public test;

    function withdraw(uint sum)external isOwner{
        // test = 12;
        // assert(msg.sender == owner);

        /*if(msg.sender != owner){
            // return;
            // revert("You're not owner");
            revert NotOwner(owner, msg.sender);
        }*/

        // require(msg.sender == owner, "You're not owner");
        // require(msg.sender == owner, NotOwner(owner, msg.sender));

        
        (bool result, ) = payable(owner).call{value: sum}("");
        if(!result){
            revert("Withdraw failed");
        }
        console.log("Withdraw successfuly");
        emit WithdrawEvent(sum);
    }

    function owner_function()external view isOwner returns(string memory){
        return "owner_function";
    }

    fallback() external payable { 
        // якщо у транзакції вказана не існуюча у контракті функція, спрацьовує цей механізм
        console.log("Fallback");
        (bool result, )=payable(msg.sender).call{value:msg.value}("");
          if(!result){
            revert("fallback error");
        }
    }
    receive() external payable {
        // якщо у транзакції взагалі не вказана функція, спрацьовує цей механізм
        console.log("Recieve");
    }
}