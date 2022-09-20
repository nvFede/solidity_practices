// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract EventTickets {

    address payable EventOwner;

    enum EventStatus { 
        FORSALE,
        SOLD
    }

    struct Event {
        uint id;
        string name;
        uint price;
        uint totalTickets;
        EventStatus status;
    }

    Event[] public events;

    modifier isNotSold(uint id) {
        require(events[id].totalTickets > 0, "there are no more tickets.");
        _;
    }
    modifier paidEnough(uint id) {
        require(msg.value == events[id].price, "you didn't paid enough.");
        _;
    }

    constructor() {
        EventOwner = payable(msg.sender);
    }

    function addEvent(
        string memory _name, 
        uint _price, 
        uint _totalTickets
    ) public {
        uint eventId = events.length + 1;
        events.push( Event(eventId, _name, _price, _totalTickets, EventStatus.FORSALE));
    }

    // function closePreSale(uint id) {
    //     events[]
    // }
}