pragma solidity >=0.7.0 <0.9.0;

// It's important to avoid vulnerabilities due to numeric overflow bugs
// OpenZeppelin's SafeMath library, when used correctly, protects agains such bugs
// More info: https://www.nccgroup.trust/us/about-us/newsroom-and-events/blog/2018/november/smart-contract-insecurity-bad-arithmetic/

import "./node_modules/@openzeppelin-solidity/contracts/utils/math/SafeMath.sol";


contract ExerciseC6CApp {
    using SafeMath for uint256; // Allow SafeMath functions to be called for all uint256 types (similar to "prototype" in Javascript)


    address private contractOwner;  // Account used to deploy contract

    modifier requireContractOwner() {
        require(isOwner(), "Caller is not contract owner");
        _;
    }

    modifier requireContractIsNotOwner() {
        require(!isOwner(), "Caller is the  contract owner");
        _;
    }
    
    function isOwner(contractOwner) {
       return msg.sender == contractOwner;
    }

    constructor () {
        contractOwner = msg.sender;
    }

}

