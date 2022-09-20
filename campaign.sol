pragma solidity >=0.7.0 <0.9.0;

contract CampaignFactory {
    address[] public deployedCampaigns;

    function createNewCampaign(string memory _campaignName, uint _minimumContribution) public {
        address newCampaign = address(new Campaign(_campaignName, _minimumContribution, msg.sender));
        deployedCampaigns.push(newCampaign);
    }

     function getDeployedCampaigns () public view returns (address[] memory){
        return deployedCampaigns;
    }

}

contract Campaign {

    address public manager;
    uint public minimumContribution;
    uint public approversCount;
    string public campaignName;

    mapping(address => bool) public contributors; 

    struct Request {
        string description;
        uint value;
        address payable vendor;
        bool complete;
        uint approvalCount;
        mapping(address => bool) approvals;
    }
    Request[] public requests;

    // Verify the manager 
    modifier onlyManager() {
        require(msg.sender == manager, "only the campaign manager can perform this action.");
        _;
    }

     modifier notManager() {
        require(msg.sender != manager);
        _;
    }

    modifier contributeEnough(uint _contribution) {
        require( msg.value >= _contribution, "your contribution is too low.");
        _;
    } 
    
    modifier validContributor() {
        require(contributors[msg.sender]);
        _;
    }

    modifier requestNotCompleted(uint _index) {
        require(!requests[_index].complete);
        _;
    }

    constructor(string memory _campaignName, uint _minimumContribution, address creator) {
        manager = payable(creator);
        minimumContribution = _minimumContribution;
        campaignName = _campaignName;
    }

    function contribute() public payable notManager {
        require(msg.value >= minimumContribution);
        contributors[msg.sender] = true;
        approversCount++;
    }

    function createRequest(string memory _description, uint _value, address payable _vendor)
        public onlyManager {
        Request storage newRequest = requests.push();
        newRequest.description = _description;
        newRequest.value = _value;
        newRequest.vendor = _vendor;
        newRequest.complete = false;
        newRequest.approvalCount = 0;
    }


    function approveRequest(uint _index) public validContributor{

        Request storage request = requests[_index];

        require(!request.approvals[msg.sender]);

        request.approvals[msg.sender] = true;
        request.approvalCount++;

    }

    function finalizeRequest(uint _index) public  onlyManager requestNotCompleted(_index) {
        Request storage request = requests[_index];
        require(request.approvalCount > (approversCount / 2));
        request.vendor.transfer(request.value);
        request.complete == true;
    }

}
