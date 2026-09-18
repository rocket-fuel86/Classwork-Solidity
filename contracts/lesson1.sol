// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

import "hardhat/console.sol";

contract First{
    // world_state
    bool public bool_value = true;

    /* Data types:
    Stack: 
    bool, int, uint, address -> Stack. Можна зберігати в storage, тільки якщо прописані як стан(поле) контракту
    
    Memory: (можна також зберігати у storage тільки якщо прописані як стан контракту)
    [], [][]
    mapping
    bytes
    string
    struct
    enum
    */

    /*
    перевантаження операцій немає, перевантаження функцій немає, шаблонів функцій немає
    =
    + - * / %
    > < >= <= ==
    || &&
    !
    ?:
    */

    /*
    if(condition){
        dosmth;
    }
    else if(condition){
        dosmth;
    }else{dosmth;}
    */
    /*
    do {
        code
    } 
    while (condition);

    while(condition){}

    for(;;){}

    recursion
    */

    // address public owner = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;

    /*
    address:
        - balance(uint256) -> wei
        - transfer(value:uint256)
    */
    address public owner;
    string public str1 = "string";
    constructor(/*params*/){
        /*
        msg - глобальний об'єкт який зберігає деталі поточної транзакції
            - value(wei:uint256): скільки wei було надіслано
            - sender(address): ініціатор транзакції
        */
        owner = msg.sender;
        console.log("Congratulations");
        console.log("You deployed your first contract at: ", address(this));
        console.log("Owner: ", owner);
        console.log("Owner balance: ", owner.balance);
        str1 = "New string";
    }

    /*
    Можна задавати як функціям так і полям:
    public - функції та поля доступні усюди(у контракті/за контрактом). 
    private - усі данні доступні у контракті
    Специфікатори доступу тільки для функцій:
    external - доступ тільки за межами контракту
    internal - доступ тільки у контракті та його нащадках(~protected)
    */

    /*
    memory - write/read, тимчасовий об'єкт, який зберігається в machine state, знищується після завершення транзакції(завершшення виконання ф-ції)

    calldata - read only, тимчасовий об'єкт, дешевший чим memory

    */
    function set_string(string calldata new_str)public{
        str1 = new_str;
        // new_str = "value"; !помилка: calldata можна тільки читати
    }

    function factorial(uint n) public view returns(uint256){
        if(n <= 1) return 1;
        return n * this.factorial(n - 1);
    }

    // arrays
    uint[5] public arr = [1,2,3,4];

    // type[cols][row]
    uint[4][4] public arr2d =[
        [1,2,3,4],
        [5,6,7,8],
        [9,10,11,12],
        [13,14,15,16]
    ];

    /*
    length:uint
    push(item)
    pop() - видаляє останній елемент
    []
    */

    // [1,3,43,534,65,7654,35]
    uint[] public dynamic_array;

    function init_arr(uint[] calldata init)external{
        for (uint idx; idx < init.length; idx++) 
        {
           console.log("%d# - %d", idx, init[idx]);
           dynamic_array.push(init[idx]);
        }
    }

    function print_array()public view{
        console.log("dynamic_array:");
        for (uint idx; idx < dynamic_array.length; idx++){
            console.log("%d# - %d", idx, dynamic_array[idx]);
        } 
    }

    function remove_last()public{
        dynamic_array.pop();
    }

    function remove_by_index(uint idx) public{
        if(idx > dynamic_array.length-1){
            revert("Index greater than length of array");
        }
        delete dynamic_array[idx];
    }

    // mapping
    // mapping(type_for_key=>type_for_value) name;

    mapping(address=>uint256) public balances;
    function write_balance()public{
        balances[msg.sender] = msg.sender.balance;
    }

    // bytes

    bytes1 public one_byte = "b";

    bytes32 public bytes_32 = "Hello, world";
    bytes public bytes_unlimited = "Hello, world";

    function decode(bytes memory data) public pure{
        data[2] = "g";
        console.log(string(data));
    }

    enum Status {Paid, Delievered, Recieved}

    Status public product_status = Status.Recieved;


    struct Payment{
        uint value;
        uint timestamp;
        address from;
        string message;
    }
    Payment[] public donates;

    function donate(string calldata message) external payable {
        donates.push(Payment(msg.value,block.timestamp, msg.sender, message));
    }

    // function transfer(address payable to) external payable{
    //     to.transfer(msg.value);
    // }

    function transfer(address to) external payable{
        // payable(to).transfer(msg.value);
        (bool result, ) = to.call{value:msg.value}("");
        if(result != true){
            revert("Payment not asign");
        }
    }

    /*
    transact - це ф-ції які працюють зі станом котракту, а саме змінюють цей стан, для таких функцій формується транзакція
    За їх виклик ініціатор платить комісію. Ціна комісії залежить від кількості газу, витраченого на виконання
    
    view - це ф-ції, які також можуть працювати зі станом контракту, але тільки у режимі читання. За виклик
    таких функцій комісія не стягується.

    pure - також безкоштовна функція, але вона не може працювати зі станом контракту, навіть у режимі читання. Використовуються
    в основному у бібліотеках як службові ф-ції, також можна створювати і у контрактах.

    view та pure ф-цій використовується механізм call.
    */

    string str = "contract state";

    function view_get_string() external view returns(string memory){
        return str;
    }

    function pure_get_string() external pure returns(string memory){
        // return str; !pure ф-ція не може читати стан контракту
        return "Pure";
    }
}