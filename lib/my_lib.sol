// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

library my_lib{
    // на відмінну від контракту не мають свого стану
    // uint test = 12; // !помилка
    // не має view-функцій та transact-функцій
    // бібліотека це набір pure-функцій

    struct Product{
        string title;
        uint price;
    }

    function sum(uint a, uint b) pure external returns(uint){
        return a+b;
    }
    function get_max(uint a, uint b) pure external returns(uint){
        return a > b? a:b;
    }
}