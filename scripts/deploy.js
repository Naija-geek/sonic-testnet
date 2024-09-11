// scripts/deploy.js
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
  