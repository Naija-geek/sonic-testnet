require("@nomiclabs/hardhat-ethers");
require("dotenv").config();

module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.8.18", // For newer contracts
      },
      {
        version: "0.8.20", // If some contracts require an older version
      }
    ],
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
    sonicTestnet: {
      url: process.env.SONIC_RPC_URL,
      accounts: [process.env.PRIVATE_KEY],
    },
  },
};
