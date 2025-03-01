import { ethers } from "hardhat";

async function main() {
  console.log("Deploying PiggyFactory...");

  const PiggyFactory = await ethers.getContractFactory("PiggyFactory");
  const piggyFactory = await PiggyFactory.deploy();

//   await piggyFactory.deployed();
  console.log(`PiggyFactory deployed to: ${await piggyFactory.getAddress()}`);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("Deployment failed:", error);
    process.exit(1);
  });