//SPDX-License-Identifier: MIT 
pragma solidity >=0.7.0 <0.9.0;

contract Ownable {
    address private owner;

    modifier onlyOwner {
        require(owner == msg.sender, "only the owner can perform this action.");
        _;
    }

    modifier notEmptyString(string memory _message) {
        require(bytes(_message).length > 0, "Please insert a message");
        _;
    }

    constructor() {
        owner = msg.sender;
    }
}

contract Message is Ownable{

    string public message;
    string private privateMessage;

    function setMessage(string memory _message) public notEmptyString(_message) {
        message = _message;
    }

    function setPrivateMessage(string memory _message) public onlyOwner  notEmptyString(_message) {
        privateMessage = _message;
    }

    function viewMessage() public view returns(string memory) {
        return message;
    }

    function viewPrivateMessage() public view returns(string memory) {
         return privateMessage;
    }

}