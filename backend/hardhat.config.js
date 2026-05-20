// require("@nomicfoundation/hardhat-toolbox");

// module.exports = {
//   solidity: "0.8.19",
//   paths: {
//     artifacts: "../frontend/src/artifacts",
//   },
// };

require("@nomicfoundation/hardhat-toolbox");
const path = require("path");

module.exports = {
  solidity: "0.8.19",
  paths: {
    artifacts: path.join(__dirname, "..", "frontend", "src", "artifacts"),
  },
};