pragma solidity >=0.7.0 <0.9.0;

contract Votacion {

    address private _contractOwner;

    /********************************************************************************************/
    /*                                       DATA VARIABLES                                     */
    /********************************************************************************************/
    
    enum votingStatus { 
        Open,
        Close
    }

    struct Candidate {
        string name;
        uint8 age;
        string party;
        uint256 votes;
    }
    
    mapping(string => bytes32) candidateId;
    mapping(string => uint) candidateVotes;
    string[] candidates;
    //bytes32[] voters;
    mapping(address => bool) voters;

    /********************************************************************************************/
    /*                                        EVENTS                                            */
    /********************************************************************************************/

    event candidateAdded();


    /********************************************************************************************/
    /*                                       FUNCTION MODIFIERS                                 */
    /********************************************************************************************/

    // Modifiers help avoid duplication of code. They are typically used to validate something
    // before a function is allowed to be executed.

    modifier onlyOwner() {
        require(_isOWner(), "only the contract owner can execute this function." );
        _;
    }
    modifier isNotOwner() {
        require(!_isOWner(), "the contract owner can't execute this function." );
        _;
    }
    modifier isValidVoter(address _voter) {

    }

    /********************************************************************************************/
    /*                                       UTILITY FUNCTIONS                                  */
    /********************************************************************************************/

    function _isOWner() private view {
        return _contractOwner == msg.sender;
    }

     /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    /********************************************************************************************/
    /*                                       CONSTRUCTOR                                        */
    /********************************************************************************************/

    constructor() {
        _contractOwner = msg.sender;   
    }

    /********************************************************************************************/
    /*                                     SMART CONTRACT FUNCTIONS                             */
    /********************************************************************************************/

    function addCandidate(string memory _name, uint _age, string memory) public {
        
        emit candidateAdded();
    }

}