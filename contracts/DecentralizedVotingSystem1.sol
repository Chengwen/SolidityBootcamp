// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.24;

contract DecentralizedVotingSystem {

    error AddressAlreadyVoted(address voter);
    error CandidateNotExists(uint256 candidateId);

    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    mapping(uint => Candidate) private candidates;
    mapping(address => bool) public hasVoted;
    uint public candidatesCount;
    Candidate public winner;

    event CandidateAdded(uint candidateId, string name);
    event VoteCasted(uint candidateId, address voter);
    event WinnerChosen(uint candidateId);

    function addCandidate(string memory _name) public {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
        emit CandidateAdded(candidatesCount, _name);
    }

    function vote(uint _candidateId) public {
        if (hasVoted[msg.sender]) {
            revert AddressAlreadyVoted(msg.sender);
        }
        if (_candidateId == 0 || _candidateId > candidatesCount) {
            revert CandidateNotExists(_candidateId);
        }
        hasVoted[msg.sender] = true;
        candidates[_candidateId].voteCount++;
        emit VoteCasted(_candidateId, msg.sender);
    }

    function chooseTheWinner() public {
        uint winnerId;
        uint highestVoteCount;
        Candidate memory currentCandidate;
        for (uint i = 0; i <= candidatesCount; i++) {
            currentCandidate = candidates[i];
            if (currentCandidate.voteCount > highestVoteCount) {
                highestVoteCount = currentCandidate.voteCount;
                winnerId = currentCandidate.id;
            }
        }
        winner = candidates[winnerId];
        emit WinnerChosen(winnerId);
    }

    function getCandidateVoteCount(uint _candidateId) public view returns(uint) {
        if (_candidateId == 0 || _candidateId > candidatesCount) {
            revert CandidateNotExists(_candidateId);
        }
        return candidates[_candidateId].voteCount;
    }
}