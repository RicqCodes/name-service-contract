// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.10;

// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// import "@openzeppelin/contracts/utils/Counters.sol";

// import {StringUtils} from "./libraries/StringUtils.sol";

// // import "hardhat/console.sol";

// contract Domains is ERC721URIStorage {
//     using Counters for Counters.Counter;
//     Counters.Counter private _tokenIds;

//     string public tld;

//     struct DomainInfo {
//         address owner;
//         uint256 tokenId;
//     }

//     struct RecordInfo {
//         bool isRecordSet;
//         string record;
//     }

//     mapping(address => string) public userAssociatedName;
//     mapping(string => DomainInfo) public domains;
//     mapping(string => RecordInfo) public records;

//     address payable public owner;
//     string baseURI = "http://localhost:8000/api/test/";

//     // Define an event to emit when a new NFT is minted
//     event DomainRegistered(
//         address indexed owner,
//         uint256 tokenId,
//         string domainName
//     );
//     event AssociatedNameSet(
//         address indexed owner,
//         string name,
//         uint256 timestamp
//     );

//     constructor(string memory _tld) payable ERC721("Sandler Monks", "SMT") {
//         owner = payable(msg.sender);
//         tld = _tld;
//     }

//     function registerDomain(string calldata name) public payable {
//         require(
//             domains[name].owner == address(0),
//             "domain name already exists"
//         );
//         require(bytes(name).length > 2, "length is minimum of 3 characters");
//         require(msg.value >= price(name), "Not enough Matic paid");

//         uint256 newRecordId = _tokenIds.current();

//         // Construct the domain name
//         string memory domainName = string(abi.encodePacked(name, ".", tld));

//         // Mint the NFT and update the domains mapping
//         _safeMint(msg.sender, newRecordId);

//         domains[name] = DomainInfo({owner: msg.sender, tokenId: newRecordId});

//         // Emit the event for reverse address-to-domain lookup
//         emit DomainRegistered(msg.sender, newRecordId, domainName);

//         _tokenIds.increment();
//     }

//     function setAssociatedName(string memory name) public {
//         require(domains[name].owner == msg.sender, "You don't own this name");
//         userAssociatedName[msg.sender] = name;
//         emit AssociatedNameSet(msg.sender, name, block.timestamp);
//     }

//     function getAssociatedName(
//         address user
//     ) public view returns (string memory) {
//         return userAssociatedName[user];
//     }

//     // This function will give us the price of a domain based on length
//     function price(string calldata name) public pure returns (uint256) {
//         uint256 len = StringUtils.strlen(name);
//         require(len > 2, "name cannot be less than 3 characters");
//         if (len == 3) {
//             return 5 * 10 ** 15;
//         } else if (len == 4) {
//             return 4 * 10 ** 15;
//         } else {
//             return 2 * 10 ** 15;
//         }
//     }

//     function getDomainAddress(
//         string calldata name
//     ) public view returns (address) {
//         // Check that the owner is the transaction sender
//         return domains[name].owner;
//     }

//     function setRecord(string calldata name, string calldata record) public {
//         // Check that the owner is the transaction sender
//         require(domains[name].owner == msg.sender, "You don't own this name");
//         require(!records[name].isRecordSet, "Record already set");

//         records[name].record = record;
//         records[name].isRecordSet = true;
//     }

//     function getRecord(
//         string calldata name
//     ) public view returns (string memory) {
//         return records[name].record;
//     }

//     modifier onlyOwner() {
//         require(isOwner());
//         _;
//     }

//     function isOwner() public view returns (bool) {
//         return msg.sender == owner;
//     }

//     function tokenURI(
//         uint256 tokenId
//     ) public view virtual override returns (string memory) {
//         require(
//             _exists(tokenId),
//             "ERC721Metadata: URI query for nonexistent token"
//         );
//         // Generate and return the token URI
//         return string(abi.encodePacked(_baseURI(), Strings.toString(tokenId)));
//     }

//     function _baseURI() internal view override returns (string memory) {
//         return baseURI;
//     }

//     function setBaseURI(string memory newBaseURI) public onlyOwner {
//         baseURI = newBaseURI;
//     }

//     function withdraw() public payable onlyOwner {
//         (bool success, ) = payable(msg.sender).call{
//             value: address(this).balance
//         }("");
//         require(success);
//     }
// }
