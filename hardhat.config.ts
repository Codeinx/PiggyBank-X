import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomicfoundation/hardhat-ethers";
require("dotenv").config();

const config: HardhatUserConfig = {
  solidity: "0.8.28",
  networks: {
    sepolia: { 
      url: process.env.SEPOLIA_RPC_URL || "",
      accounts: [process.env.PRIVATE_KEY || ""],
    },
  },
  etherscan: {
    apiKey: {
      sepolia: "2QQQRJD4H5FC5A83U4ICWTEDWSP8W3H5U1"
    }
  }
};

export default config;
