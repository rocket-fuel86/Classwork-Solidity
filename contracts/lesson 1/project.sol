// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProjectVoting {
    struct Project {
        string description;
        uint256 amount;
        uint256 votes;
        address payable owner;
        bool funded;
    }

    Project[] public projects;

    mapping(uint256 => mapping(address => bool)) public hasVoted;

    function createProject(string memory description, uint256 amount) public {
        projects.push(
            Project(
                description,
                amount,
                0,
                payable(msg.sender),
                false
            )
        );
    }

    function vote(uint256 projectId) public {
        require(!hasVoted[projectId][msg.sender], "Already voted");

        hasVoted[projectId][msg.sender] = true;
        projects[projectId].votes++;
    }

    function fundWinner() public payable {
        require(projects.length > 0, "No projects");

        uint256 winner = 0;

        for (uint256 i = 1; i < projects.length; i++) {
            if (projects[i].votes > projects[winner].votes) {
                winner = i;
            }
        }

        require(
            msg.value >= projects[winner].amount,
            "Not enough money"
        );

        (bool success, ) = projects[winner].owner.call{value: projects[winner].amount}("");
        require(success, "Transfer failed");
        projects[winner].funded = true;
    }

    function getProjectsCount() public view returns (uint256) {
        return projects.length;
    }
}