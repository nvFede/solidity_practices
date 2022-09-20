pragma solidity>=0.7.0 <0.9.0;

contract Auction{
    address payable public beneficiary;
    uint public auctionEndTime;
    
    // current state of the auction 
    address public highestBidder;
    uint public highestBid; 
    bool ended;
    
    mapping(address => uint) pendingReturns;
    
    event highestBidIncreased(address bidder, uint amount);
    event auctionEnded(address winner, uint amount);
    
    constructor(uint _biddingTime, address payable _beneficiary) {
        beneficiary = _beneficiary;
        auctionEndTime = block.timestamp + _biddingTime; 
    }

    modifier auctionIsOpen() {
        require(block.timestamp < auctionEndTime,'The Auction Time Is Over');
        _;
    }

    function bid() public payable auctionIsOpen{
        if(msg.value > highestBid) {
            
            if(pendingReturns[msg.sender]>0)
            {
                uint amount = pendingReturns[msg.sender];
                payable(msg.sender).transfer(amount);
            }

            pendingReturns[msg.sender] = msg.value; 
            highestBidder = msg.sender;
            highestBid = msg.value;
            emit highestBidIncreased(msg.sender, msg.value);
        }
        else {
            revert('sorry, the bid is not high enough!');
        }
     }
     function withdraw() public payable returns(bool) {
        require(ended,"You Cannot Withdraw Until The Auction Has Ended");
        uint amount = pendingReturns[msg.sender];
        if(amount > 0) {
            pendingReturns[msg.sender] = 0;
        }
        
        if(!payable(msg.sender).send(amount)) {
            pendingReturns[msg.sender] = amount;
        }
        return true;
    }
    function auctionEnd() public auctionIsOpen{
        //require(block.timestamp > auctionEndTime,'The Auction Cannot End Before The Specified Time');
        if(ended) revert('the auction is already over!');
        ended = true;
        emit auctionEnded(highestBidder, highestBid);
        beneficiary.transfer(highestBid);
    }
}