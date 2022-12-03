// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.9;

import "./Event.sol";

contract EventFactory {
    constructor() {}

    function createEvent(
        uint stime,
        uint etime,
        string memory metadata,
        address[] memory attendees
    ) public returns (address) {
        Event e = new Event(stime, etime, metadata, attendees, msg.sender);
        return address(e);
    }
}
