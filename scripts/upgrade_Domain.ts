import { ethers, upgrades } from "hardhat";

const main = async () => {
  const DomainV2 = await ethers.getContractFactory("Domains");
  console.log("Upgrading Domain...");
  await upgrades.upgradeProxy(
    "0x1d390AE05533780B789F41BEcD82da83D3D4c4D9",
    DomainV2
  );
  console.log("Domain upgraded");
};

main();
