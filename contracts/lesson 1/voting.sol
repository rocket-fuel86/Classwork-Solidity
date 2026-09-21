// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract VotingSystem {
    struct Candidate {
        uint256 id;
        string name;
        uint voteCount;
    }

    Candidate[] private candidates;
    uint256 candidatesCount = 0;

    function addCandidate(string memory _name) private {
        candidates.push(Candidate({
            id: candidatesCount,
            name: _name,
            voteCount: 0
        }));
        candidatesCount++;
    }

    function vote(uint256 _candidateId) public {
        candidates[_candidateId].voteCount++;
    }

    function getResults() public view returns (Candidate[] memory) {
        return candidates;
    }
}