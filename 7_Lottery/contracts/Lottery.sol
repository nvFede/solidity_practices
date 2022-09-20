//SPDX-License-Identifier: MIT 
pragma solidity >=0.7.0 <0.9.0;

contract Lottery {

    // Variables

    address public contractOwner;
    address payable[]  players;

    uint private numberOfPlayers;
    uint private ticketPrice;

    // modifiers 

    modifier onlyOwner() {
        require(isOwner(), "Only the owner can perform this action.");
        _;
    }
    modifier notOwner() {
        require(!isOwner(), "The owner can't join the loterry");
        _;
    }
    modifier paidEnough() {
        require(msg.value == ticketPrice, "Please paid the correct amount.");
        _;
    }
    // events

    event newWinner(address);
    
    // Utility Functions
    
    function isOwner() private view returns(bool){
        return contractOwner == msg.sender;
    }

    function randomNumber() private view returns(uint) {
        return uint(keccak256(abi.encodePacked(
                block.timestamp, block.difficulty, block.number, players
            ))) ;
        
    }

    // constructor

    constructor() {
        contractOwner = msg.sender;
        ticketPrice = 1 ether;
    }

    // contract functions

    function viewTicketPrice() external view returns(uint){
        return ticketPrice;
    }

    function viewCurrentJackpot() public view returns(uint) {
        return address(this).balance;
    }

    function viewNumberOfPlayers() public view onlyOwner returns(uint) {
        return numberOfPlayers;
    }

    function buyTicket() payable public notOwner paidEnough {
        players.push(payable(msg.sender));
        numberOfPlayers++;
    }

    function pickWinner() public onlyOwner {
        uint winner = randomNumber() % players.length;
        
        numberOfPlayers = 0;
        players[winner].transfer(address(this).balance);

        emit newWinner(players[winner]);

        delete players;
    }


}