const hre = require("hardhat");
const fs = require("fs");
const path = require("path");

async function main() {
  console.log("Deploying VotingSystem contract...");

  const VotingSystem = await hre.ethers.getContractFactory("VotingSystem");
  const votingSystem = await VotingSystem.deploy();

  await votingSystem.waitForDeployment();

  const address = await votingSystem.getAddress();
  console.log("✓ VotingSystem deployed to:", address);

  // Save contract address and ABI to frontend
  const frontendDir = path.join(__dirname, "../../frontend/src/contracts");
  if (!fs.existsSync(frontendDir)) {
    fs.mkdirSync(frontendDir, { recursive: true });
  }

  // Save contract address
  const addressPath = path.join(frontendDir, "contract-address.json");
  fs.writeFileSync(
    addressPath,
    JSON.stringify({ VotingSystem: address }, null, 2)
  );
  console.log("✓ Contract address saved to:", addressPath);

  // Copy ABI to frontend
  const abiSource = path.join(
    __dirname,
    "../artifacts/contracts/VotingSystem.sol/VotingSystem.json"
  );
  const abiDest = path.join(frontendDir, "VotingSystem.json");
  
  const abiFile = JSON.parse(fs.readFileSync(abiSource, "utf8"));
  fs.writeFileSync(abiDest, JSON.stringify(abiFile, null, 2));
  console.log("✓ Contract ABI saved to:", abiDest);

  // Verify files
  if (fs.existsSync(addressPath)) {
    console.log("✓ Verified: contract-address.json exists");
  }
  if (fs.existsSync(abiDest)) {
    console.log("✓ Verified: VotingSystem.json exists");
  }

  // Get admin address
  const [deployer] = await hre.ethers.getSigners();
  console.log("✓ Admin address:", deployer.address);

  console.log("\n📋 Summary:");
  console.log("   Contract:", address);
  console.log("   Admin:", deployer.address);
  console.log("   Network:", hre.network.name);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });