# Sample TokenDeployment

This project demonstrates a basic contracct deployment on sonic testnet.

Installation on windows 

```shell
npm init -y
npm install hardhat
npx hardhat
npm install @nomiclabs/hardhat-ethers ethers dotenv
```

create a .env file and add the following or .env-example file to .env
```shell
PRIVATE_KEY=ENTER-YOUR-PRIVATE-KEY
SONIC_RPC_URL=https://rpc.testnet.soniclabs.com/
```

Feel free to tweak the contract name and supply in scripts/deploy.js, just change this line

```shell
    const name = "testToken";
    const symbol = "TTK";
    const initialSupply = ethers.utils.parseUnits("1000000", 18); // 1,000,000 tokens with 18 decimals
```

On click installation on Linux
```shell
    chmod +x install.sh
    ./install.sh
```


