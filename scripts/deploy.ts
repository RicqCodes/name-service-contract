import { ethers } from "hardhat";

const main = async () => {
  const domain = await ethers.deployContract("Domains", ["zk"]);

  await domain.waitForDeployment();

  console.log(`Name service deployed to ${domain.target}`);
  console.log(domain.deploymentTransaction());
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
