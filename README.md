
# SecureVotingDapp

A secure and decentralized voting system on the Ethereum blockchain, featuring secret voting, vote delegation, and transparent winner determination.

## Description

SecureVotingDapp is a smart contract-based voting system that ensures privacy and security through time-limited secret voting. It allows voters to cast their votes anonymously and reveal them after the voting period, ensuring transparency and integrity.

I used the existing basic solidity example about voting contract given in the documentation and modified it. My modified voting contract is **more secure** because it uses **Time-LimitedVotingPeriod** and **SecretVoting**

**Time-Limited Voting Period**

- The contract constructor now accepts a duration for the voting period in minutes.
- `startTime` and `endTime` are set based on the current block timestamp.
- Modifiers `onlyDuringVoting` and `onlyAfterVoting` ensure certain functions can only be called during or after the voting period, respectively.

**Secret Voting**

- The `vote` function now takes an encrypted vote (`secretVote`) as input.
- The `revealVote` function allows voters to reveal their vote after the voting period by providing the proposal index and a secret key used to encrypt the vote.
- Encrypted votes are stored during the voting period and are only counted when revealed after the voting period ends.

## How It Works

1. **Voting**: During the voting period, voters submit encrypted votes.
   
2. **Revealing Votes**: After the voting period ends, voters reveal their votes by submitting the proposal index and the secret used to encrypt their vote.
   
3. **Counting Votes**: Votes are only counted once they are revealed, ensuring that votes are secret during the voting period.

## Features

- **Time-Limited Voting**: Allows voting within a specified period.
- **Secret Voting**: Voters submit hashed votes to keep their choices private during the voting period.
- **Vote Delegation**: Voters can delegate their voting rights to another trusted voter.
- **Secure Vote Reveal**: Votes are revealed and validated after the voting period using a secret key.
- **Transparent Results**: The winning proposal is determined and can be viewed after the voting period ends.

## Getting Started

### Prerequisites

- Solidity compiler (version ^0.7.0 or newer)
- npm ethers package
- VSCode(for development tools)
- Solidity extensions in VSCode

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/SecretVotingDapp.git
   cd SecretBallot
2. Copy the modifiedVoting.sol file
3. Run it in the online Solidity compiler [remix](https://remix.ethereum.org/)
4. To get the bytesParsed voter address, I used the file "createBytesParse.js" from my parsing folder.
5. Run and deploy it in remix using those addresses.

## Usage

### Constructor

```
constructor(bytes32[] memory proposalNames, uint durationMinutes)
```
* **proposalNames:**  Array of proposal names (up to 32 bytes each).
* **durationMinutes:** Duration of the voting period in minutes.


### Added Functions

    
*   **vote(bytes32 secretVote)** Casts a secret vote. Can only be called during the voting period.
    
*   **revealVote(uint proposal, bytes32 secret)** Reveals and validates your vote after the voting period.
    

    
### Existing Functions
*   **giveRightToVote(address voter)** Grants a voter the right to vote. Can only be called by the chairperson.
    
*   **delegate(address to)** Delegates your vote to another voter. Can only be called during the voting period.

*   **winningProposal() public view returns (uint)** Computes the winning proposal after the voting period.
    
*   **winnerName() public view returns (bytes32)** Returns the name of the winning proposal after the voting period.

### Events

*   **VoteRevealed(address indexed voter, uint proposal)** Emitted when a vote is revealed.

### Learning
I learned basics Solidity within 3 days and built this app to test my knoweldge. I went through the Solidity documentation of voting contract tutorial to learn the basics of contract. I also used this [video](https://www.youtube.com/watch?v=GB3hiiNNDjk) to understand every component of the basic codebase of how voting contract works.