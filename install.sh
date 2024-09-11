#!/bin/bash

BOLD=$(tput bold)
RESET=$(tput sgr0)
YELLOW=$(tput setaf 3)

print_command() {
  echo -e "${BOLD}${YELLOW}$1${RESET}"
}

if command -v nvm &> /dev/null
then
    print_command "NVM is already installed."
else
    print_command "Installing NVM and Node..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"

    if [ -s "$NVM_DIR/nvm.sh" ]; then
        . "$NVM_DIR/nvm.sh"
    elif [ -s "/usr/local/share/nvm/nvm.sh" ]; then
        . "/usr/local/share/nvm/nvm.sh"
    else
        echo "Error: nvm.sh not found!"
        exit 1
    fi
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi


if command -v node &> /dev/null
then
    print_command "Node is already installed."
else
    print_command "Using Node version manager (nvm)..."
    nvm install node
    nvm use node
fi

print_command "Installing hardhat and dotenv package..."
npm install --save-dev hardhat dotenv
echo
print_command "Initializing..."
npx hardhat init
echo
rm -rf contracts
mkdir -p contracts

cat <<EOF > contracts/Token.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Else is ERC20 {
    constructor(string memory name, string memory symbol, uint256 initialSupply) ERC20(name, symbol) {
        _mint(msg.sender, initialSupply * 10 ** decimals());
    }
}
EOF

mkdir -p scripts
cat <<EOF > scripts/deploy.js
async function main() {
    const Token = await ethers.getContractFactory("Else");
  
    const name = "else";
    const symbol = "ELS";
    const initialSupply = ethers.utils.parseUnits("1000000", 18); // 1,000,000 tokens with 18 decimals
  
    // Deploy the contract
    const token = await Token.deploy(name, symbol, initialSupply);
  
    await token.deployed();
  
    console.log("Token deployed to:", token.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
  
EOF

print_command "Removing hardhat.config.js file..."
rm hardhat.config.js

print_command "Updating hardhat.config.js..."
cat <<EOF > hardhat.config.js
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
      url: "https://rpc.testnet.soniclabs.com/",
      accounts: [\`0x\${process.env.PRIVATE_KEY}\`],
    },
  },
};
EOF

read -p "Enter your EVM wallet private key (without 0x): " WALLET_PRIVATE_KEY

print_command "Generating .env file..."
cat <<EOF > .env
PRIVATE_KEY=$WALLET_PRIVATE_KEY
EOF

print_command "Compiling smart contracts..."
npx hardhat compile

print_command "Deploying smart contracts..."
npx hardhat run scripts/deploy.js --network sonicTestnet