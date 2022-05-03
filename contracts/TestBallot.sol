// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;
import "./Ballot.sol";

contract TestBallot is Ballot{
    constructor(bytes32[] memory proposals) Ballot(proposals){ }
    function setDate()public {
        startTime= uint32(block.timestamp+6 minutes);
    }
     function getProposals()public view returns(bytes32,bytes32) {
        return (proposals[0].name,proposals[1].name);
}
    function getWeight(address _address)public view returns(uint){
        return voters[_address].weight;
    }


}