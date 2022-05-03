// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;


contract Ballot{
    //structure to desceibe a voter
    struct Voter{
        uint weight;//weight is accumulated by delegation
        bool voted; //whether person has voted or not
        address delegate; //person delegated to
        uint vote; //proposal voted for (index)
    }
    struct Proposal{
        bytes32 name;
        uint voteCount;
    }

    //organizer of the balloting event
    address public chairperson;
    //starting time of balloting process
    uint32 public startTime;

    //mapping of each address to their voter object
    mapping(address=> Voter) public voters;

    //list of all submitted proposals
    Proposal[] public proposals;

    //on deployment creates a new ballot 
    constructor(bytes32[] memory  proposalNames){
        chairperson=msg.sender;
        voters[chairperson].weight=1;
        for(uint i=0;i<proposalNames.length;i++){
            proposals.push(Proposal (
                proposalNames[i],
                0
            ));
        }
        startTime=uint32(block.timestamp);
    }

    //modifier to check 
    modifier voteEnded{
        require(uint32(block.timestamp)<= startTime+uint32(5 minutes));
        _;
    }


    //to be only called externally 
    //gives right to vote to other address
    function giveRightToVote(address voter)external{
        require(msg.sender==chairperson, "Only chairperson can give right to vote");//only chairperson can give right to vote
        require(!voters[voter].voted, "This user has voted");
        require(voters[voter].weight == 0);
        voters[voter].weight = 1;
    }
    //delegate your vote to another address to vote on your behalf
    function delegate(address to) external voteEnded{
        Voter storage sender=voters[msg.sender];
        require(!sender.voted,"You have already voted");//make sure you have not voted
        require(to != msg.sender,"You can't self delegate");//makes sure you cant self delegate
        //while loop to xheck if your delegate has a delegate and che
        while(voters[to].delegate != address(0)){
            to=voters[to].delegate;
            require(to != msg.sender,"Found loop in delegation");//makes sure you cant self delegate
        }
        Voter storage delegate_ = voters[to];
        require(delegate_.weight >= 1);//make sure delegate can vote
        sender.voted=true;
        sender.delegate=to;
        if(delegate_.voted){//if delegate has voted increase his vote
            proposals[delegate_.vote].voteCount += sender.weight;
        }else{
            delegate_.weight+=sender.weight;
        }
    }

      

    //give your vote and delegated vote to a proposal
    function vote(uint proposal) external voteEnded {//takes in index of proposal
        Voter storage sender=voters[msg.sender];
        require(sender.weight >0,"This user has no right to vote");
        require(!sender.voted,"This user has voted");
        //set sender voter status to true
        sender.voted=true;
        sender.vote=proposal;

        //increment votecount of proposal by weight of voter
        proposals[proposal].voteCount+=sender.weight;
    }

    //public functions can be called within the contract itself
    function winningProposal()public view returns(uint winningProposal_){//returns the index of the winning proposal
        //loop to continuosuly check votecount and decide winner
        for(uint i=0;i<proposals.length;i++){
            uint winningVoteCount=0;
            if(proposals[i].voteCount >winningVoteCount){
                winningVoteCount=proposals[i].voteCount;
                winningProposal_=i;
            }
        }
        return winningProposal_;
    }

    function winnerName()external view returns (bytes32){
        return proposals[winningProposal()].name;
    }
}