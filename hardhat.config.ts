import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@openzeppelin/hardhat-upgrades";
import "dotenv/config";

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.19",
    settings: {
      optimizer: {
        enabled: true,
        runs: 1000,
      },
    },
  },
  networks: {
    sepolia: {
      url: process.env.ALCHEMY_RPC,
      accounts: [process.env.key!],
    },
    base: {
      url: process.env.ANKR_RPC,
      accounts: [process.env.key!],
    },
    base_goerli: {
      url: process.env.ANKR_RPC_GOERLI,
      accounts: [process.env.key!],
      gasPrice: 3000000,
    },
  },
  etherscan: {
    apiKey: process.env.BASESCAN,
  },
};

export default config;
