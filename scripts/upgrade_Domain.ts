import { ethers, upgrades } from "hardhat";

const main = async () => {
  const DomainV2 = await ethers.getContractFactory("Domains");
  console.log("Upgrading Domain...");
  await upgrades.upgradeProxy(
    "0x44F1521913b979BB2e20eEfA0A7828F056ce4d48",
    DomainV2
  );
  console.log("Domain upgraded");
};

main();
