// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract VotingSystem {
    // Structs
    struct Candidate {
        uint256 id;
        string name;
        uint256 voteCount;
    }
    
    struct Election {
        uint256 id;
        string title;
        string description;
        uint256 startTime;
        uint256 endTime;
        bool finalized;
        uint256 totalVotes;
    }
    
    // State variables
    address public admin;
    uint256 public electionCount;
    
    // Mappings
    mapping(uint256 => Election) public elections;
    mapping(uint256 => Candidate[]) public electionCandidates;
    mapping(uint256 => mapping(address => bool)) public hasVoted;
    mapping(uint256 => mapping(address => bool)) public isEligible;
    
    // Events
    event ElectionCreated(uint256 indexed electionId, string title, uint256 startTime, uint256 endTime);
    event VoterRegistered(uint256 indexed electionId, address indexed voter);
    event VoteCast(uint256 indexed electionId, address indexed voter, uint256 candidateId);
    event ElectionFinalized(uint256 indexed electionId);
    event CandidateUpdated(uint256 indexed electionId, uint256 candidateId, string newName);
    event CandidateRemoved(uint256 indexed electionId, uint256 candidateId);
    event ElectionDeleted(uint256 indexed electionId);
    
    // Modifiers
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }
    
    modifier electionExists(uint256 _electionId) {
        require(_electionId > 0 && _electionId <= electionCount, "Election does not exist");
        _;
    }
    
    modifier electionActive(uint256 _electionId) {
        Election memory election = elections[_electionId];
        require(block.timestamp >= election.startTime, "Election has not started yet");
        require(block.timestamp <= election.endTime, "Election has ended");
        require(!election.finalized, "Election has been finalized");
        _;
    }
    
    constructor() {
        admin = msg.sender;
    }
    
    // Create a new election
    function createElection(
        string memory _title,
        string memory _description,
        uint256 _startTime,
        uint256 _endTime,
        string[] memory _candidateNames
    ) public onlyAdmin {
        require(_startTime < _endTime, "Invalid time range");
        require(_candidateNames.length >= 2, "At least 2 candidates required");
        
        electionCount++;
        
        elections[electionCount] = Election({
            id: electionCount,
            title: _title,
            description: _description,
            startTime: _startTime,
            endTime: _endTime,
            finalized: false,
            totalVotes: 0
        });
        
        // Add candidates
        for (uint256 i = 0; i < _candidateNames.length; i++) {
            electionCandidates[electionCount].push(Candidate({
                id: i,
                name: _candidateNames[i],
                voteCount: 0
            }));
        }
        
        emit ElectionCreated(electionCount, _title, _startTime, _endTime);
    }
    
    // Register eligible voters
    function registerVoters(uint256 _electionId, address[] memory _voters) 
        public 
        onlyAdmin 
        electionExists(_electionId) 
    {
        for (uint256 i = 0; i < _voters.length; i++) {
            isEligible[_electionId][_voters[i]] = true;
            emit VoterRegistered(_electionId, _voters[i]);
        }
    }
    
    // Cast a vote
    function vote(uint256 _electionId, uint256 _candidateId) 
        public 
        electionExists(_electionId)
        electionActive(_electionId)
    {
        require(isEligible[_electionId][msg.sender], "You are not eligible to vote");
        require(!hasVoted[_electionId][msg.sender], "You have already voted");
        require(_candidateId < electionCandidates[_electionId].length, "Invalid candidate");
        
        hasVoted[_electionId][msg.sender] = true;
        electionCandidates[_electionId][_candidateId].voteCount++;
        elections[_electionId].totalVotes++;
        
        emit VoteCast(_electionId, msg.sender, _candidateId);
    }
    
    // Get all candidates for an election
    function getCandidates(uint256 _electionId) 
        public 
        view 
        electionExists(_electionId)
        returns (Candidate[] memory) 
    {
        return electionCandidates[_electionId];
    }
    
    // Get election details
    function getElection(uint256 _electionId) 
        public 
        view 
        electionExists(_electionId)
        returns (Election memory) 
    {
        return elections[_electionId];
    }
    
    // Check if address has voted
    function checkIfVoted(uint256 _electionId, address _voter) 
        public 
        view 
        electionExists(_electionId)
        returns (bool) 
    {
        return hasVoted[_electionId][_voter];
    }
    
    // Check if address is eligible
    function checkEligibility(uint256 _electionId, address _voter) 
        public 
        view 
        electionExists(_electionId)
        returns (bool) 
    {
        return isEligible[_electionId][_voter];
    }
    
    // Finalize election (only after end time)
    function finalizeElection(uint256 _electionId) 
        public 
        onlyAdmin 
        electionExists(_electionId)
    {
        Election storage election = elections[_electionId];
        require(block.timestamp > election.endTime, "Election is still active");
        require(!election.finalized, "Election already finalized");
        
        election.finalized = true;
        emit ElectionFinalized(_electionId);
    }
    
    // Get winner(s) of an election
    function getWinner(uint256 _electionId) 
        public 
        view 
        electionExists(_electionId)
        returns (string memory winnerName, uint256 winnerVotes) 
    {
        Candidate[] memory candidates = electionCandidates[_electionId];
        require(candidates.length > 0, "No candidates in this election");
        
        uint256 maxVotes = 0;
        uint256 winnerId = 0;
        
        for (uint256 i = 0; i < candidates.length; i++) {
            if (candidates[i].voteCount > maxVotes) {
                maxVotes = candidates[i].voteCount;
                winnerId = i;
            }
        }
        
        return (candidates[winnerId].name, maxVotes);
    }
    
    // Update candidate name
    function updateCandidate(
        uint256 _electionId,
        uint256 _candidateId,
        string memory _newName
    ) public onlyAdmin electionExists(_electionId) {
        require(_candidateId < electionCandidates[_electionId].length, "Invalid candidate ID");
        require(bytes(_newName).length > 0, "Name cannot be empty");
        
        electionCandidates[_electionId][_candidateId].name = _newName;
        emit CandidateUpdated(_electionId, _candidateId, _newName);
    }

    // Remove candidate from election
    function removeCandidate(
        uint256 _electionId,
        uint256 _candidateId
    ) public onlyAdmin electionExists(_electionId) {
        require(_candidateId < electionCandidates[_electionId].length, "Invalid candidate ID");
        require(electionCandidates[_electionId].length > 2, "Cannot remove candidate, minimum 2 required");
        
        Election storage election = elections[_electionId];
        
        // Subtract the candidate's votes from total
        election.totalVotes -= electionCandidates[_electionId][_candidateId].voteCount;
        
        // Remove candidate by moving last element to deleted position
        uint256 lastIndex = electionCandidates[_electionId].length - 1;
        if (_candidateId != lastIndex) {
            electionCandidates[_electionId][_candidateId] = electionCandidates[_electionId][lastIndex];
            // Update the moved candidate's ID
            electionCandidates[_electionId][_candidateId].id = _candidateId;
        }
        electionCandidates[_electionId].pop();
        
        emit CandidateRemoved(_electionId, _candidateId);
    }

    // Delete entire election
    function deleteElection(uint256 _electionId) public onlyAdmin electionExists(_electionId) {
        delete elections[_electionId];
        delete electionCandidates[_electionId];
        emit ElectionDeleted(_electionId);
    }
}