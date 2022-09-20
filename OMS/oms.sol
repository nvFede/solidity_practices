// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract oms {
    
    address private _contractOwner;

    /********************************************************************************************/
    /*                                       DATA VARIABLES                                     */
    /********************************************************************************************/
    
    mapping(address => bool) public hospitalValidation;

    // relation between hospital and it's address
    mapping(address => address) public HospitalAddress;

    address[] public validHospitals;

    address[] requests;

    /********************************************************************************************/
    /*                                        EVENTS                                            */
    /********************************************************************************************/

    event newHospitalValidated(address);
    event newHospitalAdded(address, address);
    event accessRequested(address);

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
    modifier isValidHospital(address _hospital) {
        _;
    }

    modifier isValidAddress(address _adr) {
        require(_adr != address(0), "this is not a valid address");
        _;
    }

    /********************************************************************************************/
    /*                                       UTILITY FUNCTIONS                                  */
    /********************************************************************************************/

    function _isOWner() private view returns(bool){
        return _contractOwner == msg.sender;
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
    
    function requestAccessToOMS() public {
        requests.push(msg.sender);
        emit accessRequested(msg.sender);
    }

    function viewAccessRequests() public view onlyOwner returns(address[] memory){
        return requests;
    }

    function validateHospital(address _hospital) public onlyOwner isValidAddress(_hospital) {
        hospitalValidation[_hospital] = true;
        emit newHospitalValidated(_hospital);
    }
   
    function FactoryHospital() public {
        require(hospitalValidation[msg.sender] == true,
            "You don't have permission to perform this action."
        );
        address newHospital = address(new Hospital(msg.sender));

        validHospitals.push(newHospital);

        HospitalAddress[msg.sender] = newHospital;

        emit newHospitalAdded(newHospital, msg.sender);
    }
}

contract Hospital {

    address public hospitalAddress;
    address public contractAddress;

    // Hash[person] = true/false
    mapping(bytes32 => bool) covidTestResult;
    mapping(bytes32 => string) covidTestResultIPFS;

    mapping(bytes32 => PCRResult) covidResults;

    struct PCRResult {
        bool result;
        string IPFSCode;
    }

    event newTestResult(string, bool);

    modifier onlyHospital(address _address) {
        require(hospitalAddress == _address, "you don't have permission.");
        _;
    }

    constructor (address _hospitalAddress)  {
        hospitalAddress = _hospitalAddress;
        contractAddress = address(this);
    }

    function makeHash(string memory _data) internal returns (bytes32) {
        return keccak256(abi.encodePacked(_data));
    }

    function covidTestResultFn( 
        string memory _idPerson, 
        bool _testResult, 
        string memory _IPFSCode
    )  public onlyHospital(msg.sender) {
        
        bytes32 hashPerson = makeHash(_idPerson);
        // covidTestResult[hashPerson] = _testResult;
        // covidTestResultIPFS[hashPerson] = _IPFSCode;

        covidResults[hashPerson] = PCRResult(_testResult, _IPFSCode);
        emit newTestResult(_IPFSCode, _testResult);

    }

    function viewTestResults(string memory _idPerson) public view returns (string memory, string _IPFS){
        
        bytes32 hashPerson = makeHash(_idPerson);

        string memory testResultStr;

        if ( PCRResult[_idPerson].result == true) {
            testResultStr = "Positive";
        } else {
            testResultStr = "Negative";
        }

        return (testResultStr, PCRResult[hashPerson]._IPFSCode);
    }
}