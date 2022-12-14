//SPDX-License-Identifier: MIT 
pragma solidity >=0.7.0 <0.9.0;

contract privateBank {

    address payable public BANK_MANAGER;
    uint public contractBalance;
    uint public clientCount;

    struct Account {
        address owner;
        uint balance;
        uint accountCreated;
    }

    uint public minimumInicialDeposit;

    mapping(address  => Account) accounts;

    modifier onlyBankManager() {
        require(BANK_MANAGER == msg.sender, "Only the bank manager can perform this action.");
        _;
    }
    modifier isValidAddress() {
        _;
    }
    modifier minimumDeposit() {
        require(msg.value >= minimumInicialDeposit, "Doesn't follow minimum criteria");
        _;
    }
    modifier checkAccountExists() {
        require(accounts[msg.sender].owner == msg.sender, "this account don't exists");
        _;
    }

    modifier onlyAccountOwner() {
        require(accounts[msg.sender].owner == msg.sender, "only the owner of the account can check the balance");
        _;
    }

    event newClientEnrolled(address indexed, uint, uint);
    event withdrawalDone(address indexed, uint, uint);
    event accountClosed(address indexed, uint, uint);
    event fundsDeposited(address indexed, uint, uint);
    event miniumDepositChanged(uint);

    constructor() {
        BANK_MANAGER = payable(msg.sender);
        minimumInicialDeposit = 10 ether;
        clientCount = 0;
    }

    function enrollClient() public payable minimumDeposit returns(bool) {
        clientCount++;
        contractBalance += msg.value;
        accounts[msg.sender].owner = msg.sender;
        accounts[msg.sender].balance = msg.value;
        accounts[msg.sender].accountCreated = block.timestamp;
        
        emit newClientEnrolled(msg.sender, msg.value, block.timestamp);
        return true;
    }

    function depositFunds() public payable checkAccountExists {
        accounts[msg.sender].balance += msg.value;
        emit fundsDeposited(msg.sender, msg.value, block.timestamp);
    }

    function withdrawFunds(uint _amount) public payable checkAccountExists returns(uint) {
      
        require(accounts[msg.sender].balance >= _amount);
        
        payable( msg.sender).transfer(_amount);
        accounts[msg.sender].balance -= _amount;

        uint remainingBalance = accounts[msg.sender].balance;
        emit withdrawalDone(msg.sender, _amount, block.timestamp);

        return remainingBalance;
    }

    function closeAccount() public payable checkAccountExists returns(bool){
        address payable withdrawTo = payable(msg.sender);
        require(accounts[msg.sender].balance >= 0);

        uint currentBal = accounts[msg.sender].balance;
        accounts[msg.sender].balance -= currentBal;
        withdrawTo.transfer(currentBal);
        
        clientCount--;
        delete accounts[msg.sender];
        
        emit accountClosed(msg.sender, msg.value, block.timestamp);
        
        return true;

    }

    function viewClientsCount() public view onlyBankManager returns(uint) {
        return clientCount;
    }

    function viewcontractBalance() public view onlyBankManager returns(address, uint) {
        return (address(this), address(this).balance);
    }

    function changeMiniumDeposit(uint _minimum) public onlyBankManager{
        minimumInicialDeposit = _minimum * 1 ether;
        emit miniumDepositChanged(minimumInicialDeposit);
    }

    function checkAccountBalance() public view onlyAccountOwner returns(uint) {
        return accounts[msg.sender].balance;
    }

}