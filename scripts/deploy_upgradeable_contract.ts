import { ethers, upgrades } from "hardhat";

const main = async () => {
  const Domain = await ethers.getContractFactory("Domains");
  const domain = await upgrades.deployProxy(Domain, ["vlog"]);

  await domain.waitForDeployment();

  console.log(
    "implentation address",
    await upgrades.erc1967.getImplementationAddress(domain.target as string)
  );

  console.log(`Name service deployed to ${domain.target}`);
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
