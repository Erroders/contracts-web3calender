// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract Event is AccessControl {
    uint public _startTime;
    uint public _endTime;
    string private _metadata;

    bytes32 public constant CREATOR = keccak256("CREATOR");
    bytes32 public constant INVITED = keccak256("INVITED");
    bytes32 public constant RSVPD = keccak256("RSVPD");

    modifier eventNotEnded() {
        require(_endTime > block.timestamp, "Invalid Request");
        _;
    }

    // create event
    constructor(
        uint stime,
        uint etime,
        string memory metadata,
        address[] memory attendees,
        address creator
    ) {
        require(stime >= block.timestamp, "Invalid Start Time");
        require(etime >= _startTime, "Invalid End Time");
        grantRole(DEFAULT_ADMIN_ROLE, address(this));
        grantRole(CREATOR, creator);
        _metadata = metadata;
        for (uint i = 0; i < attendees.length; i++) {
            _invite(attendees[i]);
        }
    }

    // update event
    function modifyStartTime(uint time) public eventNotEnded onlyRole(CREATOR) {
        require(time >= block.timestamp, "Invalid Request");
        _startTime = time;
    }

    function modifyEndTime(uint time) public eventNotEnded onlyRole(CREATOR) {
        require(time >= _startTime, "Invalid Request");
        _endTime = time;
    }

    function modifyEvent(
        string memory metadata
    ) public eventNotEnded onlyRole(CREATOR) {
        _metadata = metadata;
    }

    function invite(address attendee) public onlyRole(CREATOR) eventNotEnded {
        _invite(attendee);
    }

    function _invite(address attendee) private {
        require(
            !(hasRole(INVITED, attendee) || hasRole(RSVPD, attendee)),
            "Invalid Request"
        );
        grantRole(INVITED, attendee);
    }

    function uninvite(address attendee) public onlyRole(CREATOR) eventNotEnded {
        revokeRole(INVITED, attendee);
    }

    function rsvp() public onlyRole(INVITED) eventNotEnded {
        grantRole(RSVPD, msg.sender);
    }
}
