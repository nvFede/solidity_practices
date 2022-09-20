//SPDX-License-Identifier: MIT 
pragma solidity >=0.7.0 <0.9.0;


/// @dev | fallback is a function that does not take any arguments and does not return anything
/* 
    - function doesn't exists or
    - Ether is sent directly to a contract but receive() does not exist or
        | msg.data is not empty
*/


contract FallbackTest {

    event Log(string func, address sender, uint value, bytes data);

    fallback() external payable{
        emit Log(
            "fallback() function executed",
            msg.sender, 
            msg.value,   
            msg.data 
        );
    }

    receive() external payable{
        emit Log(
            "receive() function executed",
            msg.sender, 
            msg.value,   
            ""
        );
    }
}