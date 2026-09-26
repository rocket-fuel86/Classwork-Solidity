// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EducationGrant {
    address public owner;

    struct Student {
        address payable student;
        uint256 grant;
        uint256 goal;
        bool completed;
        bool paid;
    }

    mapping(address => Student) public students;

    event GrantCreated(address student, uint256 amount, uint256 goal);
    event GoalCompleted(address student);
    event GrantPaid(address student, uint256 amount);
    event GrantFrozen(address student);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    modifier studentExists(address student) {
        require(students[student].student != address(0), "Student not found");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function deposit(address student) public payable {
        require(msg.value > 0, "Send ETH");

        students[student].student = payable(student);
        students[student].grant += msg.value;

        emit GrantCreated(student, msg.value, students[student].goal);
    }

    function setGoal(address student, uint256 goal) public onlyOwner studentExists(student) {
        students[student].goal = goal;
    }

    function completeGoal(address student) public onlyOwner studentExists(student) {
        students[student].completed = true;

        emit GoalCompleted(student);
    }

    function withdrawGrant(address student) public studentExists(student) {
        require(students[student].completed, "Goal not completed");
        require(!students[student].paid, "Already paid");
        require(students[student].grant > 0, "No grant");

        uint256 amount = students[student].grant;

        students[student].paid = true;

        (bool success, ) = students[student].student.call{value: amount}("");
        require(success, "Payment failed");

        emit GrantPaid(student, amount);
    }

    function freezeGrant(address student) public onlyOwner studentExists(student) {
        students[student].completed = false;

        emit GrantFrozen(student);
    }
}