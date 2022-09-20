//SPDX-License-Identifier: MIT 
pragma solidity >=0.7.0 <0.9.0;

/*******************************
1. Un cliente puede abrir una cuenta
    - Chequear que la cuenta no existe - Solo puede haber un usuario por cuenta
    - chequear que el cliente deposita el importe minimo
2. Un cliente puede depositar dinero
    - Chequear que el cliente ya tiene una cuenta en el banco
    - Chequear 
3. Un cliente puede retirar dinero 
    - chequear que el cliente tiene suficiente dinero
4. Un cliente puede ver su balance 
    - Chequear que solo este usuario puede ver su cuenta
5. Un cliente puede cerrar sus cuenta 
    - Si la cuenta existe, el cliente puede cerrarla y llevarse su dinero

1. el banco puede ver el balance del contrato
    - Chequear que solo el banco puede hacerlo
3. el banco puede puede ver cuantos clientes tiene
4. el banco puede cambiar el deposito minimo para abrir cuenta 
    - Chequear que el monto no es el mismo que el anterior



*******************************/ 

//require(userInfo[msg.sender].userAddress != address(0));

contract PrivateBank {

    address public owner;

    mapping(address  => uint256) balances;

    uint private contractBalance;
    uint private clientCount;
    uint private minimumDeposit; 

    function createAccount() public payable{
        require(balances[msg.sender] != 0);


    }
    function depositFunds() public payable{
        // check if the user has an account
        require(balances[msg.sender] > 0);

    }
    function withdrawFunds() public payable returns(uint){
        require(balances[msg.sender] > 0);
        require(balances[msg.sender] > msg.value);
        
    }
    function viewBalance() public view returns(uint){
        require()
    }
    function closeAccount() public payable{
        require(balances[msg.sender] > 0);
    }

    function viewBankBalance() public view returns(uint){}
    function viewClients() public view returns(uint){}
    function changeMiniumDeposit() public {}

}