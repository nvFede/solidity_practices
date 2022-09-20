// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
pragma experimental ABIEncoderV2;

contract CallerContract{
    uint256 public value;
    address public sender;
    string  public name;
    
    constructor() payable{
  
    }
    
    function testDelegateCall(string memory _name, TargetContractDelegate tc) public payable{
        value  = msg.value;
        sender = msg.sender;
        name   = _name;
        (bool success, bytes memory data) = payable(address(tc)).delegatecall(
            abi.encodeWithSelector(TargetContractDelegate.targetFunction.selector, "Some Name")
            );
    }
    
}

contract TargetContractDelegate{
    uint256 public value;
    address public sender;
    string  public name;
      
    function targetFunction(string memory _nameTarget) public payable{
        value       = msg.value;
        sender      = msg.sender;
        name        = _nameTarget;
    }

    function getValues() public view returns(string memory, address, uint) {
        return (name, sender, value);
    }
}