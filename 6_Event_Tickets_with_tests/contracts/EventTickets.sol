// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract EventFactory {

    address[] public deployedEvents;

    function createNewEvent(
        string memory _eventName, 
        uint256 _numberOfTickets, 
        uint256 _ticketPrice
    ) public{
        address newEvent = address(
            new Event(
                _eventName, _numberOfTickets, _ticketPrice,  msg.sender
            )
        );
        deployedEvents.push(newEvent);
    }

    function getDeployedEvents () public view returns (address[] memory){
        return deployedEvents;
    }

}

contract Event {

    address payable eventOwner;

    enum EventStatus { 
        PRESALE,
        FORSALE,
        SOLD
    }

    EventStatus status;

    struct Customer {
        string email;
        uint quantity; 
    }

    mapping(address => Customer) public customers;

    uint256 public numberOfTickets;
    uint256 public ticketPrice;
    uint256 public presalePrice;
    string  public eventName;
    
    uint256 public firstFive;

    modifier onlyOwner() {
        require(eventOwner == msg.sender, "only the admin can perform this action.");
        _;
    }

    modifier isNotSold() {
        require(numberOfTickets > 0, "there are no more tickets.");
        _;
    }
    modifier paidEnough(uint256 _qty) {
        if (status == EventStatus.PRESALE ) {
            require(presalePrice * _qty == msg.value, "you didn't paid enough.");
        } else {
            require(ticketPrice * _qty == msg.value, "you didn't paid enough.");
        }
        _;
    }

    modifier isPreSaleOpen() {
        require(firstFive > 0, 'The event is not open');
        _;
    }

    modifier maxNumberOfTickets(uint256 _qty) {
        require(_qty <= 5, "you can't buy more than 5 tickets");
        _;
    }
    modifier isNotOwner() {
        require(eventOwner != msg.sender, "you can't buy tickets");
        _;
    }
    constructor(
        string memory _eventName,
        uint256 _numberOfTickets,
        uint256 _ticketPrice,
        address _eventOwner
    ) {
        eventOwner = payable(_eventOwner);
        eventName = _eventName;
        numberOfTickets = _numberOfTickets;
        ticketPrice = _ticketPrice;
        presalePrice = ticketPrice / 2;
        status = EventStatus.PRESALE;
        firstFive = 5;
    }

    // first 5 tickets will be sale at 50% discount
    function buyTickets(
        string memory _email, 
        uint _quantity
    ) 
    public 
    payable
    paidEnough(_quantity) 
    maxNumberOfTickets(_quantity) 
    isNotSold
    isNotOwner
    { 
        
        if ( status == EventStatus.PRESALE ) {
            firstFive = firstFive - (1 * _quantity);
            numberOfTickets = numberOfTickets - (1 * _quantity);
            if (firstFive == 0) {
                status = EventStatus.FORSALE;
            }
        } else if ( status == EventStatus.FORSALE) {
            numberOfTickets = numberOfTickets - (1 * _quantity);
            if (numberOfTickets==0) {
                status = EventStatus.SOLD;
            }
        }

        // check if the customer already bought tickets
        if (customers[msg.sender].quantity > 0) {
            customers[msg.sender].email = _email;
            customers[msg.sender].quantity = customers[msg.sender].quantity + _quantity;
        } else {
            Customer storage newCus = customers[msg.sender];
            newCus.email = _email;
            newCus.quantity = _quantity;
        }
    }

    function getEventBalance() public view returns(uint) {
        return address(this).balance;
    }

    function withdrawEventBalance() public onlyOwner {
        require(status == EventStatus.SOLD, "you can't withdraw yet");
        payable(msg.sender).transfer(address(this).balance);
    }

}