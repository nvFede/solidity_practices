// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract SupplyChain {

    address owner;
    uint skuCount;
    enum State { forSale, Sold, shipped }

    struct Item {
        string name;
        uint sku;
        uint price;
        State state;
        address payable seller;
        address payable buyer;
    }

    mapping ( uint => Item ) items;

    event forSaleEvent(uint skuCount);
    event soldEvent(uint sku); 
    event shippedEvent(uint sku);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action.");
        _;
    }

    modifier buyerDontOwn(uint _sku) {
        require(msg.sender != items[_sku].seller, "You already own this item.");
        _;
    }

    modifier verifyCaller(address _address){
        require(msg.sender == _address, "Can't verify the caller.");
        _;
    }
    modifier paidEnough(uint _price) {
        require( msg.value >= _price, "the offer is too low.");
        _;
    }
    modifier forSale(uint _sku) {
        require( items[_sku].state == State.forSale ,"this item is not for sale.");
        _;
    }
    modifier sold(uint _sku) {
        require( items[_sku].state == State.Sold ,"this item was already sold.");
        _;
    }
    modifier checkValue(uint _sku) {
        _;
        uint _price = items[_sku].price;
        uint amountToRefund = msg.value - _price;
        items[_sku].buyer.transfer(amountToRefund);
    }

    constructor() {
        owner = msg.sender;
        skuCount = 0;
    }

    function addItem(string memory _name, uint _price) public onlyOwner {

        skuCount = skuCount + 1;
        emit forSaleEvent(skuCount);
        items[skuCount] = Item({
            name   : _name,
            sku    : skuCount,
            price : _price,
            state  : State.forSale,
            seller : payable(msg.sender),
            buyer  : payable(0)
        });

    }

    function buyItem(uint _sku) public payable 
        buyerDontOwn(_sku) forSale(_sku) 
        paidEnough(items[_sku].price) 
        checkValue(_sku) {

        address buyer = msg.sender;
        uint price = items[_sku].price;
        //update buyer
        items[_sku].buyer = payable(buyer);
        //update state
        items[_sku].state = State.Sold;
        // transfer money
        items[_sku].seller.transfer(price);
        emit soldEvent(_sku);
    } 

    function viewItem(uint _sku) public view returns(
        string memory name,
        uint sku,
        uint price,
        string memory stateIs,
        address seller,
        address buyer
    ){
        uint state;
        name = items[_sku].name;
        sku = items[_sku].sku;
        price = items[_sku].price;
        state = uint(items[_sku].state);
        if( state == 0 ) {
            stateIs = "For Sale";
        } else if (state == 1) {
            stateIs = "Sold";
        } else {
            stateIs = "Shipped";
        }
        seller = items[_sku].seller;
        buyer = items[_sku].buyer;
    }

    function shipItem(uint _sku) public verifyCaller(items[_sku].seller) {
        require(items[_sku].state == State.Sold, "item is not sold yet");
        items[_sku].state = State.shipped;
        emit shippedEvent(_sku);

    }

}