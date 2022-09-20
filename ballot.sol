// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

//import "@https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

//contract Ballot is Ownable {
contract BallotSystem {

    // ballot owner and creator
    address owner;

    // count the candidates to set individual ID
    uint candidatesCount;

    // the state of the current ballot
    enum BallotState {
        Open,
        Close
    }

    // candidate struct
    struct Candidate {
        uint    candidateId;
        string  name;
        string  party;
        uint    votes;
    }

    // ballot struct
    struct Ballot {
        uint        ballotId;
        string      ballotName;
        Candidate[] candidatesList;
        BallotState state;
    }

    // voters struct
    struct Voter {
        address voterAdr;
        bool    voted;
    }
    
    mapping(address => bool) public voters;

    Ballot ballot;

    //events
    event candidateAdded(Candidate candidate);

    // check if the caller is the owner
    modifier onlyOwner() {
        require( msg.sender == owner, "Only the owner can perform this action." );
        _;
    }

    // check if the ballot is open for voting
    modifier isBallotOpen() {
        require(ballot.state == BallotState.Open, "The ballot is closed");
        _;
    }

    // not already vote
    modifier hasVotes() {
        //require(msg.sender)
        _;
    }

    // constructor
    constructor(string memory _ballotName) {
        owner = msg.sender;
        ballot.ballotName = _ballotName;
        candidatesCount = 0;
    }

    // create/add candidate list
    function addCandidate(string memory _name, string memory _party) public onlyOwner {
        Candidate memory _candidate;
        _candidate =  Candidate({
            candidateId : candidatesCount + 1,
            name        : _name,
            party       : _party,
            votes       : 0
        });
        ballot.candidatesList.push(_candidate);
        emit candidateAdded(_candidate);
    }  

    function voteForCandidate(uint _candidateId) public isBallotOpen hasVotes {
        
        uint currentVotes = ballot.candidatesList[_candidateId].votes;
        ballot.candidatesList[_candidateId].votes = currentVotes + 1;
        //emit newVote();
    } 

    function viewCandidates()  public view returns (string[] memory) {

        string[] memory _name = new String();

        for (uint i = 0; i < ballot.candidatesList.length; i++) {
            _name[i] = ballot.candidatesList[i].name;
        }
        return _name;
    } 

}