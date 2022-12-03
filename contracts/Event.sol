// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract Event is AccessControl {
    uint256 public _startTime;
    uint256 public _endTime;
    string private _metadata;

    enum RSVPResponse {
        YES,
        NO,
        MAYBE
    }

    bytes32 public constant CREATOR = keccak256("CREATOR");
    bytes32 public constant INVITED = keccak256("INVITED");
    bytes32 public constant RSVPD = keccak256("RSVPD");

    modifier eventNotEnded() {
        require(_endTime > block.timestamp, "Invalid Request");
        _;
    }

    // events
    event StartTimeModified(address indexed eventAddress, uint256 newSTime);
    event EndTimeModified(address indexed eventAddress, uint256 newETime);
    event MetadataModified(address indexed eventAddress, string newMetadata);
    event AttendeeInvited(
        address indexed eventAddress,
        address indexed attendee
    );
    event AttendeeUninvited(
        address indexed eventAddress,
        address indexed attendee
    );
    event AttendeeRsvpd(
        address indexed eventAddress,
        address indexed attendee,
        RSVPResponse response
    );
    event CommentAdded(address indexed eventAddress, string commment);

    constructor(
        uint256 stime,
        uint256 etime,
        string memory metadata,
        address[] memory attendees,
        address creator
    ) {
        require(stime >= block.timestamp, "Invalid Start Time");
        require(etime >= _startTime, "Invalid End Time");
        grantRole(DEFAULT_ADMIN_ROLE, address(this));
        grantRole(CREATOR, creator);
        _metadata = metadata;
        for (uint256 i = 0; i < attendees.length; i++) {
            _invite(attendees[i]);
        }
    }

    // update start time
    function modifyStartTime(uint256 time)
        public
        eventNotEnded
        onlyRole(CREATOR)
    {
        require(time >= block.timestamp, "Invalid Request");
        _startTime = time;
        emit StartTimeModified(address(this), time);
    }

    // update end time
    function modifyEndTime(uint256 time)
        public
        eventNotEnded
        onlyRole(CREATOR)
    {
        require(time >= _startTime, "Invalid Request");
        _endTime = time;
        emit EndTimeModified(address(this), time);
    }

    // update event metadata
    function modifyEvent(string memory metadata)
        public
        eventNotEnded
        onlyRole(CREATOR)
    {
        _metadata = metadata;
        emit MetadataModified(address(this), metadata);
    }

    // invite new attendee
    function invite(address attendee) public onlyRole(CREATOR) eventNotEnded {
        _invite(attendee);
    }

    function _invite(address attendee) private {
        require(
            !(hasRole(INVITED, attendee) || hasRole(RSVPD, attendee)),
            "Invalid Request"
        );
        grantRole(INVITED, attendee);
        emit AttendeeInvited(address(this), attendee);
    }

    function uninvite(address attendee) public onlyRole(CREATOR) eventNotEnded {
        revokeRole(INVITED, attendee);
        emit AttendeeUninvited(address(this), attendee);
    }

    function rsvp(RSVPResponse response)
        public
        onlyRole(INVITED)
        eventNotEnded
    {
        grantRole(RSVPD, msg.sender);
        emit AttendeeRsvpd(address(this), msg.sender, response);
    }

    function addComment(string memory commment)
        public
        onlyRole(CREATOR)
        eventNotEnded
    {
        // emit event
        emit CommentAdded(address(this), commment);
    }
}
