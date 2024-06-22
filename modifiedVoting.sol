// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/** 
 * @title Ballot
 * @dev Implements voting process along with vote delegation and time-limited secret voting
 */
contract Ballot {

    struct Voter {
        uint weight; // weight is accumulated by delegation
        bool voted;  // if true, that person already voted
        address delegate; // person delegated to
        uint vote;   // index of the voted proposal
        bytes32 secretVote; // encrypted vote
    }

    struct Proposal {
        bytes32 name;   // short name (up to 32 bytes)
        uint voteCount; // number of accumulated votes
    }

    address public chairperson;
    uint public startTime; // to keep track of the start time of voting
    uint public endTime; // to keep track of end time of voting

    mapping(address => Voter) public voters;
    Proposal[] public proposals;

    // Event to log when a vote is revealed
    event VoteRevealed(address voter, uint proposal);

    /** 
     * @dev Create a new ballot to choose one of 'proposalNames'.
     * @param proposalNames names of proposals
     * @param durationMinutes voting duration in minutes
     */
    constructor(bytes32[] memory proposalNames, uint durationMinutes) {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;

        // Initialize proposals from the provided names
        for (uint i = 0; i < proposalNames.length; i++) {
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
        
        startTime = block.timestamp; // Set the start time to the current block timestamp
        endTime = startTime + durationMinutes * 1 minutes; // Set the end time to the start time plus the duration in minutes
    }

    // Modifier to check if the current time is within the voting period
    modifier onlyDuringVoting() {
        require(block.timestamp >= startTime, "Voting has not started yet.");
        require(block.timestamp <= endTime, "Voting period has ended.");
        _;
    }

    // Modifier to check if the current time is after the voting period
    modifier onlyAfterVoting() {
        require(block.timestamp > endTime, "Voting period has not ended yet.");
        _;
    }

    /** 
     * @dev Give 'voter' the right to vote on this ballot. May only be called by 'chairperson'.
     * @param voter address of voter
     */
    function giveRightToVote(address voter) public {
        require(msg.sender == chairperson, "Only chairperson can give right to vote.");
        require(!voters[voter].voted, "The voter already voted.");
        require(voters[voter].weight == 0, "Voter already has right to vote.");
        voters[voter].weight = 1;
    }

    /** 
     * @dev Delegate your vote to the voter 'to'.
     * @param to address to which vote is delegated
     */
    function delegate(address to) public onlyDuringVoting {
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "You already voted.");
        require(to != msg.sender, "Self-delegation is disallowed.");

        // Forward the delegation as long as 'to' has delegated to someone else
        while (voters[to].delegate != address(0)) {
            to = voters[to].delegate;
            require(to != msg.sender, "Found loop in delegation.");
        }
        sender.voted = true;
        sender.delegate = to;
        Voter storage delegate_ = voters[to];
        if (delegate_.voted) {
            // If the delegate already voted,
            // directly add to the number of votes
            proposals[delegate_.vote].voteCount += sender.weight;
        } else {
            // If the delegate did not vote yet,
            // add to her weight.
            delegate_.weight += sender.weight;
        }
    }

    /** 
     * @dev Give your vote (including votes delegated to you) to proposal 'proposals[proposal].name'.
     * @param secretVote hash of the proposal index and a secret
     */
    function vote(bytes32 secretVote) public onlyDuringVoting {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "Has no right to vote");
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        sender.secretVote = secretVote;
    }

    /** 
     * @dev Reveal your vote for proposal 'proposal' using the secret.
     * @param proposal index of proposal in the proposals array
     * @param secret secret used to create the hashed vote
     */
    function revealVote(uint proposal, bytes32 secret) public onlyAfterVoting {
        Voter storage sender = voters[msg.sender];
        require(sender.voted, "No vote to reveal.");
        require(sender.secretVote == keccak256(abi.encodePacked(proposal, secret)), "Invalid vote reveal.");

        proposals[proposal].voteCount += sender.weight;
        emit VoteRevealed(msg.sender, proposal);
    }

    /** 
     * @dev Computes the winning proposal taking all previous votes into account.
     * @return winningProposal_ index of winning proposal in the proposals array
     */
    function winningProposal() public view onlyAfterVoting returns (uint winningProposal_) {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
    }

    /** 
     * @dev Calls winningProposal() function to get the index of the winner contained in the proposals array and then
     * @return winnerName_ the name of the winner
     */
    function winnerName() public view onlyAfterVoting returns (bytes32 winnerName_) {
        winnerName_ = proposals[winningProposal()].name;
    }
}
