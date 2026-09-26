 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EmergencyFund {
    address public owner;
    uint256 public requiredApprovals;

    mapping(address => bool) public members;
    mapping(address => uint256) public contributions;

    struct Emergency {
        address payable recipient;
        uint256 amount;
        string reason;
        uint256 approvals;
        bool paid;
    }

    Emergency public emergency;

    mapping(address => bool) public approved;

    event Contribution(address member, uint256 amount);
    event EmergencyCreated(address recipient, uint256 amount, string reason);
    event EmergencyApproved(address member);
    event EmergencyPaid(address recipient, uint256 amount);

    modifier onlyMember() {
        require(members[msg.sender], "Not a member");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    constructor(uint256 _requiredApprovals) {
        owner = msg.sender;
        requiredApprovals = _requiredApprovals;
        members[msg.sender] = true;
    }

    function addMember(address member) public onlyOwner {
        members[member] = true;
    }

    function contribute() public payable onlyMember {
        require(msg.value > 0, "Send ETH");

        contributions[msg.sender] += msg.value;

        emit Contribution(msg.sender, msg.value);
    }

    function createEmergency(address payable recipient, uint256 amount, string memory reason) public onlyMember {
        require(amount > 0, "Invalid amount");
        require(amount <= address(this).balance, "Not enough funds");

        emergency = Emergency(
            recipient,
            amount,
            reason,
            0,
            false
        );

        approved[msg.sender] = false;

        emit EmergencyCreated(recipient, amount, reason);
    }

    function approveEmergency() public onlyMember {
        require(!emergency.paid, "Already paid");
        require(!approved[msg.sender], "Already approved");

        approved[msg.sender] = true;
        emergency.approvals++;

        emit EmergencyApproved(msg.sender);
    }

    function payEmergency() public {
        require(!emergency.paid, "Already paid");
        require(
            emergency.approvals >= requiredApprovals,
            "Not enough approvals"
        );

        emergency.paid = true;

        (bool success, ) = emergency.recipient.call{
            value: emergency.amount
        }("");

        require(success, "Payment failed");

        emit EmergencyPaid(
            emergency.recipient,
            emergency.amount
        );
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}