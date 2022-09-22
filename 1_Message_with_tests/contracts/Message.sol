//SPDX-License-Identifier: MIT 
pragma solidity >=0.7.0 <0.9.0;

contract Message {

    string private message;

    function setMessage(string memory _message) public{

        require(bytes(_message).length > 0, "Please write a message");

        message = _message;
    }

    function viewMessage() public view returns(string memory) {
        return message;
    }

}