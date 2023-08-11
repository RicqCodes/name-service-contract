const { expect } = require("chai");
import { ethers } from "hardhat";

describe("Domain Contract", function () {
  let domainsContract: any;
  let owner: any;
  let addr1: any;
  let addr2: any;

  beforeEach(async function () {
    domainsContract = await ethers.deployContract("Domains", ["zk"]);

    [owner, addr1, addr2] = await ethers.getSigners();
  });

  it("Should register a new domain and retrieve its price", async function () {
    const name = "ricqcodes";
    const price = await domainsContract.price(name);
    console.log("Price:", price.toString());

    // Make sure to fund the testing account on the mainnet with enough Ether
    await domainsContract.connect(addr1).registerDomain(name, { value: price });
    const domainOwner = await domainsContract.getDomainAddress(name);
    expect(domainOwner).to.equal(addr1.address);
  });

  it("Should set and retrieve a record for a domain", async function () {
    const name = "example";
    const record = "some-record";

    // Ensure the domain is registered and funded before setting a record
    await domainsContract.connect(addr1).registerDomain(name, { value: 5e15 });

    await domainsContract.connect(addr1).setRecord(name, record);
    const retrievedRecord = await domainsContract.getRecord(name);
    expect(retrievedRecord).to.equal(record);
  });
});
