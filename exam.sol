// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract Exam {

    // Teacher = contract creator address
    address public teacher;

    constructor() {
        teacher = msg.sender;
    }

    mapping (bytes32 => uint) Note;

    string [] revisions;

    event studentEval(bytes32);
    event eventRevision(string);

    modifier onlyTeacher(address _address) {
        require(_address == teacher, "Only the teacher can execute this funciton. ");
        _;
    }

    function evaluate(string memory _idStudent, uint _note) public onlyTeacher(msg.sender) {
        bytes32 hash_id = keccak256(abi.encodePacked(_idStudent));
        Note[hash_id] = _note;
        emit studentEval(hash_id);
    }

    function viewNotes(string memory _idStudent) public view returns(uint) {
        bytes32 hash_id = keccak256(abi.encodePacked(_idStudent));
        return Note[hash_id];
    }

    function calificationReview(string memory _idStudent) public {
        revisions.push(_idStudent);
        emit eventRevision(_idStudent);
    }

    function viewRevisions() public view onlyTeacher(msg.sender) returns(string [] memory) {
        return revisions;
    }

}