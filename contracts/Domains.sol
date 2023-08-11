// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import {StringUtils} from "./libraries/StringUtils.sol";
import {Base64} from "./libraries/Base64.sol";

import "hardhat/console.sol";

contract Domains is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string public tld;

    string svgPartOne =
        '<svg xmlns="http://www.w3.org/2000/svg" width="270" height="270" fill="none"><path fill="url(#B)" d="M0 0h270v270H0z"/><defs><filter id="A" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse" height="270" width="270"><feDropShadow dx="0" dy="1" stdDeviation="2" flood-opacity=".225" width="200%" height="200%"/></filter></defs><circle cx="18" cy="18" r="62" style="fill:#0092ff"/><path d="M516.3 361.83c60.28 0 108.1 37.18 126.26 92.47H764C742 336.09 644.47 256 517.27 256 372.82 256 260 365.65 260 512.49S370 768 517.27 768c124.35 0 223.82-80.09 245.84-199.28H642.55c-17.22 55.3-65 93.45-125.32 93.45-83.23 0-141.56-63.89-141.56-149.68.04-86.77 57.43-150.66 140.63-150.66z" fill="#fff"/><defs><linearGradient id="B" x1="0" y1="0" x2="270" y2="270" gradientUnits="userSpaceOnUse"><stop stop-color="#e088fb"/><stop offset="1" stop-color="#74f7ff" stop-opacity="1"/></linearGradient></defs><text x="32.5" y="231" font-size="27" fill="#fff" filter="url(#A)" font-family="Noto Serif Vithkuqi Plus Jakarta Sans,DejaVu Sans,Noto Color Emoji,Apple Color Emoji,sans-serif" font-weight="bold">';
    string svgPartTwo = "</text></svg>";

    struct DomainInfo {
        address owner;
        uint256 tokenId;
    }

    mapping(string => address) public domains;
    mapping(string => string) public records;

    address payable public owner;

    // Define an event to emit when a new NFT is minted
    event DomainRegistered(
        address indexed owner,
        uint256 tokenId,
        string domainName
    );

    constructor(
        string memory _tld
    ) payable ERC721("Test-Zero-Knowledge", "TZK") {
        owner = payable(msg.sender);
        tld = _tld;
    }

    function registerDomain(string calldata name) public payable {
        require(domains[name] == address(0));
        require(bytes(name).length > 2, "length is minimum of 3 characters");
        require(msg.value >= price(name), "Not enough Matic paid");
        // uint256 _price = price(name);
        // uint256 len = StringUtils.strlen(name);

        uint256 newRecordId = _tokenIds.current();

        // Construct the domain name
        string memory domainName = string(abi.encodePacked(name, ".", tld));

        // Combine the name passed into the function  with the TLD
        // string memory _name = string(abi.encodePacked(name, ".", tld));
        // Create the SVG (image) for the NFT with the name
        string memory finalSvg = string(
            abi.encodePacked(svgPartOne, _name, svgPartTwo)
        );

        // Create the JSON metadata of the NFT
        string memory json = Base64.encode(
            abi.encodePacked(
                '{"name": "',
                domainName,
                '", "description": "A domain on the test name service", "image": "data:image/svg+xml;base64,',
                Base64.encode(bytes(svgPartOne, domainName, svgPartTwo)),
                '"}'
            )
        );

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        // Mint the NFT and update the domains mapping
        _safeMint(msg.sender, newRecordId);
        _setTokenURI(newRecordId, finalTokenUri);
        domains[name] = DomainInfo({owner: msg.sender, tokenId: newRecordId});

        // Emit the event for reverse address-to-domain lookup
        emit DomainRegistered(msg.sender, newRecordId, domainName);

        _tokenIds.increment();
    }

    // This function will give us the price of a domain based on length
    function price(string calldata name) public pure returns (uint256) {
        uint256 len = StringUtils.strlen(name);
        require(len > 2);
        if (len == 3) {
            return 5 * 10 ** 15;
        } else if (len == 4) {
            return 4 * 10 ** 15; // To charge smaller amounts, reduce the decimals. This is 0.3
        } else {
            return 2 * 10 ** 15;
        }
    }

    // Other functions unchanged

    function getDomainAddress(
        string calldata name
    ) public view returns (address) {
        // Check that the owner is the transaction sender
        return domains[name];
    }

    // Function to get the name associated with an address
    function getNameFromAddress(
        address walletAddress
    ) public view returns (string memory) {
        return addressToDomain[walletAddress];
    }

    function setRecord(string calldata name, string calldata record) public {
        // Check that the owner is the transaction sender
        require(domains[name] == msg.sender);
        records[name] = record;
    }

    function getRecord(
        string calldata name
    ) public view returns (string memory) {
        return records[name];
    }

    modifier onlyOwner() {
        require(isOwner());
        _;
    }

    function isOwner() public view returns (bool) {
        return msg.sender == owner;
    }

    function withdraw() public onlyOwner {
        uint256 amount = address(this).balance;

        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Failed to withdraw");
    }
}
