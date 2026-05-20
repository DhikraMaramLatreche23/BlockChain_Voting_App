#  Decentralized Voting System - Blockchain-Based Election Platform

> A secure, transparent, and tamper-proof voting platform built on Ethereum using smart contracts, React, and MetaMask.

---

##  Team Members

| Name |
|---|
| **Dhikra Maram LATRECHE** |
| **Maroua BOUZIRA** |
| **Hana SAADI** |
| **Hanane BOUBENIDER** |

---

##  Problem Statement

Traditional voting systems suffer from critical weaknesses:

- Centralized architecture vulnerable to attacks and manipulation
- No easy audit trail or verifiable proof of integrity
- Risk of double voting and reliance on blind trust in authorities

**Core question:** Can blockchain ensure secure, transparent, and verifiable elections while preserving voter privacy?

---

##  Objectives

**Primary Goals:**
- Immutable vote recording enforced by smart contracts
- One-vote-per-address rule — no double voting possible
- Transparent, on-chain vote counting with full auditability
- Deployment on Ethereum-compatible networks

**Success Metrics:**
-  Zero double-voting incidents
-  100% vote immutability
-  Full transaction audit via blockchain explorer
-  Fast transaction confirmation (~2 seconds)

---

##  System Overview

A fully decentralized voting platform where:

- Elections are created and managed on-chain by an admin
- Only registered, eligible voters can participate
- Votes are cast through a MetaMask wallet — no central server involved
- Results are computed automatically with no human intervention
- Every transaction is permanently auditable on the blockchain

### High-Level Workflow

```
Admin creates election
       ↓
Admin registers eligible voters
       ↓
Voters submit votes (via MetaMask)
       ↓
System calculates and displays winner
```

---

##  System Components

### Frontend
- **React.js** — UI framework
- **TailwindCSS** — styling
- **Ethers.js** — blockchain interactions

### Blockchain Layer
- **Solidity** — smart contract language
- **Ethereum-compatible network** (Hardhat local node for development)
- **MetaMask** — wallet integration for vote signing

### Data & Storage
- All election data stored on-chain
- Votes are cryptographically hashed and immutable — no off-chain database required

---

##  Smart Contract Design

### Roles
- **Admin** — creates elections, registers voters, finalizes results
- **Voter** — casts a vote if eligible and within the active election period

### Core Data Structures

```solidity
struct Election {
    uint256 id;
    string title;
    uint256 startTime;
    uint256 endTime;
    bool finalized;
    uint256 totalVotes;
}

struct Candidate {
    uint256 id;
    string name;
    uint256 voteCount;
}
```

### Key Functions

| Function | Description |
|---|---|
| `createElection()` | Admin creates a new election → emits `ElectionCreated` event |
| `registerVoters()` | Admin registers eligible voter addresses on-chain |
| `vote()` | Voter signs and submits their vote via MetaMask |
| `getWinner()` | Reads vote counts and returns the winner — no gas cost |

---

##  Security & Integrity

### On-Chain Protections
- `onlyAdmin` modifier restricts administrative functions
- `hasVoted` mapping prevents any address from voting twice
- `electionActive` modifier ensures votes are only accepted during the valid time window

### Blockchain Guarantees
- Immutable record of all transactions
- ECDSA signature verification via MetaMask wallets
- Replay attacks prevented through Ethereum's built-in nonce mechanism

---

##  Frontend Features

| Component | Description |
|---|---|
| **Header** | Wallet connection via MetaMask |
| **Election List** | Displays all elections and their candidates |
| **Candidate Card** | Vote buttons for each candidate |
| **Admin Modal** | Create and manage elections |

- Real-time state updates after blockchain confirmation
- Error handling for ineligible voters and duplicate vote attempts

---

##  Testing & Deployment

### Testing (Hardhat)
- **Unit tests** — election creation, voter registration, double-vote prevention
- **Integration tests** — full end-to-end voting workflow
- **Manual tests** — multiple elections and concurrent voters

### Deployment
- Local development via Hardhat node
- Compatible with any Ethereum-compatible network (e.g., Sepolia testnet, mainnet)

---

##  Use Cases

This system is applicable in any context requiring fair, auditable voting:

-  Student and scientific club elections
-  Course feedback and project evaluations
-  Competition judging systems
-  Academic governance and committee decisions
- Any environment requiring transparent and tamper-proof decision-making

---

##  Learning Outcomes

Through this project, the team gained hands-on experience with:

- **Blockchain & Ethereum** — fundamental principles and real-world application
- **Smart contract development** — writing, testing, and deploying Solidity contracts
- **Decentralized application (dApp) design** — building user-focused apps on-chain
- **Web3 frontend integration** — connecting React UIs to live blockchain data via Ethers.js

---

##  Getting Started

### Prerequisites
- Node.js v18+
- MetaMask browser extension
- npm or yarn

### Installation

```bash
# Clone the repository
git clone https://github.com/your-username/decentralized-voting-system.git
cd decentralized-voting-system

# Install dependencies
npm install

# Compile smart contracts
npx hardhat compile

# Run local blockchain node
npx hardhat node

# Deploy contracts to local node
npx hardhat run scripts/deploy.js --network localhost

# Start the frontend
cd frontend
npm install
npm start
```

---

##  Project Structure

```
decentralized-voting-system/
│
├── contracts/
│   └── Voting.sol              # Main smart contract
│
├── scripts/
│   └── deploy.js               # Deployment script
│
├── test/
│   ├── voting.test.js          # Unit & integration tests
│
├── frontend/
│   ├── src/
│   │   ├── components/         # React UI components
│   │   ├── pages/              # App pages
│   │   └── utils/              # Ethers.js helpers
│   └── tailwind.config.js
│
├── hardhat.config.js
└── README.md
```

> **Note:** Adjust the structure above to match your actual repository layout.

---

##  Future Improvements

- **Zero-Knowledge Proofs (ZKP)** — hide individual votes while maintaining verifiability
- **Layer 2 deployment** — reduce gas fees (e.g., Polygon, Optimism)
- **Role-based voter tiers** — weighted voting for specific governance contexts
- **Mobile-friendly interface** — support WalletConnect for mobile voters
- **IPFS integration** — store election metadata off-chain without centralization

---

##  License

This project was developed as part of an academic program at ENSIA. Feel free to use, adapt, and build upon it for educational purposes.
