// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Airport {

    address payable OWNER;

    // enum FlightStatus {
    //     ONTIME,
    //     DELAYED,
    //     CANCELLED,
    //     ARRIVED
    // }

    struct Passenger {
        uint passengerId;
        string firstName;
        string lastName;
    }

    // struct DateTime {
    //     uint16 year;
    //     uint8 month;
    //     uint8 day;
    //     uint8 hour;
    //     uint8 minute;
    // }

     struct Airplane {
        uint airplaneId;
        string modelName;
        uint capacity;
    }

    struct Flight {
        uint flightId;
        string origin;
        string destination;
        uint price;
        //DateTime departure;
        // FlightStatus status;
        Airplane airplane;
    }

    Flight[] public flights;
    Airplane[] public airplanes;

    mapping(address  => Passenger) public passengers;
    mapping(address => Flight[]) public passengersFlights;
    mapping(address => uint) public passengerTotalFlights;

    event NewAirplaneAdded(
        uint airplaneId,
        string 
    );
    event FlightCreated(
        uint flightID,
        string _origin,
        string  _destination,
        uint _price,
        //DateTime _departure,
        Airplane _airplane
    );
    event FlightCancelled();
    event FlightDelayed();
    event FlightPurchased(
        address indexed passenger,
        uint flightId,
        string origin, 
        string destination, 
        uint price
    );
    

    modifier onlyOwner() {
        require( OWNER == msg.sender);
        _;
    }

    modifier paidEnough(uint _id) {
        //require( msg.value == Flight(_id).price);
        _;
    }
    modifier availableSeats(uint seat){
        //require( );
        _;
    }
    
    constructor() {
        OWNER == payable(msg.sender);
    }

    // the airline bought a new plane
    function addPlane(string memory _modelName, uint _capacity) public {

        uint airplaneId =  airplanes.length + 1;

        airplanes.push( Airplane(airplaneId, _modelName, _capacity));
        
        emit NewAirplaneAdded();
    }

    // create a new flight
    function createNewFlight(
        string memory _origin, 
        string memory _destination, 
        uint _price,
        //DateTime memory _departure,
        Airplane memory _airplane
    ) public  onlyOwner {
        uint flightID =  flights.length + 1;
        flights.push(Flight(flightID, _origin, _destination, _price, _airplane));
        
        emit FlightCreated(flightID, _origin, _destination, _price, _airplane);
    }

    // a passenger can purchase a flight
    function buyFlight(uint _flightId) public payable {
        
        Flight memory flight = flights[_flightId];
        require(msg.value == flight.price);
        
        // seats available
        // require()
        flight.s
        Passenger storage passenger = passengers[msg.sender];
        passengersFlights[msg.sender].push(flight);
        passengerTotalFlights[msg.sender] ++;
        
        //emit FlightPurchased();

    }

    // update flight status (ON TIME, DELAYED, CANCELLED)
    function updateFlightStatus() public {



    }
    

    // the airline can check his own balance
    function checkAirlineBalance() public view onlyOwner returns(uint) {
        return OWNER.balance;
    }

    // a passenger can change his ticket
    // a passenger can be refunded 

}