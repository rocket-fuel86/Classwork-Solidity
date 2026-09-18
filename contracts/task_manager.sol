// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract TaskManager {
    string[] private tasks;

    function addTask(string calldata task) public {
        tasks.push(task);
    }

    function deleteTask(uint256 index) public {
        for (uint256 i = index; i < tasks.length - 1; i++) {
            tasks[i] = tasks[i + 1];
        }

        tasks.pop();
    }

    function getAllTasks() public view returns (string[] memory) {
        return tasks;
    }

    function getTaskCount() public view returns (uint256) {
        return tasks.length;
    }
}