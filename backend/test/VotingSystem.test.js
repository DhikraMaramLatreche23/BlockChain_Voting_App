const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("VotingSystem", function () {
  let votingSystem;
  let admin, voter1, voter2;

  beforeEach(async function () {
    [admin, voter1, voter2, voter3] = await ethers.getSigners();
    const VotingSystem = await ethers.getContractFactory("VotingSystem");
    votingSystem = await VotingSystem.deploy();
    await votingSystem.waitForDeployment();  // <-- This line, not .deployed()
  });

  it("Should create an election", async function () {
    const startTime = Math.floor(Date.now() / 1000);
    const endTime = startTime + 86400; // 24 hours later

    await votingSystem.createElection(
      "Club President Election",
      "Vote for the next club president",
      startTime,
      endTime,
      ["Alice", "Bob", "Charlie"]
    );

    const election = await votingSystem.getElection(1);
    expect(election.title).to.equal("Club President Election");
  });

  it("Should register voters and allow voting", async function () {
    const startTime = Math.floor(Date.now() / 1000) - 100;
    const endTime = startTime + 86400;

    await votingSystem.createElection(
      "Test Election",
      "Description",
      startTime,
      endTime,
      ["Candidate 1", "Candidate 2"]
    );

    await votingSystem.registerVoters(1, [voter1.address]);
    
    await votingSystem.connect(voter1).vote(1, 0);
    
    const hasVoted = await votingSystem.checkIfVoted(1, voter1.address);
    expect(hasVoted).to.be.true;
  });
});