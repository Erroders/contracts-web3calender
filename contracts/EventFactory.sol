// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.9;

import "./Event.sol";

contract EventFactory {
    constructor() {}

    event EventCreated(
        address indexed eventAddress,
        uint256 stime,
        uint256 etime,
        string metadata,
        address[] attendees
    );

    function createEvent(
        uint256 stime,
        uint256 etime,
        string memory metadata,
        address[] memory attendees
    ) public {
        Event e = new Event(stime, etime, metadata, attendees, msg.sender);
        emit EventCreated(address(e), stime, etime, metadata, attendees);
    }
}
