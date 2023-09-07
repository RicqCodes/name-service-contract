// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.10;

// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// // import "@penzeppelin/contracts/access/Ownable";
// import "@openzeppelin/contracts/utils/Counters.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";

// import {StringUtils} from "./libraries/StringUtils.sol";


// contract Domains is ERC721URIStorage, Ownable {
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

//    mapping(address => string) public userAssociatedName;
//     mapping(string => DomainInfo) public domains;
//     mapping(string => RecordInfo) public records;
//     mapping(uint256 => string) public tokenIdToDomain;

//     string baseURI;

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

//     constructor(string memory _tld) payable ERC721("Sandler Monks", "SM") {    
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

//         tokenIdToDomain[newRecordId] = name;
//         domains[name] = DomainInfo({owner: msg.sender, tokenId: newRecordId});

//         // Emit the event for reverse address-to-domain lookup
//         emit DomainRegistered(msg.sender, newRecordId, domainName);

//         _tokenIds.increment();
//     }

//     function safeTransferFrom(
//         address from,
//         address to,
//         uint256 tokenId
//     ) public override(ERC721, IERC721) {
//         safeTransferFrom(from, to, tokenId, "");
//     }

//     function safeTransferFrom(
//         address from,
//         address to,
//         uint256 tokenId,
//         bytes memory data
//     ) public override(ERC721, IERC721)  {
//         string memory domainName = tokenIdToDomain[tokenId];
//         require(
//             domains[domainName].owner == from,
//             "You can't transfer this token, you dont own it!"
//         );

//         // Transfer the NFT domain to the new owner
//         _safeTransfer(from, to, tokenId, data);
//         domains[domainName] = DomainInfo({owner: to, tokenId: tokenId});
//     }

//    function setAssociatedName(string calldata name) public {
//         require(domains[name].owner == msg.sender, "You don't own this name");
//         string memory domainName = string(abi.encodePacked(name, ".", tld));
//         userAssociatedName[msg.sender] = domainName;
//         emit AssociatedNameSet(msg.sender, domainName, block.timestamp);
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

//     function withdraw() public onlyOwner {
//         require(address(this).balance > 0, "No balance to withdraw");
//         (bool success, ) = payable(owner()).call{value: address(this).balance}(
//             ""
//         );
//         require(success);
//     }
// }
