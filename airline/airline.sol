// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Airline is Ownable{

    address payable contractOwner;

    struct Client {
        uint clientID;
        uint256 fidelityPts;
        uint256 totalFlights;
    }

    struct Flight {
        uint flightID;
        string origin;
        string destination;
        uint256 price;
    }

    uint256 etherPerPoints = 0.1 ether;

    Flight[] public flights;

    mapping(address  => Client) public clients;
    mapping(address => Flight[]) public clientsFlights;
    mapping(address => uint) public clientTotalFlights;

    event FlightAdded(string origin, string destination, uint price);
    event FlightPurchased(address indexed client,uint flightID, string origin, string destination, uint price);
    
    constructor() {
        contractOwner == payable(msg.sender);
    }

    function addFlight(string memory _origin, string memory _destination, uint _price) public  onlyOwner {
        uint flightID =  flights.length + 1;
        flights.push(Flight(flightID, _origin, _destination, _price));
        emit FlightAdded(_origin, _destination, _price);
    }

    function buyFlight(uint _flightID) public payable {
        Flight memory flight = flights[_flightID];
        require(msg.value == flight.price);

        Client storage client = clients[msg.sender];
        client.fidelityPts += 10;
        client.totalFlights += 1;
        clientsFlights[msg.sender].push(flight);
        clientTotalFlights[msg.sender] ++;

        emit FlightPurchased(msg.sender, flight.flightID, flight.origin, flight.destination, flight.price);

    }

    function gettTotalFlights() public view returns (uint) {
        return flights.length;
    }

    function redeemFidelityPts() public {
        Client storage client = clients[msg.sender];
        uint ethToRefund = etherPerPoints * client.fidelityPts;
        client.fidelityPts = 0;
        payable(msg.sender).transfer(ethToRefund);       
    }

    function getRefundableEther() public view returns (uint) {
        return etherPerPoints * clients[msg.sender].fidelityPts;
    }

    function getAirlineBalance() public view onlyOwner returns(uint) {
        return contractOwner.balance;
    }


}